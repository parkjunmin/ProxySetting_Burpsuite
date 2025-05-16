@echo off
setlocal enabledelayedexpansion
chcp 65001 > nul
rem UTF-8 인코딩 사용

title Chrome Burp Proxy Launcher v1.2 by DBDROP

rem ==================================================
rem  Chrome Burp Proxy Launcher v1.2
rem  Created by DBDROP (swm5048@naver.com)
rem ==================================================

set "CHROME_PATH=C:\Program Files\Google\Chrome\Application\chrome.exe"
set "BURP_EXE_NAME=BurpSuiteCommunity.exe"
set "DEFAULT_BURP_PATH=%USERPROFILE%\AppData\Local\Programs\BurpSuiteCommunity\BurpSuiteCommunity.exe"
set "BURP_PATH="
set "PROXY_PORT=8080"

echo.
echo  Chrome Burp Proxy Launcher를 초기화하는 중입니다...
echo.

:: 내부 IP 주소 가져오기
set "INTERNAL_IP="
for /f "tokens=2 delims=:" %%i in ('ipconfig ^| findstr /R /C:"IPv4.*"') do (
    set "temp=%%i"
    set "INTERNAL_IP=!temp:~1!"
    goto :gotIP
)
:gotIP

:: 외부 IP 주소 가져오기
for /f %%i in ('curl -s ifconfig.me 2^>nul') do set "EXTERNAL_IP=%%i"
if "%EXTERNAL_IP%"=="" set "EXTERNAL_IP=조회 실패 (curl 또는 인터넷 연결 확인)"

:: Burp Suite 경로 확인
:FindBurp
echo  Burp Suite 경로를 확인하는 중입니다...
if exist "%DEFAULT_BURP_PATH%" (
    set "BURP_PATH=%DEFAULT_BURP_PATH%"
    echo  [찾음] Burp Suite 경로: %BURP_PATH%
    goto MENU
)

echo  기본 경로에서 찾지 못했습니다. 시스템을 검색합니다...
for /r "C:\Program Files" %%i in (%BURP_EXE_NAME%) do (
    set "BURP_PATH=%%i"
    echo  [찾음] Burp Suite 경로: !BURP_PATH!
    goto MENU
)

for /r "C:\Program Files (x86)" %%i in (%BURP_EXE_NAME%) do (
    set "BURP_PATH=%%i"
    echo  [찾음] Burp Suite 경로: !BURP_PATH!
    goto MENU
)

for /r "%USERPROFILE%\AppData\Local" %%i in (%BURP_EXE_NAME%) do (
    set "BURP_PATH=%%i"
    echo  [찾음] Burp Suite 경로: !BURP_PATH!
    goto MENU
)

echo  [오류] Burp Suite 실행 파일을 찾을 수 없습니다.
echo  [안내] Burp Suite가 설치되어 있는지 확인하세요.
pause
exit /b

:: 메인 메뉴
:MENU
cls
echo.
echo ==================================================
echo      Chrome Burp Proxy Launcher v1.2 by DBDROP
echo      (swm5048@naver.com)
echo ==================================================
echo.
echo  외부 IP: %EXTERNAL_IP%
echo  내부 IP: %INTERNAL_IP% 
echo  현재 프록시 포트: %PROXY_PORT%
echo.

:: 현재 시스템 프록시 상태 확인
set "REG_PATH=HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings"
set "PROXY_ENABLED=비활성화"
set "CURRENT_PROXY="

reg query "%REG_PATH%" /v ProxyEnable >nul 2>&1
if %errorlevel% equ 0 (
    for /f "tokens=3" %%a in ('reg query "%REG_PATH%" /v ProxyEnable ^| findstr /i "ProxyEnable"') do (
        if "%%a"=="0x1" (
            set "PROXY_ENABLED=활성화"
            for /f "tokens=3*" %%b in ('reg query "%REG_PATH%" /v ProxyServer ^| findstr /i "ProxyServer"') do (
                set "CURRENT_PROXY=%%b"
            )
        )
    )
)

echo  시스템 프록시 상태: %PROXY_ENABLED%
if defined CURRENT_PROXY echo  현재 시스템 프록시: %CURRENT_PROXY%
echo.
echo --------------------------------------------------
echo  1. Chrome 실행 (Burp Proxy 사용)
echo  2. 프록시 설정 해제
echo  3. 프록시 포트 변경
echo --------------------------------------------------
echo.
choice /c 123 /n /m " 선택하세요 (1-3): "
if errorlevel 3 goto port_change
if errorlevel 2 goto no_proxy
if errorlevel 1 goto use_proxy

