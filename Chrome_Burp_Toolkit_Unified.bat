@echo off
setlocal enabledelayedexpansion
chcp 65001 > nul
rem UTF-8 인코딩 사용

title Chrome Burp Suite Toolkit Unified v2.0 Pro by DBDROP

rem ==================================================
rem  Chrome Burp Suite Toolkit Unified v2.0 Professional
rem  Created by DBDROP (swm5048@naver.com)
rem  통합된 Chrome Burp 보안 테스트 도구
rem  
rem  기존 3개 파일 통합:
rem  - Burp_Start.bat (메인 Chrome Burp Proxy Launcher)
rem  - Quick_Launch.bat (통합 실행 메뉴)
rem  - System_Check.bat (시스템 환경 검증)
rem ==================================================

set "VERSION=2.0 Unified"
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
call :WriteLog "===== Chrome Burp Suite Toolkit Unified v%VERSION% 시작 ====="
call :WriteLog "작성자: %AUTHOR%"

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

goto MAIN_MENU

rem ==================================================
rem  메인 메뉴 시스템
rem ==================================================
:MAIN_MENU
cls
echo.
echo ████████████████████████████████████████████████████████████████
echo ██                                                            ██
echo ██    Chrome Burp Suite Toolkit Unified v%VERSION%           ██
echo ██    Created by %AUTHOR%                  ██
echo ██                                                            ██
echo ████████████████████████████████████████████████████████████████
echo.
echo  웹 애플리케이션 보안 테스트를 위한 통합 전문 도구
echo.
echo  외부 IP: %EXTERNAL_IP%
echo  내부 IP: %INTERNAL_IP% 
echo  현재 프록시 포트: %PROXY_PORT%
echo  Burp Suite: %BURP_EXE_NAME%
echo.

rem 현재 시스템 프록시 상태 확인
call :CheckProxyStatus
echo  시스템 프록시 상태: %PROXY_ENABLED%
if defined CURRENT_PROXY echo  현재 시스템 프록시: %CURRENT_PROXY%

rem 실행 중인 프로세스 상태 표시
call :ShowProcessStatus

echo.
echo  ┌────────────────────────────────────────────────────────────┐
echo  │                     메인 메뉴                              │
echo  ├────────────────────────────────────────────────────────────┤
echo  │                                                            │
echo  │  1. 🚀 Chrome 실행 (Burp Proxy 사용)                     │
echo  │     └─ Chrome과 Burp Suite를 연동하여 보안 테스트 시작    │
echo  │                                                            │
echo  │  2. 🔒 프록시 설정 해제                                   │
echo  │     └─ 시스템 프록시 설정을 비활성화                      │
echo  │                                                            │
echo  │  3. ⚙️  프록시 포트 변경                                   │
echo  │     └─ Burp Suite 연결 포트 설정 변경                     │
echo  │                                                            │
echo  │  4. 🔍 연결 상태 진단                                     │
echo  │     └─ 네트워크 및 프로세스 상태 확인                     │
echo  │                                                            │
echo  │  5. 📊 시스템 환경 검사                                   │
echo  │     └─ 전체 시스템 상태 진단 및 문제 해결                 │
echo  │                                                            │
echo  │  6. 📋 로그 파일 보기                                     │
echo  │     └─ 상세한 실행 로그 확인                              │
echo  │                                                            │
echo  │  7. 🔧 고급 설정 메뉴                                     │
echo  │     └─ 설정 초기화, 호환성 검사, 자동 복구               │
echo  │                                                            │
echo  │  8. 📚 사용법 및 도움말                                   │
echo  │     └─ 상세한 사용 가이드 및 문제 해결 방법               │
echo  │                                                            │
echo  │  9. ℹ️  프로그램 정보                                      │
echo  │     └─ 버전 정보 및 개발자 정보                           │
echo  │                                                            │
echo  │  0. ❌ 종료                                               │
echo  │                                                            │
echo  └────────────────────────────────────────────────────────────┘
echo.

choice /c 1234567890 /n /m " 선택하세요 (0-9): "
if errorlevel 10 goto EXIT
if errorlevel 9 goto INFO
if errorlevel 8 goto HELP
if errorlevel 7 goto ADVANCED_MENU
if errorlevel 6 goto show_logs
if errorlevel 5 goto SYSTEM_CHECK_MENU
if errorlevel 4 goto diagnose
if errorlevel 3 goto port_change
if errorlevel 2 goto no_proxy
if errorlevel 1 goto use_proxy

