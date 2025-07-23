@echo off
setlocal enabledelayedexpansion
chcp 65001 > nul
rem UTF-8 인코딩 사용

title Chrome Burp Proxy Launcher v2.0 Pro by DBDROP

rem ==================================================
rem  Chrome Burp Proxy Launcher v2.0 Professional
rem  Created by DBDROP (swm5048@naver.com)
rem  Enhanced Security & Validation Features
rem ==================================================

set "VERSION=2.0"
set "AUTHOR=DBDROP (swm5048@naver.com)"
set "CHROME_PATH=C:\Program Files\Google\Chrome\Application\chrome.exe"
set "BURP_EXE_NAME=BurpSuiteCommunity.exe"
set "DEFAULT_BURP_PATH=%USERPROFILE%\AppData\Local\Programs\BurpSuiteCommunity\BurpSuiteCommunity.exe"
set "BURP_PATH="
set "PROXY_PORT=8080"
set "LOG_DIR=C:\Temp\BurpLauncher_Logs"
set "LOG_FILE=%LOG_DIR%\launcher_%date:~0,4%%date:~5,2%%date:~8,2%.log"
set "CONFIG_FILE=%~dp0config.ini"

rem 로그 디렉토리 생성
if not exist "%LOG_DIR%" mkdir "%LOG_DIR%" 2>nul

rem 로깅 함수 초기화
call :WriteLog "===== Chrome Burp Proxy Launcher v%VERSION% 시작 ====="
call :WriteLog "작성자: %AUTHOR%"

echo.
echo  Chrome Burp Proxy Launcher v%VERSION% Professional을 초기화하는 중입니다...
echo  로그 파일: %LOG_FILE%
echo.

rem 관리자 권한 확인
call :CheckAdminRights

rem 시스템 요구사항 검증
call :ValidateSystemRequirements

rem 설정 파일 로드
call :LoadConfig

rem 네트워크 정보 수집
call :GetNetworkInfo

rem Burp Suite 경로 확인
call :FindBurp

goto MENU

rem ==================================================
rem  새로운 기능: 로깅 시스템
rem ==================================================
:WriteLog
set "timestamp=%date% %time%"
echo [%timestamp%] %~1 >> "%LOG_FILE%" 2>nul
exit /b

rem ==================================================
rem  새로운 기능: 관리자 권한 확인
rem ==================================================
:CheckAdminRights
net session >nul 2>&1
if %errorlevel% neq 0 (
    call :WriteLog "[경고] 관리자 권한이 없습니다. 일부 기능이 제한될 수 있습니다."
    echo  [경고] 관리자 권한이 없습니다. 최적의 성능을 위해 관리자로 실행을 권장합니다.
) else (
    call :WriteLog "[정보] 관리자 권한으로 실행 중"
    echo  [확인] 관리자 권한으로 실행 중입니다.
)
exit /b

rem ==================================================
rem  새로운 기능: 시스템 요구사항 검증
rem ==================================================
:ValidateSystemRequirements
call :WriteLog "[검증] 시스템 요구사항 확인 시작"

rem Chrome 설치 확인
if not exist "%CHROME_PATH%" (
    call :WriteLog "[오류] Chrome이 설치되지 않았습니다: %CHROME_PATH%"
    echo  [오류] Google Chrome이 설치되지 않았습니다.
    echo  [해결] https://www.google.com/chrome/ 에서 Chrome을 다운로드하여 설치하세요.
    pause
    exit /b 1
)
call :WriteLog "[확인] Chrome 설치 확인됨: %CHROME_PATH%"

rem 임시 디렉토리 쓰기 권한 확인
echo test > "C:\Temp\write_test.tmp" 2>nul
if %errorlevel% neq 0 (
    call :WriteLog "[오류] C:\Temp 디렉토리에 쓰기 권한이 없습니다"
    echo  [오류] 임시 디렉토리에 쓰기 권한이 없습니다.
    pause
    exit /b 1
) else (
    del "C:\Temp\write_test.tmp" 2>nul
    call :WriteLog "[확인] 임시 디렉토리 쓰기 권한 확인됨"
)

rem 네트워크 연결 확인
ping -n 1 8.8.8.8 >nul 2>&1
if %errorlevel% equ 0 (
    call :WriteLog "[확인] 인터넷 연결 상태 양호"
) else (
    call :WriteLog "[경고] 인터넷 연결 확인 실패"
    echo  [경고] 인터넷 연결을 확인할 수 없습니다. 외부 IP 조회가 제한될 수 있습니다.
)