:use_proxy
call :CheckBurp
call :NotifyChromeRunning
echo.
echo.
echo ==================================================
echo        Chrome을 Burp Proxy 모드로 실행합니다
echo ==================================================
echo.
echo  프록시 설정: 127.0.0.1:%PROXY_PORT%
echo  프로필: 완전히 새로운 프로필로 생성됨
echo.

:: 기존 Chrome 프로세스 종료 시도
echo  [작업] 기존 Chrome 프로세스를 종료합니다...
taskkill /f /im chrome.exe >nul 2>&1

:: 잠시 대기
timeout /t 2 >nul

:: 시스템 프록시 설정 활성화
set "REG_PATH=HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings"
set "PROXY_SERVER=127.0.0.1:%PROXY_PORT%"

:: 프록시 설정 활성화
reg add "%REG_PATH%" /v ProxyEnable /t REG_DWORD /d 1 /f >nul 2>&1
reg add "%REG_PATH%" /v ProxyServer /t REG_SZ /d %PROXY_SERVER% /f >nul 2>&1

:: 프록시 우회 설정 - 로컬 주소는 우회
reg add "%REG_PATH%" /v ProxyOverride /t REG_SZ /d "<local>" /f >nul 2>&1

:: 설정 확인
echo  [확인] 시스템 프록시 설정이 활성화되었습니다: %PROXY_SERVER%

:: 기존 ChromeBurpProfile 폴더 정리
echo  [정리] 기존 ChromeBurpProfile 폴더를 검색하고 제거합니다...
if exist "C:\Temp\ChromeBurpProfile-*" (
    for /d %%i in (C:\Temp\ChromeBurpProfile-*) do (
        echo  [제거] 이전 프로필 폴더 제거: %%i
        rd /s /q "%%i" 2>nul
    )
)

:: 완전히 새로운 프로필 생성 (C 드라이브 임시 폴더에 생성)
set "PROFILE_ID=%RANDOM%%RANDOM%"
set "PROFILE_DIR=C:\Temp\ChromeBurpProfile-%PROFILE_ID%"

:: 임시 디렉토리가 없으면 생성
if not exist "C:\Temp" mkdir "C:\Temp" 2>nul

:: 프로필 디렉토리 생성
mkdir "%PROFILE_DIR%" 2>nul
mkdir "%PROFILE_DIR%\Default" 2>nul

:: 고급 설정: 새 프로필용 Chrome 기본 설정 파일 생성
echo { "profile": { "default_content_setting_values": { "cookies": 1 }, "exit_type": "Normal", "exited_cleanly": true } } > "%PROFILE_DIR%\Default\Preferences" 2>nul

:: 프로필 경로 출력하여 확인
echo  [경로] 생성된 프로필 경로: %PROFILE_DIR%

:: Chrome 시작 (완전히 격리된 모드)
echo  [실행] Chrome을 새 프로필로 시작합니다...
start "" "%CHROME_PATH%" ^
  --proxy-server="%PROXY_SERVER%" ^
  --user-data-dir="%PROFILE_DIR%" ^
  --no-first-run ^
  --no-default-browser-check ^
  --disable-extensions ^
  --disable-component-extensions-with-background-pages ^
  --disable-background-networking ^
  --disable-sync ^
  --disable-translate ^
  --metrics-recording-only ^
  --disable-blink-features=AutomationControlled ^
  --window-position=100,100 ^
  --window-size=1200,800 ^
  --incognito ^
  about:blank

echo.
echo  [성공] Burp Suite 프록시 연결이 설정되었습니다.
echo  [성공] 완전히 새로운 Chrome 프로필이 생성되었습니다.
echo  [경로] 프로필 위치: %PROFILE_DIR%
echo.
echo  [참고] 프록시 포트 %PROXY_PORT%를 통해 패킷이 Burp Suite로 전달됩니다.
echo  [중요] 프록시 패킷이 잡히지 않는 경우 다음을 확인하세요:
echo         1) BurpSuite의 Proxy 탭 - Options에서 리스너가 추가되어 있는지 확인
echo         2) Proxy 리스너가 %PROXY_PORT%에 바인딩되어 있는지 확인 
echo         3) Intercept 탭에서 'Intercept is on'으로 설정되어 있는지 확인
echo.
echo  Chrome Burp Proxy Launcher v1.2 by DBDROP (swm5048@naver.com)
echo.
pause
goto MENU