rem ==================================================
rem  로깅 시스템
rem ==================================================
:WriteLog
set "timestamp=%date% %time%"
echo [%timestamp%] %~1 >> "%LOG_FILE%" 2>nul
exit /b

rem ==================================================
rem  관리자 권한 확인
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
rem  시스템 요구사항 검증 (Windows 오류 대응 강화)
rem ==================================================
:ValidateSystemRequirements
call :WriteLog "[검증] 시스템 요구사항 확인 시작"

rem Windows 버전 확인
for /f "tokens=4-5 delims=. " %%i in ('ver') do set VERSION=%%i.%%j
call :WriteLog "[시스템] Windows 버전: %VERSION%"

rem Chrome 설치 확인 (다중 경로 지원)
set "CHROME_FOUND=0"
set "CHROME_PATHS=%CHROME_PATH%;"
set "CHROME_PATHS=%CHROME_PATHS%C:\Program Files (x86)\Google\Chrome\Application\chrome.exe;"
set "CHROME_PATHS=%CHROME_PATHS%%LOCALAPPDATA%\Google\Chrome\Application\chrome.exe;"
set "CHROME_PATHS=%CHROME_PATHS%%USERPROFILE%\AppData\Local\Google\Chrome\Application\chrome.exe"

for %%p in (%CHROME_PATHS%) do (
    if exist "%%p" (
        set "CHROME_PATH=%%p"
        set "CHROME_FOUND=1"
        call :WriteLog "[확인] Chrome 발견: %%p"
        goto :ChromeFound
    )
)

:ChromeFound
if %CHROME_FOUND%==0 (
    call :WriteLog "[오류] Chrome이 설치되지 않았습니다"
    echo  [오류] Google Chrome이 설치되지 않았습니다.
    echo  [해결] https://www.google.com/chrome/ 에서 Chrome을 다운로드하여 설치하세요.
    pause
    exit /b 1
)

rem 임시 디렉토리 생성 및 권한 확인
if not exist "C:\Temp" (
    mkdir "C:\Temp" 2>nul
    if %errorlevel% neq 0 (
        call :WriteLog "[오류] C:\Temp 디렉토리 생성 실패"
        echo  [오류] 임시 디렉토리를 생성할 수 없습니다.
        pause
        exit /b 1
    )
)

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

call :WriteLog "[검증] 시스템 요구사항 확인 완료"
exit /b

rem ==================================================
rem  설정 파일 관리
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
rem  네트워크 정보 수집
rem ==================================================
:GetNetworkInfo
call :WriteLog "[네트워크] IP 정보 수집 시작"

rem 내부 IP 주소 가져오기
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
:gotInternalIP

rem 외부 IP 주소 가져오기
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
rem  Burp Suite 탐지
rem ==================================================
:FindBurp
call :WriteLog "[Burp] Burp Suite 경로 탐지 시작"

rem 설정 파일에서 경로 확인
if defined BURP_PATH if exist "%BURP_PATH%" (
    call :WriteLog "[Burp] 설정 파일에서 경로 확인됨: %BURP_PATH%"
    goto :BurpFound
)

rem 기본 경로 확인
if exist "%DEFAULT_BURP_PATH%" (
    set "BURP_PATH=%DEFAULT_BURP_PATH%"
    call :WriteLog "[Burp] 기본 경로에서 발견: %BURP_PATH%"
    goto :BurpFound
)

rem 시스템 전체 검색
set "SEARCH_PATHS=C:\Program Files;C:\Program Files (x86);%USERPROFILE%\AppData\Local;%USERPROFILE%\Desktop"

for %%p in (%SEARCH_PATHS%) do (
    for /r "%%p" %%i in (%BURP_EXE_NAME%) do (
        set "BURP_PATH=%%i"
        call :WriteLog "[Burp] 발견됨: !BURP_PATH!"
        goto :BurpFound
    )
)

rem Burp Suite Professional도 검색
for /r "C:\Program Files" %%i in (BurpSuitePro.exe) do (
    set "BURP_PATH=%%i"
    set "BURP_EXE_NAME=BurpSuitePro.exe"
    call :WriteLog "[Burp] Burp Suite Professional 발견: !BURP_PATH!"
    goto :BurpFound
)

call :WriteLog "[오류] Burp Suite 실행 파일을 찾을 수 없음"
echo  [오류] Burp Suite 실행 파일을 찾을 수 없습니다.
echo  [다운로드] https://portswigger.net/burp/communitydownload
pause
exit /b 1

:BurpFound
call :SaveConfig
exit /b