call :WriteLog "[검증] 시스템 요구사항 확인 완료"
exit /b

rem ==================================================
rem  새로운 기능: 설정 파일 관리
rem ==================================================
:LoadConfig
if exist "%CONFIG_FILE%" (
    call :WriteLog "[설정] 기존 설정 파일 로드: %CONFIG_FILE%"
    for /f "tokens=1,2 delims==" %%a in (%CONFIG_FILE%) do (
        if "%%a"=="PROXY_PORT" set "PROXY_PORT=%%b"
        if "%%a"=="BURP_PATH" set "BURP_PATH=%%b"
    )
) else (
    call :WriteLog "[설정] 기본 설정으로 초기화"
)
exit /b

:SaveConfig
call :WriteLog "[설정] 설정 파일 저장: %CONFIG_FILE%"
(
    echo PROXY_PORT=%PROXY_PORT%
    echo BURP_PATH=%BURP_PATH%
    echo LAST_UPDATE=%date% %time%
    echo AUTHOR=%AUTHOR%
) > "%CONFIG_FILE%"
exit /b

rem ==================================================
rem  개선된 네트워크 정보 수집
rem ==================================================
:GetNetworkInfo
call :WriteLog "[네트워크] IP 정보 수집 시작"

rem 내부 IP 주소 가져오기 (개선된 방식)
set "INTERNAL_IP=조회 실패"
for /f "tokens=2 delims=:" %%i in ('ipconfig ^| findstr /R /C:"IPv4.*192.168" 2^>nul') do (
    set "temp=%%i"
    set "INTERNAL_IP=!temp:~1!"
    goto :gotInternalIP
)
for /f "tokens=2 delims=:" %%i in ('ipconfig ^| findstr /R /C:"IPv4.*10\." 2^>nul') do (
    set "temp=%%i"
    set "INTERNAL_IP=!temp:~1!"
    goto :gotInternalIP
)
for /f "tokens=2 delims=:" %%i in ('ipconfig ^| findstr /R /C:"IPv4.*172\." 2^>nul') do (
    set "temp=%%i"
    set "INTERNAL_IP=!temp:~1!"
    goto :gotInternalIP
)
:gotInternalIP

rem 외부 IP 주소 가져오기 (다중 서비스 지원)
set "EXTERNAL_IP=조회 실패"
for %%s in (ifconfig.me ipinfo.io/ip icanhazip.com) do (
    for /f %%i in ('curl -s --connect-timeout 5 %%s 2^>nul') do (
        set "EXTERNAL_IP=%%i"
        goto :gotExternalIP
    )
)
:gotExternalIP

call :WriteLog "[네트워크] 내부 IP: %INTERNAL_IP%"
call :WriteLog "[네트워크] 외부 IP: %EXTERNAL_IP%"
exit /b

rem ==================================================
rem  개선된 Burp Suite 탐지
rem ==================================================
:FindBurp
call :WriteLog "[Burp] Burp Suite 경로 탐지 시작"
echo  Burp Suite 경로를 확인하는 중입니다...

rem 설정 파일에서 경로 확인
if defined BURP_PATH if exist "%BURP_PATH%" (
    call :WriteLog "[Burp] 설정 파일에서 경로 확인됨: %BURP_PATH%"
    echo  [설정] 저장된 경로에서 찾음: %BURP_PATH%
    goto :BurpFound
)

rem 기본 경로 확인
if exist "%DEFAULT_BURP_PATH%" (
    set "BURP_PATH=%DEFAULT_BURP_PATH%"
    call :WriteLog "[Burp] 기본 경로에서 발견: %BURP_PATH%"
    echo  [기본] Burp Suite 경로: %BURP_PATH%
    goto :BurpFound
)

rem 시스템 전체 검색 (개선된 방식)
echo  기본 경로에서 찾지 못했습니다. 시스템을 검색합니다...
set "SEARCH_PATHS=C:\Program Files;C:\Program Files (x86);%USERPROFILE%\AppData\Local;%USERPROFILE%\Desktop"

for %%p in (%SEARCH_PATHS%) do (
    call :WriteLog "[Burp] 검색 중: %%p"
    for /r "%%p" %%i in (%BURP_EXE_NAME%) do (
        set "BURP_PATH=%%i"
        call :WriteLog "[Burp] 발견됨: !BURP_PATH!"
        echo  [검색] Burp Suite 경로: !BURP_PATH!
        goto :BurpFound
    )
)

