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
rem  새로운 기능: 시스템 요구사항 검증 (Windows 오류 대응 강화)
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
    echo  [참고] 다음 경로에서 Chrome을 찾았는지 확인하세요:
    echo         - C:\Program Files\Google\Chrome\Application\
    echo         - C:\Program Files (x86)\Google\Chrome\Application\
    echo         - %LOCALAPPDATA%\Google\Chrome\Application\
    pause
    exit /b 1
)

rem Chrome 버전 확인
for /f "tokens=*" %%v in ('"%CHROME_PATH%" --version 2^>nul') do (
    call :WriteLog "[확인] Chrome 버전: %%v"
)

rem 임시 디렉토리 생성 및 권한 확인
if not exist "C:\Temp" (
    mkdir "C:\Temp" 2>nul
    if %errorlevel% neq 0 (
        call :WriteLog "[오류] C:\Temp 디렉토리 생성 실패"
        echo  [오류] 임시 디렉토리를 생성할 수 없습니다.
        echo  [해결] 관리자 권한으로 실행하거나 다음 명령을 실행하세요:
        echo         mkdir C:\Temp
        pause
        exit /b 1
    )
)

echo test > "C:\Temp\write_test.tmp" 2>nul
if %errorlevel% neq 0 (
    call :WriteLog "[오류] C:\Temp 디렉토리에 쓰기 권한이 없습니다"
    echo  [오류] 임시 디렉토리에 쓰기 권한이 없습니다.
    echo  [해결] 다음 중 하나를 시도하세요:
    echo         1. 관리자 권한으로 프로그램 실행
    echo         2. C:\Temp 폴더 속성에서 보안 설정 확인
    echo         3. 바이러스 백신 실시간 보호 일시 비활성화
    pause
    exit /b 1
) else (
    del "C:\Temp\write_test.tmp" 2>nul
    call :WriteLog "[확인] 임시 디렉토리 쓰기 권한 확인됨"
)

rem 디스크 여유 공간 확인
for /f "tokens=3" %%a in ('dir C:\ ^| findstr "bytes free"') do (
    call :WriteLog "[시스템] C: 드라이브 여유 공간: %%a bytes"
    if %%a LSS 524288000 (
        echo  [경고] C: 드라이브 여유 공간이 부족합니다 (500MB 미만)
        echo  [권장] 디스크 정리를 실행하여 공간을 확보하세요
    )
)

rem Windows Defender 상태 확인
powershell -Command "Get-MpPreference | Select-Object DisableRealtimeMonitoring" 2>nul | findstr "False" >nul
if %errorlevel% equ 0 (
    call :WriteLog "[확인] Windows Defender 실시간 보호 활성화됨"
    echo  [정보] Windows Defender가 활성화되어 있습니다.
    echo  [참고] Chrome 프로필 생성 시 차단될 수 있으니 예외 설정을 고려하세요.
)

rem 네트워크 연결 확인 (다중 DNS 서버)
set "NETWORK_OK=0"
for %%dns in (8.8.8.8 1.1.1.1 208.67.222.222) do (
    ping -n 1 %%dns >nul 2>&1
    if !errorlevel! equ 0 (
        set "NETWORK_OK=1"
        call :WriteLog "[확인] 인터넷 연결 상태 양호 (DNS: %%dns)"
        goto :NetworkCheckDone
    )
)

:NetworkCheckDone
if %NETWORK_OK%==0 (
    call :WriteLog "[경고] 인터넷 연결 확인 실패"
    echo  [경고] 인터넷 연결을 확인할 수 없습니다.
    echo  [참고] 외부 IP 조회 및 일부 기능이 제한될 수 있습니다.
    echo  [해결] 네트워크 연결 및 방화벽 설정을 확인하세요.
)