rem ==================================================
rem  프록시 상태 확인
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
rem  프로세스 상태 표시
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
exit /b

rem ==================================================
rem  Chrome 실행 (보안 강화)
rem ==================================================
:use_proxy
call :WriteLog "[실행] Chrome Burp Proxy 모드 시작"
call :CheckBurp
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
echo.
call :ShowProxyInstructions
echo.
pause
goto MAIN_MENU

rem ==================================================
rem  포트 사용 가능성 확인
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
rem  안전한 Chrome 종료
rem ==================================================
:SafeTerminateChrome
call :WriteLog "[작업] Chrome 프로세스 안전 종료 시작"
echo  [작업] 기존 Chrome 프로세스를 안전하게 종료합니다...

tasklist /FI "IMAGENAME eq chrome.exe" | find /I "chrome.exe" > nul
if %errorlevel%==0 (
    echo  [단계1] 정상 종료 시도 중...
    taskkill /im chrome.exe >nul 2>&1
    timeout /t 3 >nul
    
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
rem  시스템 프록시 설정
rem ==================================================
:SetSystemProxy
set "REG_PATH=HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings"
set "PROXY_SERVER=127.0.0.1:%PROXY_PORT%"

call :WriteLog "[프록시] 시스템 프록시 설정: %PROXY_SERVER%"

reg add "%REG_PATH%" /v ProxyEnable /t REG_DWORD /d 1 /f >nul 2>&1
reg add "%REG_PATH%" /v ProxyServer /t REG_SZ /d %PROXY_SERVER% /f >nul 2>&1
reg add "%REG_PATH%" /v ProxyOverride /t REG_SZ /d "<local>;localhost;127.*;10.*;172.16.*;192.168.*" /f >nul 2>&1

echo  [확인] 시스템 프록시 설정이 활성화되었습니다: %PROXY_SERVER%
call :WriteLog "[완료] 시스템 프록시 설정 완료"
exit /b

rem ==================================================
rem  보안 강화된 프로필 생성
rem ==================================================
:CreateSecureProfile
call :WriteLog "[프로필] 보안 강화된 Chrome 프로필 생성 시작"

echo  [정리] 기존 ChromeBurpProfile 폴더를 검색하고 제거합니다...
if exist "C:\Temp\ChromeBurpProfile-*" (
    for /d %%i in (C:\Temp\ChromeBurpProfile-*) do (
        call :WriteLog "[정리] 프로필 폴더 제거: %%i"
        rd /s /q "%%i" 2>nul
    )
)

set "PROFILE_ID=%RANDOM%%RANDOM%"
set "PROFILE_DIR=C:\Temp\ChromeBurpProfile-%PROFILE_ID%"

if not exist "C:\Temp" mkdir "C:\Temp" 2>nul
mkdir "%PROFILE_DIR%" 2>nul
mkdir "%PROFILE_DIR%\Default" 2>nul

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
rem  보안 강화된 Chrome 실행
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
rem  프록시 사용 안내
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
rem  프록시 해제
rem ==================================================
:no_proxy
call :WriteLog "[프록시] 프록시 설정 해제 시작"
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
echo.
pause
goto MAIN_MENU

rem ==================================================
rem  포트 변경
rem ==================================================
:port_change
call :WriteLog "[설정] 프록시 포트 변경 시작"
echo.
echo ==================================================
echo              프록시 포트 설정 변경
echo ==================================================
echo.
echo   현재 설정: %PROXY_PORT%
echo   권장 포트: 8080 (기본), 8443 (HTTPS), 9090 (대안)
echo.
set /p NEW_PORT=" 새 포트 번호를 입력하세요 (1024-65535): "

echo %NEW_PORT%| findstr /r "^[0-9][0-9]*$" >nul
if %errorlevel% neq 0 (
    echo.
    echo  [오류] 유효한 포트 번호가 아닙니다. 숫자만 입력해주세요.
    pause
    goto MAIN_MENU
)

if %NEW_PORT% LSS 1024 (
    echo.
    echo  [오류] 포트 번호는 1024 이상이어야 합니다.
    pause
    goto MAIN_MENU
)

if %NEW_PORT% GTR 65535 (
    echo.
    echo  [오류] 포트 번호는 65535 이하여야 합니다.
    pause
    goto MAIN_MENU
)

netstat -an | find ":%NEW_PORT% " >nul
if %errorlevel% equ 0 (
    echo.
    echo  [경고] 포트 %NEW_PORT%가 이미 사용 중입니다.
    choice /c YN /n /m " 계속하시겠습니까? (Y/N): "
    if errorlevel 2 goto MAIN_MENU
)

set "PROXY_PORT=%NEW_PORT%"
call :SaveConfig
echo.
echo  [성공] 프록시 포트가 %PROXY_PORT%로 변경되었습니다.
echo  [중요] Burp Suite Proxy 리스너 설정도 이 포트로 변경해야 합니다.
call :WriteLog "[설정] 프록시 포트 변경 완료: %PROXY_PORT%"
echo.
pause
goto MAIN_MENU

rem ==================================================
rem  연결 상태 진단
rem ==================================================
:diagnose
call :WriteLog "[진단] 연결 상태 진단 시작"
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
goto MAIN_MENU

rem ==================================================
rem  시스템 환경 검사 메뉴
rem ==================================================
:SYSTEM_CHECK_MENU
cls
echo.
echo ==================================================
echo      Chrome Burp System Checker v2.0
echo      Created by DBDROP (swm5048@naver.com)
echo ==================================================
echo.
echo  시스템 환경을 검증하고 문제를 진단합니다.
echo.

rem 관리자 권한 확인
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo  [경고] 관리자 권한이 없습니다. 일부 검사가 제한될 수 있습니다.
    echo.
) else (
    echo  [확인] 관리자 권한으로 실행 중입니다.
    echo.
)