rem Burp Suite Professional도 검색
for /r "C:\Program Files" %%i in (BurpSuitePro.exe) do (
    set "BURP_PATH=%%i"
    set "BURP_EXE_NAME=BurpSuitePro.exe"
    call :WriteLog "[Burp] Burp Suite Professional 발견: !BURP_PATH!"
    echo  [검색] Burp Suite Professional 경로: !BURP_PATH!
    goto :BurpFound
)

call :WriteLog "[오류] Burp Suite 실행 파일을 찾을 수 없음"
echo  [오류] Burp Suite 실행 파일을 찾을 수 없습니다.
echo  [안내] 다음 중 하나를 설치하세요:
echo         - Burp Suite Community Edition
echo         - Burp Suite Professional
echo  [다운로드] https://portswigger.net/burp/communitydownload
pause
exit /b 1

:BurpFound
call :SaveConfig
exit /b

rem ==================================================
rem  개선된 메인 메뉴
rem ==================================================
:MENU
cls
echo.
echo ==================================================
echo      Chrome Burp Proxy Launcher v%VERSION% Professional
echo      Created by %AUTHOR%
echo ==================================================
echo.
echo  외부 IP: %EXTERNAL_IP%
echo  내부 IP: %INTERNAL_IP% 
echo  현재 프록시 포트: %PROXY_PORT%
echo  Burp Suite: %BURP_EXE_NAME%
echo.

rem 현재 시스템 프록시 상태 확인 (개선된 방식)
call :CheckProxyStatus

echo  시스템 프록시 상태: %PROXY_ENABLED%
if defined CURRENT_PROXY echo  현재 시스템 프록시: %CURRENT_PROXY%
echo.

rem 실행 중인 프로세스 상태 표시
call :ShowProcessStatus

echo --------------------------------------------------
echo  1. Chrome 실행 (Burp Proxy 사용)
echo  2. 프록시 설정 해제
echo  3. 프록시 포트 변경
echo  4. 연결 상태 진단
echo  5. 로그 파일 보기
echo  6. 설정 초기화
echo --------------------------------------------------
echo.
choice /c 123456 /n /m " 선택하세요 (1-6): "
if errorlevel 6 goto reset_config
if errorlevel 5 goto show_logs
if errorlevel 4 goto diagnose
if errorlevel 3 goto port_change
if errorlevel 2 goto no_proxy
if errorlevel 1 goto use_proxy

rem ==================================================
rem  새로운 기능: 프록시 상태 확인
rem ==================================================
:CheckProxyStatus
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
exit /b

rem ==================================================
rem  새로운 기능: 프로세스 상태 표시
rem ==================================================
:ShowProcessStatus
set "CHROME_STATUS=중지됨"
set "BURP_STATUS=중지됨"

tasklist /FI "IMAGENAME eq chrome.exe" | find /I "chrome.exe" > nul
if %errorlevel%==0 set "CHROME_STATUS=실행 중"

tasklist /FI "IMAGENAME eq %BURP_EXE_NAME%" | find /I "%BURP_EXE_NAME%" > nul
if %errorlevel%==0 set "BURP_STATUS=실행 중"

echo  Chrome 상태: %CHROME_STATUS%
echo  Burp Suite 상태: %BURP_STATUS%
echo.
exit /b

rem ==================================================
rem  개선된 Chrome 실행 (보안 강화)
rem ==================================================
:use_proxy
call :WriteLog "[실행] Chrome Burp Proxy 모드 시작"
call :CheckBurp
call :NotifyChromeRunning
echo.
echo.
echo ==================================================
echo        Chrome을 Burp Proxy 모드로 실행합니다
echo ==================================================
echo.
echo  프록시 설정: 127.0.0.1:%PROXY_PORT%
echo  프로필: 완전히 새로운 격리된 프로필
echo  보안 모드: 강화된 격리 설정 적용
echo.

rem 포트 사용 가능성 확인
call :CheckPortAvailability %PROXY_PORT%

rem 기존 Chrome 프로세스 안전하게 종료
call :SafeTerminateChrome

rem 시스템 프록시 설정 활성화
call :SetSystemProxy

rem 보안 강화된 Chrome 프로필 생성
call :CreateSecureProfile