:no_proxy
call :NotifyChromeRunning
echo.
echo.
echo ==================================================
echo             프록시 설정을 해제합니다
echo ==================================================
echo.

:: 레지스트리 경로
set "REG_PATH=HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings"

:: 현재 프록시 설정 확인
reg query "%REG_PATH%" /v ProxyEnable >nul 2>&1
if %errorlevel% equ 0 (
    :: 레지스트리에서 현재 프록시 서버 설정 가져오기
    for /f "tokens=3" %%a in ('reg query "%REG_PATH%" /v ProxyServer ^| findstr /i "ProxyServer"') do (
        echo  [정보] 현재 설정된 프록시 서버: %%a
    )
    
    :: 프록시 설정 해제
    reg add "%REG_PATH%" /v ProxyEnable /t REG_DWORD /d 0 /f >nul 2>&1
    echo  [성공] 시스템 프록시 설정이 성공적으로 해제되었습니다.
) else (
    echo  [정보] 현재 시스템 프록시 설정이 이미 비활성화되어 있습니다.
)

echo.
echo  [참고] 적용하려면 Chrome을 완전히 종료 후 직접 Chrome을 실행하세요.
echo  [참고] 이 설정은 시스템 전체 프록시 설정을 해제합니다.
echo.
pause
goto MENU

:port_change
echo.
echo.
echo ==================================================
echo              프록시 포트 설정 변경
echo ==================================================
echo.
echo   현재 설정: %PROXY_PORT%
echo.
set /p NEW_PORT=" 새 포트 번호를 입력하세요 (0-65535): "

rem 숫자만 입력했는지 확인 및 범위 검증
echo %NEW_PORT%| findstr /r "^[0-9][0-9]*$" >nul
if %errorlevel% neq 0 (
    echo.
    echo  [오류] 유효한 포트 번호가 아닙니다. 숫자만 입력해주세요.
    pause
    goto MENU
)

rem 포트 범위 확인 (0-65535)
if %NEW_PORT% LSS 0 (
    echo.
    echo  [오류] 포트 번호는 0 이상이어야 합니다.
    pause
    goto MENU
)

if %NEW_PORT% GTR 65535 (
    echo.
    echo  [오류] 포트 번호는 65535 이하여야 합니다.
    pause
    goto MENU
)

set "PROXY_PORT=%NEW_PORT%"
echo.
echo  [성공] 프록시 포트가 %PROXY_PORT%로 변경되었습니다.
echo  [안내] Burp Suite Proxy 리스너 설정도 이 포트로 변경해야 합니다.
echo.
pause
goto MENU

:: Burp 실행 여부 확인 및 실행
:CheckBurp
rem 기존 WMIC 방식은 BurpSuite가 실행중이지 않아도 CommandLine에 경로가 남아있거나, 여러 인스턴스가 있을 때 오탐이 발생할 수 있음
rem 이미지명과 경로를 모두 체크하여 정확히 실행중인지 확인
set "BURP_RUNNING=0"
for /f "skip=3 tokens=2,*" %%A in ('tasklist /FI "IMAGENAME eq %BURP_EXE_NAME%" /FO LIST 2^>nul') do (
    if /i "%%A"=="PID:" (
        set "BURP_PID=%%B"
        for /f "skip=1 tokens=2,*" %%X in ('wmic process where "ProcessId=%%B" get ExecutablePath 2^>nul') do (
            if /i "%%Y"=="!BURP_PATH!" (
                set "BURP_RUNNING=1"
            )
        )
    )
)
if "!BURP_RUNNING!"=="1" (
    echo  [확인] Burp Suite가 이미 실행 중입니다.
) else (
    echo  [실행] Burp Suite를 시작합니다...
    start "" "!BURP_PATH!"
    echo  [대기] Burp Suite가 로드될 때까지 10초 대기합니다...
    timeout /t 10 > nul
    echo  [확인] Burp Suite가 실행 중입니다.
    echo  [중요] Burp Suite Proxy 리스너가 포트 %PROXY_PORT%에 바인딩되어 있는지 확인하세요.
)
exit /b

:: Chrome 실행 여부 확인
:NotifyChromeRunning
tasklist /FI "IMAGENAME eq chrome.exe" | find /I "chrome.exe" > nul
if %errorlevel%==0 (
    echo  [주의] 현재 Chrome이 실행 중입니다. 잠시 후 종료됩니다.
)
exit /b