echo  검사를 시작합니다...
echo.

rem 1. 시스템 정보 수집
echo  [1단계] 시스템 정보 수집
echo  ========================================

echo  OS 버전:
ver
echo.

echo  시스템 아키텍처:
wmic os get osarchitecture /value | findstr "="

echo  사용 가능한 메모리:
wmic OS get TotalVisibleMemorySize,FreePhysicalMemory /value | findstr "="

echo  디스크 여유 공간 (C:):
for /f "tokens=3" %%a in ('dir C:\ ^| findstr "bytes free"') do echo  C:\ 여유 공간: %%a bytes

echo.

rem 2. 필수 소프트웨어 확인
echo  [2단계] 필수 소프트웨어 확인
echo  ========================================

rem Chrome 확인
if exist "%CHROME_PATH%" (
    echo  ✓ Google Chrome 설치됨: %CHROME_PATH%
    for /f "tokens=*" %%v in ('"%CHROME_PATH%" --version 2^>nul') do echo    버전: %%v
) else (
    echo  ✗ Google Chrome이 설치되지 않았습니다.
    echo    다운로드: https://www.google.com/chrome/
)

echo.

rem Burp Suite 확인
if exist "%DEFAULT_BURP_PATH%" (
    echo  ✓ Burp Suite Community 설치됨: %DEFAULT_BURP_PATH%
) else (
    echo  ✗ Burp Suite Community가 기본 경로에 없습니다.
)

set "BURP_PRO_FOUND=0"
for /r "C:\Program Files" %%i in (BurpSuitePro.exe) do (
    echo  ✓ Burp Suite Professional 발견: %%i
    set "BURP_PRO_FOUND=1"
)

if !BURP_PRO_FOUND!==0 (
    echo  ✗ Burp Suite Professional이 발견되지 않았습니다.
)

if not exist "%DEFAULT_BURP_PATH%" if !BURP_PRO_FOUND!==0 (
    echo    다운로드: https://portswigger.net/burp/communitydownload
)

echo.

rem Chrome AutoUpdate 확장 프로그램 안내
echo  Chrome AutoUpdate 확장 프로그램 (권장):
echo  └─ 보안 테스트 자동화를 위한 전용 확장 프로그램
echo  └─ 설치: https://chromewebstore.google.com/detail/chromeautoupdate/ddcjfdggpnkjeigdalbfgmmanbndampa

echo.

rem 3. 네트워크 연결 확인
echo  [3단계] 네트워크 연결 확인
echo  ========================================

ping -n 1 127.0.0.1 >nul 2>&1
if %errorlevel% equ 0 (
    echo  ✓ 로컬호스트 연결 정상
) else (
    echo  ✗ 로컬호스트 연결 실패 (심각한 네트워크 문제)
)

ping -n 1 8.8.8.8 >nul 2>&1
if %errorlevel% equ 0 (
    echo  ✓ 인터넷 연결 정상 (Google DNS)
) else (
    echo  ✗ 인터넷 연결 실패
)

echo  외부 IP 주소 확인 중...
for /f %%i in ('curl -s --connect-timeout 5 ifconfig.me 2^>nul') do (
    echo  ✓ 외부 IP: %%i
    goto :ip_found_check
)
echo  ✗ 외부 IP 확인 실패 (방화벽 또는 프록시 설정 확인 필요)
:ip_found_check