rem Chrome 실행 (보안 강화된 설정)
call :LaunchSecureChrome

echo.
echo  [성공] Burp Suite 프록시 연결이 설정되었습니다.
echo  [보안] 강화된 격리 모드로 Chrome이 실행되었습니다.
echo  [경로] 프로필 위치: %PROFILE_DIR%
echo.
call :ShowProxyInstructions
echo.
echo  Chrome Burp Proxy Launcher v%VERSION% Professional by %AUTHOR%
echo.
pause
goto MENU

rem ==================================================
rem  새로운 기능: 포트 사용 가능성 확인
rem ==================================================
:CheckPortAvailability
netstat -an | find ":%~1 " >nul
if %errorlevel% equ 0 (
    call :WriteLog "[경고] 포트 %~1이 이미 사용 중입니다"
    echo  [경고] 포트 %~1이 이미 사용 중입니다. Burp Suite에서 사용 중인지 확인하세요.
) else (
    call :WriteLog "[확인] 포트 %~1 사용 가능"
)
exit /b

rem ==================================================
rem  새로운 기능: 안전한 Chrome 종료
rem ==================================================
:SafeTerminateChrome
call :WriteLog "[작업] Chrome 프로세스 안전 종료 시작"
echo  [작업] 기존 Chrome 프로세스를 안전하게 종료합니다...

rem 먼저 정상 종료 시도
tasklist /FI "IMAGENAME eq chrome.exe" | find /I "chrome.exe" > nul
if %errorlevel%==0 (
    echo  [단계1] 정상 종료 시도 중...
    taskkill /im chrome.exe >nul 2>&1
    timeout /t 3 >nul
    
    rem 여전히 실행 중이면 강제 종료
    tasklist /FI "IMAGENAME eq chrome.exe" | find /I "chrome.exe" > nul
    if %errorlevel%==0 (
        echo  [단계2] 강제 종료 실행 중...
        taskkill /f /im chrome.exe >nul 2>&1
        timeout /t 2 >nul
    )
)
call :WriteLog "[완료] Chrome 프로세스 종료 완료"
exit /b

rem ==================================================
rem  새로운 기능: 시스템 프록시 설정
rem ==================================================
:SetSystemProxy
set "REG_PATH=HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings"
set "PROXY_SERVER=127.0.0.1:%PROXY_PORT%"

call :WriteLog "[프록시] 시스템 프록시 설정: %PROXY_SERVER%"

rem 프록시 설정 활성화
reg add "%REG_PATH%" /v ProxyEnable /t REG_DWORD /d 1 /f >nul 2>&1
reg add "%REG_PATH%" /v ProxyServer /t REG_SZ /d %PROXY_SERVER% /f >nul 2>&1

rem 프록시 우회 설정 - 로컬 주소 및 사설 IP 대역 우회
reg add "%REG_PATH%" /v ProxyOverride /t REG_SZ /d "<local>;localhost;127.*;10.*;172.16.*;192.168.*" /f >nul 2>&1

echo  [확인] 시스템 프록시 설정이 활성화되었습니다: %PROXY_SERVER%
call :WriteLog "[완료] 시스템 프록시 설정 완료"
exit /b

rem ==================================================
rem  새로운 기능: 보안 강화된 프로필 생성
rem ==================================================
:CreateSecureProfile
call :WriteLog "[프로필] 보안 강화된 Chrome 프로필 생성 시작"

rem 기존 ChromeBurpProfile 폴더 정리
echo  [정리] 기존 ChromeBurpProfile 폴더를 검색하고 제거합니다...
if exist "C:\Temp\ChromeBurpProfile-*" (
    for /d %%i in (C:\Temp\ChromeBurpProfile-*) do (
        echo  [제거] 이전 프로필 폴더 제거: %%i
        call :WriteLog "[정리] 프로필 폴더 제거: %%i"
        rd /s /q "%%i" 2>nul
    )
)

rem 보안 강화된 프로필 생성
set "PROFILE_ID=%RANDOM%%RANDOM%"
set "PROFILE_DIR=C:\Temp\ChromeBurpProfile-%PROFILE_ID%"

if not exist "C:\Temp" mkdir "C:\Temp" 2>nul
mkdir "%PROFILE_DIR%" 2>nul
mkdir "%PROFILE_DIR%\Default" 2>nul