rem UAC 상태 확인
reg query "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v EnableLUA >nul 2>&1
if %errorlevel% equ 0 (
    for /f "tokens=3" %%a in ('reg query "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v EnableLUA ^| findstr "EnableLUA"') do (
        if "%%a"=="0x1" (
            call :WriteLog "[확인] UAC 활성화됨"
        ) else (
            call :WriteLog "[경고] UAC 비활성화됨"
        )
    )
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
echo  7. Windows 호환성 검사
echo  8. 자동 복구 시스템
echo --------------------------------------------------
echo.
choice /c 12345678 /n /m " 선택하세요 (1-8): "
if errorlevel 8 goto auto_repair
if errorlevel 7 goto compatibility_check
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
rem  새로운 메뉴: Windows 호환성 검사
rem ==================================================
:compatibility_check
echo.
echo.
echo ==================================================
echo            Windows 호환성 검사
echo ==================================================
echo.
call :CheckWindowsCompatibility
echo.
pause
goto MENU

rem ==================================================
rem  새로운 메뉴: 자동 복구 시스템
rem ==================================================
:auto_repair
echo.
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
if errorlevel 2 goto MENU

call :AutoRepair
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

rem ==================================================
rem  새로운 기능: Windows 오류 처리 및 복구
rem ==================================================
:HandleWindowsError
set "ERROR_CODE=%~1"
set "ERROR_MSG=%~2"
call :WriteLog "[오류] Windows 오류 발생: %ERROR_CODE% - %ERROR_MSG%"

if "%ERROR_CODE%"=="5" (
    echo  [오류] 액세스가 거부되었습니다.
    echo  [해결] 관리자 권한으로 프로그램을 다시 실행하세요.
    echo         1. 배치 파일을 마우스 우클릭
    echo         2. "관리자 권한으로 실행" 선택
    echo         3. UAC 창에서 "예" 클릭
) else if "%ERROR_CODE%"=="2" (
    echo  [오류] 시스템에서 지정한 파일을 찾을 수 없습니다.
    echo  [해결] 다음을 확인하세요:
    echo         1. Chrome 설치 여부: %CHROME_PATH%
    echo         2. Burp Suite 설치 여부: %BURP_PATH%
    echo         3. 파일 경로가 올바른지 확인
) else if "%ERROR_CODE%"=="32" (
    echo  [오류] 다른 프로세스가 파일을 사용 중입니다.
    echo  [해결] 다음을 시도하세요:
    echo         1. Chrome 완전 종료 후 재시도
    echo         2. 작업 관리자에서 chrome.exe 프로세스 강제 종료
    echo         3. 컴퓨터 재시작 후 재시도
) else (
    echo  [오류] 알 수 없는 Windows 오류가 발생했습니다.
    echo  [해결] 다음을 시도하세요:
    echo         1. 컴퓨터 재시작
    echo         2. Windows 업데이트 확인
    echo         3. 바이러스 백신 일시 비활성화
    echo         4. 시스템 파일 검사: sfc /scannow
)

echo.
choice /c YN /n /m " 자동 복구를 시도하시겠습니까? (Y/N): "
if errorlevel 2 exit /b

call :AutoRepair
exit /b

rem ==================================================
rem  새로운 기능: 자동 복구 시스템
rem ==================================================
:AutoRepair
call :WriteLog "[복구] 자동 복구 시작"
echo  [복구] 시스템 자동 복구를 시작합니다...
echo.

rem 1단계: 임시 파일 정리
echo  [1/5] 임시 파일 정리 중...
if exist "C:\Temp\ChromeBurpProfile-*" (
    for /d %%i in (C:\Temp\ChromeBurpProfile-*) do (
        rd /s /q "%%i" 2>nul
        call :WriteLog "[복구] 정리됨: %%i"
    )
)
del /q "C:\Temp\*.tmp" 2>nul
echo  완료.

rem 2단계: Chrome 프로세스 정리
echo  [2/5] Chrome 프로세스 정리 중...
taskkill /f /im chrome.exe >nul 2>&1
timeout /t 2 >nul
echo  완료.

rem 3단계: 네트워크 설정 새로고침
echo  [3/5] 네트워크 설정 새로고침 중...
ipconfig /flushdns >nul 2>&1
echo  완료.

rem 4단계: 레지스트리 프록시 설정 정리
echo  [4/5] 프록시 설정 정리 중...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyEnable /t REG_DWORD /d 0 /f >nul 2>&1
echo  완료.

rem 5단계: 권한 확인 및 복구
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
rem  새로운 기능: Windows 호환성 검사
rem ==================================================
:CheckWindowsCompatibility
call :WriteLog "[호환성] Windows 호환성 검사 시작"

rem Windows 10/11 확인
for /f "tokens=4-5 delims=. " %%i in ('ver') do (
    set "WIN_MAJOR=%%i"
    set "WIN_MINOR=%%j"
)

if %WIN_MAJOR% LSS 10 (
    echo  [경고] Windows 10 미만 버전이 감지되었습니다.
    echo  [권장] Windows 10 이상에서 최적의 성능을 발휘합니다.
    call :WriteLog "[호환성] 지원되지 않는 Windows 버전: %WIN_MAJOR%.%WIN_MINOR%"
) else (
    call :WriteLog "[호환성] 지원되는 Windows 버전: %WIN_MAJOR%.%WIN_MINOR%"
)

rem .NET Framework 확인
reg query "HKLM\SOFTWARE\Microsoft\NET Framework Setup\NDP\v4\Full" /v Release >nul 2>&1
if %errorlevel% equ 0 (
    call :WriteLog "[호환성] .NET Framework 4.x 설치됨"
) else (
    echo  [경고] .NET Framework 4.x가 설치되지 않았을 수 있습니다.
    echo  [참고] 일부 기능이 제한될 수 있습니다.
)

rem PowerShell 버전 확인
for /f %%v in ('powershell -Command "$PSVersionTable.PSVersion.Major" 2^>nul') do (
    if %%v GEQ 3 (
        call :WriteLog "[호환성] PowerShell %%v.x 지원됨"
    ) else (
        echo  [경고] PowerShell 버전이 낮습니다 (현재: %%v.x)
        echo  [권장] PowerShell 5.1 이상 설치를 권장합니다.
    )
)

call :WriteLog "[호환성] Windows 호환성 검사 완료"
exit /b