echo.

rem 4. 포트 사용 현황 확인
echo  [4단계] 주요 포트 사용 현황
echo  ========================================

set "COMMON_PORTS=8080 8443 9090 3128 8888"
for %%p in (%COMMON_PORTS%) do (
    netstat -an | find ":%%p " >nul 2>&1
    if !errorlevel! equ 0 (
        echo  포트 %%p: 사용 중
    ) else (
        echo  포트 %%p: 사용 가능
    )
)

echo.

rem 5. 시스템 권한 및 보안 확인
echo  [5단계] 시스템 권한 및 보안 확인
echo  ========================================

echo test > "C:\Temp\write_test.tmp" 2>nul
if %errorlevel% equ 0 (
    echo  ✓ C:\Temp 디렉토리 쓰기 권한 확인
    del "C:\Temp\write_test.tmp" 2>nul
) else (
    echo  ✗ C:\Temp 디렉토리 쓰기 권한 없음
)

reg query "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v EnableLUA >nul 2>&1
if %errorlevel% equ 0 (
    for /f "tokens=3" %%a in ('reg query "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v EnableLUA ^| findstr "EnableLUA"') do (
        if "%%a"=="0x1" (
            echo  ✓ UAC (사용자 계정 컨트롤) 활성화됨
        ) else (
            echo  ✗ UAC (사용자 계정 컨트롤) 비활성화됨
        )
    )
) else (
    echo  ? UAC 상태 확인 불가
)

echo.

rem 6. 레지스트리 프록시 설정 확인
echo  [6단계] 현재 프록시 설정 확인
echo  ========================================

call :CheckProxyStatus
if "%PROXY_ENABLED%"=="활성화" (
    echo  현재 프록시 상태: 활성화
    if defined CURRENT_PROXY echo  프록시 서버: %CURRENT_PROXY%
) else (
    echo  현재 프록시 상태: 비활성화
)

echo.

rem 7. 실행 중인 관련 프로세스 확인
echo  [7단계] 관련 프로세스 확인
echo  ========================================

echo  Chrome 프로세스:
tasklist /FI "IMAGENAME eq chrome.exe" 2>nul | findstr "chrome.exe" || echo    실행 중인 Chrome 프로세스 없음

echo.
echo  Burp Suite 프로세스:
tasklist /FI "IMAGENAME eq BurpSuiteCommunity.exe" 2>nul | findstr "BurpSuiteCommunity.exe" || echo    실행 중인 Burp Suite Community 없음
tasklist /FI "IMAGENAME eq BurpSuitePro.exe" 2>nul | findstr "BurpSuitePro.exe" || echo    실행 중인 Burp Suite Professional 없음

echo.

rem 8. 권장사항 및 요약
echo  [8단계] 진단 결과 요약 및 권장사항
echo  ========================================

echo  진단이 완료되었습니다.
echo.
echo  [권장사항]
echo  1. Chrome과 Burp Suite가 모두 설치되어 있는지 확인하세요.
echo  2. 관리자 권한으로 프로그램을 실행하세요.
echo  3. Chrome AutoUpdate 확장 프로그램을 설치하여 테스트 자동화하세요.
echo  4. 바이러스 백신 소프트웨어에서 Chrome 프로필 폴더를 예외로 추가하세요.
echo  5. 방화벽에서 Chrome과 Burp Suite의 네트워크 접근을 허용하세요.
echo  6. 포트 8080이 사용 중인 경우, 다른 포트로 변경하세요.
echo.
echo  시스템 검사가 완료되었습니다.
echo.
pause
goto MAIN_MENU

rem ==================================================
rem  로그 파일 보기
rem ==================================================
:show_logs
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
goto MAIN_MENU

rem ==================================================
rem  고급 설정 메뉴
rem ==================================================
:ADVANCED_MENU
cls
echo.
echo ==================================================
echo              고급 설정 메뉴
echo ==================================================
echo.
echo  1. 설정 초기화
echo  2. Windows 호환성 검사
echo  3. 자동 복구 시스템
echo  4. 메인 메뉴로 돌아가기
echo.

choice /c 1234 /n /m " 선택하세요 (1-4): "
if errorlevel 4 goto MAIN_MENU
if errorlevel 3 goto auto_repair
if errorlevel 2 goto compatibility_check
if errorlevel 1 goto reset_config

:reset_config
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
if errorlevel 2 goto ADVANCED_MENU

call :WriteLog "[설정] 설정 초기화 시작"