rem 보안 강화된 Chrome 설정 파일 생성
(
echo {
echo   "profile": {
echo     "default_content_setting_values": {
echo       "cookies": 1,
echo       "javascript": 1,
echo       "plugins": 2,
echo       "popups": 2,
echo       "geolocation": 2,
echo       "notifications": 2,
echo       "media_stream": 2
echo     },
echo     "exit_type": "Normal",
echo     "exited_cleanly": true,
echo     "managed_user_id": "",
echo     "name": "Burp Security Testing Profile"
echo   },
echo   "security": {
echo     "ssl_error_override_allowed": true
echo   }
echo }
) > "%PROFILE_DIR%\Default\Preferences" 2>nul

echo  [생성] 보안 강화된 프로필 경로: %PROFILE_DIR%
call :WriteLog "[프로필] 생성 완료: %PROFILE_DIR%"
exit /b

rem ==================================================
rem  새로운 기능: 보안 강화된 Chrome 실행
rem ==================================================
:LaunchSecureChrome
call :WriteLog "[Chrome] 보안 강화 모드로 Chrome 실행"
echo  [실행] Chrome을 보안 강화된 새 프로필로 시작합니다...

start "" "%CHROME_PATH%" ^
  --proxy-server="127.0.0.1:%PROXY_PORT%" ^
  --user-data-dir="%PROFILE_DIR%" ^
  --no-first-run ^
  --no-default-browser-check ^
  --disable-extensions ^
  --disable-component-extensions-with-background-pages ^
  --disable-background-networking ^
  --disable-sync ^
  --disable-translate ^
  --disable-plugins ^
  --disable-java ^
  --disable-flash ^
  --disable-webgl ^
  --disable-3d-apis ^
  --disable-accelerated-2d-canvas ^
  --disable-accelerated-video-decode ^
  --metrics-recording-only ^
  --disable-blink-features=AutomationControlled ^
  --window-position=100,100 ^
  --window-size=1200,800 ^
  --incognito ^
  --ignore-certificate-errors ^
  --ignore-ssl-errors ^
  --allow-running-insecure-content ^
  --disable-web-security ^
  about:blank

call :WriteLog "[Chrome] 실행 완료"
exit /b

rem ==================================================
rem  새로운 기능: 프록시 사용 안내
rem ==================================================
:ShowProxyInstructions
echo  [중요] 프록시 패킷이 잡히지 않는 경우 다음을 확인하세요:
echo         1) Burp Suite의 Proxy 탭 → Options에서 리스너 확인
echo         2) 리스너가 127.0.0.1:%PROXY_PORT%에 바인딩되어 있는지 확인
echo         3) Intercept 탭에서 'Intercept is on'으로 설정 확인
echo         4) Chrome에서 https://burp 방문하여 CA 인증서 설치
echo.
echo  [팁] SSL/TLS 인증서 오류 해결:
echo       1. Chrome에서 https://burp 접속
echo       2. 'CA Certificate' 다운로드
echo       3. 인증서를 '신뢰할 수 있는 루트 인증 기관'에 설치
exit /b

rem ==================================================
rem  개선된 프록시 해제
rem ==================================================
:no_proxy
call :WriteLog "[프록시] 프록시 설정 해제 시작"
call :NotifyChromeRunning
echo.
echo.
echo ==================================================
echo             프록시 설정을 해제합니다
echo ==================================================
echo.

set "REG_PATH=HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings"

reg query "%REG_PATH%" /v ProxyEnable >nul 2>&1
if %errorlevel% equ 0 (
    for /f "tokens=3*" %%a in ('reg query "%REG_PATH%" /v ProxyServer ^| findstr /i "ProxyServer"') do (
        echo  [정보] 현재 설정된 프록시 서버: %%a
        call :WriteLog "[프록시] 기존 설정: %%a"
    )
    
    reg add "%REG_PATH%" /v ProxyEnable /t REG_DWORD /d 0 /f >nul 2>&1
    echo  [성공] 시스템 프록시 설정이 성공적으로 해제되었습니다.
    call :WriteLog "[프록시] 시스템 프록시 해제 완료"
) else (
    echo  [정보] 현재 시스템 프록시 설정이 이미 비활성화되어 있습니다.
    call :WriteLog "[프록시] 이미 비활성화 상태"
)

echo.
echo  [참고] 변경사항을 적용하려면 Chrome을 완전히 종료 후 재실행하세요.
echo  [참고] 이 설정은 시스템 전체 프록시 설정을 해제합니다.
echo.
pause
goto MENU