if exist "%CONFIG_FILE%" (
    del "%CONFIG_FILE%" 2>nul
    echo  [완료] 설정 파일이 삭제되었습니다.
)

set "PROXY_PORT=8080"
set "BURP_PATH="

echo  [완료] 설정이 기본값으로 초기화되었습니다.
call :WriteLog "[설정] 설정 초기화 완료"
echo.
pause

call :FindBurp
goto ADVANCED_MENU

:compatibility_check
echo.
echo ==================================================
echo            Windows 호환성 검사
echo ==================================================
echo.
call :CheckWindowsCompatibility
echo.
pause
goto ADVANCED_MENU

:auto_repair
echo.
echo ==================================================
echo              자동 복구 시스템
echo ==================================================
echo.
echo  [주의] 이 기능은 다음 작업을 수행합니다:
echo         - 임시 파일 및 Chrome 프로필 정리
echo         - Chrome 프로세스 강제 종료
echo         - 네트워크 설정 새로고침
echo         - 프록시 설정 초기화
echo         - 권한 설정 복구
echo.
choice /c YN /n /m " 자동 복구를 실행하시겠습니까? (Y/N): "
if errorlevel 2 goto ADVANCED_MENU

call :AutoRepair
goto ADVANCED_MENU

rem ==================================================
rem  Burp Suite 실행 확인
rem ==================================================
:CheckBurp
call :WriteLog "[Burp] Burp Suite 실행 상태 확인"