rem ==================================================
rem  개선된 포트 변경
rem ==================================================
:port_change
call :WriteLog "[설정] 프록시 포트 변경 시작"
echo.
echo.
echo ==================================================
echo              프록시 포트 설정 변경
echo ==================================================
echo.
echo   현재 설정: %PROXY_PORT%
echo   권장 포트: 8080 (기본), 8443 (HTTPS), 9090 (대안)
echo.
set /p NEW_PORT=" 새 포트 번호를 입력하세요 (1024-65535): "

rem 입력값 검증
echo %NEW_PORT%| findstr /r "^[0-9][0-9]*$" >nul
if %errorlevel% neq 0 (
    echo.
    echo  [오류] 유효한 포트 번호가 아닙니다. 숫자만 입력해주세요.
    call :WriteLog "[오류] 잘못된 포트 번호 입력: %NEW_PORT%"
    pause
    goto MENU
)

rem 포트 범위 확인 (1024-65535, 시스템 포트 제외)
if %NEW_PORT% LSS 1024 (
    echo.
    echo  [오류] 포트 번호는 1024 이상이어야 합니다. (시스템 포트 제외)
    pause
    goto MENU
)

if %NEW_PORT% GTR 65535 (
    echo.
    echo  [오류] 포트 번호는 65535 이하여야 합니다.
    pause
    goto MENU
)

rem 포트 사용 중 확인
netstat -an | find ":%NEW_PORT% " >nul
if %errorlevel% equ 0 (
    echo.
    echo  [경고] 포트 %NEW_PORT%가 이미 사용 중입니다.
    choice /c YN /n /m " 계속하시겠습니까? (Y/N): "
    if errorlevel 2 goto MENU
)

set "PROXY_PORT=%NEW_PORT%"
call :SaveConfig
echo.
echo  [성공] 프록시 포트가 %PROXY_PORT%로 변경되었습니다.
echo  [중요] Burp Suite Proxy 리스너 설정도 이 포트로 변경해야 합니다.
echo  [안내] Burp Suite → Proxy → Options → Proxy Listeners에서 포트 변경
call :WriteLog "[설정] 프록시 포트 변경 완료: %PROXY_PORT%"
echo.
pause
goto MENU

rem ==================================================
rem  새로운 기능: 연결 상태 진단
rem ==================================================
:diagnose
call :WriteLog "[진단] 연결 상태 진단 시작"
echo.
echo.
echo ==================================================
echo              연결 상태 진단
echo ==================================================
echo.

echo  [1단계] 네트워크 연결 상태 확인
ping -n 1 127.0.0.1 >nul 2>&1
if %errorlevel% equ 0 (
    echo  ✓ 로컬호스트 연결 정상
) else (
    echo  ✗ 로컬호스트 연결 실패
)

echo.
echo  [2단계] 프록시 포트 상태 확인
netstat -an | find ":%PROXY_PORT% " >nul
if %errorlevel% equ 0 (
    echo  ✓ 포트 %PROXY_PORT% 사용 중 (Burp Suite 실행 중일 가능성)
) else (
    echo  ✗ 포트 %PROXY_PORT% 사용되지 않음 (Burp Suite 미실행일 가능성)
)

echo.
echo  [3단계] 프로세스 상태 확인
tasklist /FI "IMAGENAME eq %BURP_EXE_NAME%" | find /I "%BURP_EXE_NAME%" > nul
if %errorlevel%==0 (
    echo  ✓ Burp Suite 실행 중
) else (
    echo  ✗ Burp Suite 실행되지 않음
)

tasklist /FI "IMAGENAME eq chrome.exe" | find /I "chrome.exe" > nul
if %errorlevel%==0 (
    echo  ✓ Chrome 실행 중
) else (
    echo  ✗ Chrome 실행되지 않음
)

echo.
echo  [4단계] 시스템 프록시 설정 확인
call :CheckProxyStatus
if "%PROXY_ENABLED%"=="활성화" (
    echo  ✓ 시스템 프록시 활성화됨: %CURRENT_PROXY%
) else (
    echo  ✗ 시스템 프록시 비활성화됨
)

echo.
echo  [5단계] 인터넷 연결 확인
ping -n 1 8.8.8.8 >nul 2>&1
if %errorlevel% equ 0 (
    echo  ✓ 외부 네트워크 연결 정상
) else (
    echo  ✗ 외부 네트워크 연결 실패
)

echo.
echo  [진단 완료] 위 결과를 참고하여 문제를 해결하세요.
call :WriteLog "[진단] 연결 상태 진단 완료"
echo.
pause
goto MENU

rem ==================================================
rem  새로운 기능: 로그 파일 보기
rem ==================================================
:show_logs
echo.
echo.
echo ==================================================
echo              로그 파일 보기
echo ==================================================
echo.
echo  로그 파일 위치: %LOG_FILE%
echo.

if exist "%LOG_FILE%" (
    echo  [최근 로그 내용]
    echo  ----------------------------------------
    type "%LOG_FILE%" | more
    echo  ----------------------------------------
    echo.
    choice /c YN /n /m " 로그 파일을 메모장으로 열어보시겠습니까? (Y/N): "
    if not errorlevel 2 start notepad "%LOG_FILE%"
) else (
    echo  [정보] 로그 파일이 아직 생성되지 않았습니다.
)

echo.
pause
goto MENU

rem ==================================================
rem  새로운 기능: 설정 초기화
rem ==================================================
:reset_config
echo.
echo.
echo ==================================================
echo              설정 초기화
echo ==================================================
echo.
echo  [주의] 다음 설정이 초기화됩니다:
echo         - 프록시 포트 설정
echo         - Burp Suite 경로 설정
echo         - 사용자 설정 파일
echo.
choice /c YN /n /m " 정말로 설정을 초기화하시겠습니까? (Y/N): "
if errorlevel 2 goto MENU

call :WriteLog "[설정] 설정 초기화 시작"

rem 설정 파일 삭제
if exist "%CONFIG_FILE%" (
    del "%CONFIG_FILE%" 2>nul
    echo  [완료] 설정 파일이 삭제되었습니다.
)

rem 기본값으로 재설정
set "PROXY_PORT=8080"
set "BURP_PATH="

echo  [완료] 설정이 기본값으로 초기화되었습니다.
call :WriteLog "[설정] 설정 초기화 완료"
echo.
pause

rem Burp Suite 경로 재탐지
call :FindBurp
goto MENU

rem ==================================================
rem  개선된 Burp Suite 실행 확인
rem ==================================================
:CheckBurp
call :WriteLog "[Burp] Burp Suite 실행 상태 확인"

rem 더 정확한 프로세스 확인
set "BURP_RUNNING=0"
for /f "skip=1 tokens=2" %%A in ('wmic process where "name='%BURP_EXE_NAME%'" get ProcessId 2^>nul') do (
    if not "%%A"=="" (
        set "BURP_PID=%%A"
        for /f "skip=1 tokens=2*" %%X in ('wmic process where "ProcessId=%%A" get ExecutablePath 2^>nul') do (
            if not "%%Y"=="" (
                set "BURP_RUNNING=1"
                call :WriteLog "[Burp] 실행 중 확인됨 PID: %%A, 경로: %%Y"
                goto :BurpRunningCheck
            )
        )
    )
)

:BurpRunningCheck
if "!BURP_RUNNING!"=="1" (
    echo  [확인] Burp Suite가 이미 실행 중입니다. (PID: !BURP_PID!)
) else (
    echo  [실행] Burp Suite를 시작합니다...
    call :WriteLog "[Burp] Burp Suite 실행 시작: %BURP_PATH%"
    start "" "%BURP_PATH%"
    echo  [대기] Burp Suite가 완전히 로드될 때까지 15초 대기합니다...
    timeout /t 15 > nul
    echo  [확인] Burp Suite 실행 완료.
    echo  [중요] Burp Suite Proxy 리스너가 127.0.0.1:%PROXY_PORT%에 설정되어 있는지 확인하세요.
    call :WriteLog "[Burp] Burp Suite 실행 완료"
)
exit /b

rem ==================================================
rem  Chrome 실행 확인 (기존 함수 유지)
rem ==================================================
:NotifyChromeRunning
tasklist /FI "IMAGENAME eq chrome.exe" | find /I "chrome.exe" > nul
if %errorlevel%==0 (
    echo  [주의] 현재 Chrome이 실행 중입니다. 안전하게 종료 후 새 프로필로 실행됩니다.
    call :WriteLog "[Chrome] 기존 Chrome 실행 중 감지"
)
exit /b