set "BURP_RUNNING=0"
for /f "skip=1 tokens=2" %%A in ('wmic process where "name='%BURP_EXE_NAME%'" get ProcessId 2^>nul') do (
    if not "%%A"=="" (
        set "BURP_PID=%%A"
        set "BURP_RUNNING=1"
        call :WriteLog "[Burp] 실행 중 확인됨 PID: %%A"
        goto :BurpRunningCheck
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
rem  자동 복구 시스템
rem ==================================================
:AutoRepair
call :WriteLog "[복구] 자동 복구 시작"
echo  [복구] 시스템 자동 복구를 시작합니다...
echo.

echo  [1/5] 임시 파일 정리 중...
if exist "C:\Temp\ChromeBurpProfile-*" (
    for /d %%i in (C:\Temp\ChromeBurpProfile-*) do (
        rd /s /q "%%i" 2>nul
        call :WriteLog "[복구] 정리됨: %%i"
    )
)
del /q "C:\Temp\*.tmp" 2>nul
echo  완료.

echo  [2/5] Chrome 프로세스 정리 중...
taskkill /f /im chrome.exe >nul 2>&1
timeout /t 2 >nul
echo  완료.

echo  [3/5] 네트워크 설정 새로고침 중...
ipconfig /flushdns >nul 2>&1
echo  완료.

echo  [4/5] 프록시 설정 정리 중...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyEnable /t REG_DWORD /d 0 /f >nul 2>&1
echo  완료.

echo  [5/5] 권한 설정 확인 중...
if not exist "C:\Temp" mkdir "C:\Temp" 2>nul
echo test > "C:\Temp\repair_test.tmp" 2>nul
if %errorlevel% equ 0 (
    del "C:\Temp\repair_test.tmp" 2>nul
    echo  완료.
) else (
    echo  [경고] 권한 문제가 지속됩니다. 관리자 권한으로 실행하세요.
)

echo.
echo  [복구] 자동 복구가 완료되었습니다.
call :WriteLog "[복구] 자동 복구 완료"
pause
exit /b

rem ==================================================
rem  Windows 호환성 검사
rem ==================================================
:CheckWindowsCompatibility
call :WriteLog "[호환성] Windows 호환성 검사 시작"

for /f "tokens=4-5 delims=. " %%i in ('ver') do (
    set "WIN_MAJOR=%%i"
    set "WIN_MINOR=%%j"
)

if %WIN_MAJOR% LSS 10 (
    echo  [경고] Windows 10 미만 버전이 감지되었습니다.
    echo  [권장] Windows 10 이상에서 최적의 성능을 발휘합니다.
    call :WriteLog "[호환성] 지원되지 않는 Windows 버전: %WIN_MAJOR%.%WIN_MINOR%"
) else (
    echo  [확인] 지원되는 Windows 버전입니다.
    call :WriteLog "[호환성] 지원되는 Windows 버전: %WIN_MAJOR%.%WIN_MINOR%"
)

reg query "HKLM\SOFTWARE\Microsoft\NET Framework Setup\NDP\v4\Full" /v Release >nul 2>&1
if %errorlevel% equ 0 (
    echo  [확인] .NET Framework 4.x가 설치되어 있습니다.
    call :WriteLog "[호환성] .NET Framework 4.x 설치됨"
) else (
    echo  [경고] .NET Framework 4.x가 설치되지 않았을 수 있습니다.
)

for /f %%v in ('powershell -Command "$PSVersionTable.PSVersion.Major" 2^>nul') do (
    if %%v GEQ 3 (
        echo  [확인] PowerShell %%v.x가 지원됩니다.
        call :WriteLog "[호환성] PowerShell %%v.x 지원됨"
    ) else (
        echo  [경고] PowerShell 버전이 낮습니다 (현재: %%v.x)
    )
)

call :WriteLog "[호환성] Windows 호환성 검사 완료"
exit /b

rem ==================================================
rem  사용법 및 도움말
rem ==================================================
:HELP
cls
echo.
echo ████████████████████████████████████████████████████████████████
echo ██                    사용법 및 도움말                        ██
echo ████████████████████████████████████████████████████████████████
echo.
echo  🎯 빠른 시작 가이드
echo  ───────────────────────────────────────────────────────────────
echo.
echo  1단계: 필수 소프트웨어 설치
echo    • Google Chrome 최신 버전
echo    • Burp Suite Community 또는 Professional
echo.
echo  2단계: 프로그램 실행
echo    • 관리자 권한으로 실행 (권장)
echo    • "1. Chrome 실행 (Burp Proxy 사용)" 선택
echo.
echo  3단계: Chrome 실행
echo    • 자동으로 Burp Suite 실행 및 프록시 설정
echo    • 격리된 보안 프로필로 Chrome 실행
echo.
echo  4단계: SSL 인증서 설치 (HTTPS 사이트 테스트용)
echo    • Chrome에서 https://burp 접속
echo    • "CA Certificate" 다운로드
echo    • 인증서를 "신뢰할 수 있는 루트 인증 기관"에 설치
echo.
echo  ⚠️  자주 발생하는 문제 해결
echo  ───────────────────────────────────────────────────────────────
echo.
echo  ❓ Burp Suite에서 트래픽이 보이지 않는 경우:
echo    1. "4. 연결 상태 진단" 메뉴로 시스템 상태 확인
echo    2. Burp Suite Proxy 리스너가 127.0.0.1:8080에 설정되어 있는지 확인
echo    3. Intercept 탭에서 "Intercept is on" 활성화 확인
echo.
echo  ❓ Chrome 프로필 생성 오류:
echo    1. 관리자 권한으로 실행
echo    2. "7. 고급 설정 메뉴 → 3. 자동 복구 시스템" 실행
echo    3. Windows Defender 예외 설정 추가
echo    4. C:\Temp 폴더 쓰기 권한 확인
echo.
echo  ❓ Windows 호환성 문제:
echo    1. "7. 고급 설정 메뉴 → 2. Windows 호환성 검사" 실행
echo    2. Windows 10/11 최신 업데이트 설치
echo    3. .NET Framework 4.x 이상 설치 확인
echo    4. PowerShell 5.1 이상 버전 확인
echo.
echo  ❓ 네트워크 연결 문제:
echo    1. 방화벽에서 Chrome, Burp Suite 허용
echo    2. 기업 네트워크의 경우 네트워크 관리자 문의
echo    3. VPN 사용 시 VPN 설정 확인
echo    4. DNS 서버 설정 확인 (8.8.8.8, 1.1.1.1)
echo.
echo  📞 지원 및 문의
echo  ───────────────────────────────────────────────────────────────
echo.
echo  • 개발자: DBDROP
echo  • 이메일: swm5048@naver.com
echo  • GitHub: https://github.com/parkjunmin/ProxySetting_Burpsuite
echo  • Chrome 확장 프로그램: Chrome AutoUpdate
echo  • 버그 리포트: GitHub Issues 페이지 이용
echo.
echo  💡 추가 정보
echo  ───────────────────────────────────────────────────────────────
echo.
echo  • 상세한 로그는 C:\Temp\BurpLauncher_Logs\ 폴더에 저장됩니다
echo  • 설정 파일은 config.ini에 자동 저장됩니다
echo  • 모든 Chrome 프로필은 테스트 완료 후 자동 삭제됩니다
echo.
pause
goto MAIN_MENU

rem ==================================================
rem  프로그램 정보
rem ==================================================
:INFO
cls
echo.
echo ████████████████████████████████████████████████████████████████
echo ██                     프로그램 정보                          ██
echo ████████████████████████████████████████████████████████████████
echo.
echo  📋 프로그램 상세 정보
echo  ───────────────────────────────────────────────────────────────
echo.
echo  프로그램명    : Chrome Burp Suite Toolkit Unified
echo  버전          : v%VERSION%
echo  개발자        : DBDROP
echo  이메일        : swm5048@naver.com
echo  GitHub        : https://github.com/parkjunmin
echo  프로젝트 URL  : https://github.com/parkjunmin/ProxySetting_Burpsuite
echo  라이선스      : MIT License
echo  개발 언어     : Windows Batch Script
echo  지원 OS       : Windows 10/11 (64비트 권장)
echo.
echo  🌟 v2.0 Unified의 새로운 기능
echo  ───────────────────────────────────────────────────────────────
echo.
echo  🔗 통합된 인터페이스
echo    • 기존 3개 파일을 하나로 통합 (1,000+ 라인 → 단일 파일)
echo    • 직관적인 메뉴 시스템으로 모든 기능에 쉽게 접근
echo    • 일관된 사용자 경험 제공
echo.
echo  🔒 보안 강화
echo    • 격리된 보안 프로필로 안전한 테스트 환경 제공
echo    • 강화된 SSL/TLS 처리 및 인증서 오류 자동 우회
echo    • 프라이버시 보호를 위한 확장 프로그램 및 추적 기능 비활성화
echo.
echo  📊 진단 및 모니터링
echo    • 5단계 시스템 진단으로 문제 즉시 해결
echo    • 상세 로깅 시스템으로 모든 작업 내역 추적
echo    • 실시간 프로세스 상태 모니터링
echo.
echo  ⚙️ 고급 설정 관리
echo    • 사용자 설정을 config.ini 파일로 영구 저장
echo    • Burp Suite Community/Professional 지능형 자동 감지
echo    • 포트 충돌 방지 및 사용 중인 포트 자동 감지
echo.
echo  🛡️ 시스템 안정성
echo    • 관리자 권한 확인 및 최적 성능 보장
echo    • 2단계 Chrome 안전 종료로 데이터 손실 방지
echo    • 실행 전 시스템 요구사항 자동 검증
echo.
echo  📊 통계 정보
echo  ───────────────────────────────────────────────────────────────
echo.
echo  총 코드 라인 수    : 1,000+ 라인 (통합 버전)
echo  지원 기능 수       : 20개 주요 기능
echo  테스트 환경        : Windows 10/11
echo  개발 기간         : 2024년 1월
echo  최종 업데이트     : 2024년 1월 15일
echo.
echo  🏆 핵심 차별화 요소
echo  ───────────────────────────────────────────────────────────────
echo.
echo  • 원클릭 보안 테스트 환경 구축
echo  • 전문적인 시스템 진단 및 문제 해결
echo  • 완전 격리된 Chrome 프로필 시스템
echo  • 상세한 한글 인터페이스 및 가이드
echo  • 기업 환경에서의 안정성 검증
echo  • 단일 파일로 간편한 관리 및 배포
echo.
echo  💝 감사 인사
echo  ───────────────────────────────────────────────────────────────
echo.
echo  이 통합 도구를 사용해주셔서 감사합니다.
echo  웹 애플리케이션 보안 테스트의 효율성 향상에 도움이 되기를 바랍니다.
echo.
echo  버그 리포트나 개선 제안은 언제든지 환영합니다!
echo  GitHub Issues: https://github.com/parkjunmin/ProxySetting_Burpsuite/issues
echo.
pause
goto MAIN_MENU

rem ==================================================
rem  프로그램 종료
rem ==================================================
:EXIT
cls
echo.
echo  Chrome Burp Suite Toolkit Unified를 종료합니다.
echo.
echo  ┌────────────────────────────────────────────────────────────┐
echo  │                                                            │
echo  │  웹 애플리케이션 보안 테스트에 도움이 되셨기를 바랍니다.  │
echo  │                                                            │
echo  │  개발자: DBDROP (swm5048@naver.com)                       │
echo  │  GitHub: https://github.com/parkjunmin                    │
echo  │                                                            │
echo  │  🎉 통합 버전으로 더욱 편리해진 보안 테스트!              │
echo  │  ⭐ 유용하셨다면 GitHub에서 Star를 눌러주세요!             │
echo  │                                                            │
echo  └────────────────────────────────────────────────────────────┘
echo.
echo  안전한 하루 되세요! 🛡️
echo.
timeout /t 3 >nul
exit /b