@echo off
setlocal enabledelayedexpansion
chcp 65001 > nul

title Chrome Burp System Checker v2.0 by DBDROP

rem ==================================================
rem  Chrome Burp System Checker v2.0
rem  Created by DBDROP (swm5048@naver.com)
rem  시스템 환경 검증 및 문제 진단 유틸리티
rem ==================================================

echo.
echo ==================================================
echo      Chrome Burp System Checker v2.0
echo      Created by DBDROP (swm5048@naver.com)
echo ==================================================
echo.
echo  시스템 환경을 검증하고 문제를 진단합니다.
echo  이 도구는 Chrome Burp Proxy Launcher와 함께 사용됩니다.
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

rem ==================================================
rem  1. 시스템 정보 수집
rem ==================================================
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

rem ==================================================
rem  2. 필수 소프트웨어 확인
rem ==================================================
echo  [2단계] 필수 소프트웨어 확인
echo  ========================================

rem Chrome 확인
set "CHROME_PATH=C:\Program Files\Google\Chrome\Application\chrome.exe"
if exist "%CHROME_PATH%" (
    echo  ✓ Google Chrome 설치됨: %CHROME_PATH%
    for /f "tokens=*" %%v in ('"%CHROME_PATH%" --version 2^>nul') do echo    버전: %%v
) else (
    echo  ✗ Google Chrome이 설치되지 않았습니다.
    echo    다운로드: https://www.google.com/chrome/
)

echo.

rem Burp Suite Community 확인
set "BURP_COMMUNITY=%USERPROFILE%\AppData\Local\Programs\BurpSuiteCommunity\BurpSuiteCommunity.exe"
if exist "%BURP_COMMUNITY%" (
    echo  ✓ Burp Suite Community 설치됨: %BURP_COMMUNITY%
) else (
    echo  ✗ Burp Suite Community가 기본 경로에 없습니다.
)

rem Burp Suite Professional 확인
set "BURP_PRO_FOUND=0"
for /r "C:\Program Files" %%i in (BurpSuitePro.exe) do (
    echo  ✓ Burp Suite Professional 발견: %%i
    set "BURP_PRO_FOUND=1"
)

if !BURP_PRO_FOUND!==0 (
    echo  ✗ Burp Suite Professional이 발견되지 않았습니다.
)

if not exist "%BURP_COMMUNITY%" if !BURP_PRO_FOUND!==0 (
    echo    다운로드: https://portswigger.net/burp/communitydownload
)

echo.

rem Chrome AutoUpdate 확장 프로그램 안내
echo  Chrome AutoUpdate 확장 프로그램 (권장):
echo  └─ 보안 테스트 자동화를 위한 전용 확장 프로그램
echo  └─ 설치: https://chromewebstore.google.com/detail/chromeautoupdate/ddcjfdggpnkjeigdalbfgmmanbndampa?authuser=0&hl=ko

echo.

rem ==================================================
rem  3. 네트워크 연결 확인
rem ==================================================
echo  [3단계] 네트워크 연결 확인
echo  ========================================

rem 로컬호스트 연결
ping -n 1 127.0.0.1 >nul 2>&1
if %errorlevel% equ 0 (
    echo  ✓ 로컬호스트 연결 정상
) else (
    echo  ✗ 로컬호스트 연결 실패 (심각한 네트워크 문제)
)

rem 인터넷 연결 (Google DNS)
ping -n 1 8.8.8.8 >nul 2>&1
if %errorlevel% equ 0 (
    echo  ✓ 인터넷 연결 정상 (Google DNS)
) else (
    echo  ✗ 인터넷 연결 실패
)

rem 외부 IP 확인
echo  외부 IP 주소 확인 중...
for /f %%i in ('curl -s --connect-timeout 5 ifconfig.me 2^>nul') do (
    echo  ✓ 외부 IP: %%i
    goto :ip_found
)
echo  ✗ 외부 IP 확인 실패 (방화벽 또는 프록시 설정 확인 필요)
:ip_found

echo.

rem ==================================================
rem  4. 포트 사용 현황 확인
rem ==================================================
echo  [4단계] 주요 포트 사용 현황
echo  ========================================

set "COMMON_PORTS=8080 8443 9090 3128 8888"
for %%p in (%COMMON_PORTS%) do (
    netstat -an | find ":%%p " >nul 2>&1
    if !errorlevel! equ 0 (
        echo  포트 %%p: 사용 중
        for /f "tokens=1,2,5" %%a in ('netstat -ano ^| findstr ":%%p "') do (
            if not "%%c"=="" (
                for /f "tokens=1" %%d in ('tasklist /fi "pid eq %%c" /fo csv /nh 2^>nul ^| findstr /v "INFO:"') do (
                    set "process_name=%%d"
                    set "process_name=!process_name:"=!"
                    echo    └─ PID %%c: !process_name!
                )
            )
        )
    ) else (
        echo  포트 %%p: 사용 가능
    )
)

echo.

rem ==================================================
rem  5. 시스템 권한 및 보안 확인
rem ==================================================
echo  [5단계] 시스템 권한 및 보안 확인
echo  ========================================

rem 임시 디렉토리 쓰기 권한
echo test > "C:\Temp\write_test.tmp" 2>nul
if %errorlevel% equ 0 (
    echo  ✓ C:\Temp 디렉토리 쓰기 권한 확인
    del "C:\Temp\write_test.tmp" 2>nul
) else (
    echo  ✗ C:\Temp 디렉토리 쓰기 권한 없음
)

rem UAC 상태 확인
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

rem Windows Defender 실시간 보호 상태
powershell -Command "Get-MpPreference | Select-Object DisableRealtimeMonitoring" 2>nul | findstr "False" >nul
if %errorlevel% equ 0 (
    echo  ✓ Windows Defender 실시간 보호 활성화됨
    echo    주의: 바이러스 백신이 Chrome 프로필 생성을 차단할 수 있습니다.
) else (
    echo  ? Windows Defender 상태 확인 불가 또는 비활성화됨
)

echo.

rem ==================================================
rem  6. 레지스트리 프록시 설정 확인
rem ==================================================
echo  [6단계] 현재 프록시 설정 확인
echo  ========================================

set "REG_PATH=HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings"

reg query "%REG_PATH%" /v ProxyEnable >nul 2>&1
if %errorlevel% equ 0 (
    for /f "tokens=3" %%a in ('reg query "%REG_PATH%" /v ProxyEnable ^| findstr /i "ProxyEnable"') do (
        if "%%a"=="0x1" (
            echo  현재 프록시 상태: 활성화
            for /f "tokens=3*" %%b in ('reg query "%REG_PATH%" /v ProxyServer ^| findstr /i "ProxyServer"') do (
                echo  프록시 서버: %%b
            )
            for /f "tokens=3*" %%c in ('reg query "%REG_PATH%" /v ProxyOverride ^| findstr /i "ProxyOverride"') do (
                echo  프록시 우회: %%c
            )
        ) else (
            echo  현재 프록시 상태: 비활성화
        )
    )
) else (
    echo  프록시 설정 레지스트리 키를 찾을 수 없습니다.
)

echo.

rem ==================================================
rem  7. 실행 중인 관련 프로세스 확인
rem ==================================================
echo  [7단계] 관련 프로세스 확인
echo  ========================================

echo  Chrome 프로세스:
tasklist /FI "IMAGENAME eq chrome.exe" 2>nul | findstr "chrome.exe" || echo    실행 중인 Chrome 프로세스 없음

echo.
echo  Burp Suite 프로세스:
tasklist /FI "IMAGENAME eq BurpSuiteCommunity.exe" 2>nul | findstr "BurpSuiteCommunity.exe" || echo    실행 중인 Burp Suite Community 없음
tasklist /FI "IMAGENAME eq BurpSuitePro.exe" 2>nul | findstr "BurpSuitePro.exe" || echo    실행 중인 Burp Suite Professional 없음

echo.

rem ==================================================
rem  8. 성능 및 리소스 확인
rem ==================================================
echo  [8단계] 시스템 성능 확인
echo  ========================================

rem CPU 사용률
for /f "skip=1 tokens=2 delims=," %%a in ('wmic cpu get loadpercentage /format:csv') do (
    if not "%%a"=="" echo  현재 CPU 사용률: %%a%%
)

rem 메모리 사용률
for /f "tokens=4" %%a in ('systeminfo ^| findstr "Available Physical Memory"') do (
    echo  사용 가능한 물리적 메모리: %%a
)

rem 디스크 성능 (간단한 쓰기 테스트)
echo  디스크 쓰기 성능 테스트 중...
set "start_time=%time%"
echo 테스트 데이터 > "C:\Temp\perf_test.tmp" 2>nul
if %errorlevel% equ 0 (
    del "C:\Temp\perf_test.tmp" 2>nul
    echo  ✓ 디스크 쓰기 성능 정상
) else (
    echo  ✗ 디스크 쓰기 성능 문제 또는 권한 부족
)

echo.

rem ==================================================
rem  9. 방화벽 및 보안 소프트웨어 확인
rem ==================================================
echo  [9단계] 보안 소프트웨어 확인
echo  ========================================

rem Windows 방화벽 상태
netsh advfirewall show allprofiles state 2>nul | findstr "State" | findstr "ON" >nul
if %errorlevel% equ 0 (
    echo  ✓ Windows 방화벽 활성화됨
    echo    주의: 방화벽이 Chrome 또는 Burp Suite 연결을 차단할 수 있습니다.
) else (
    echo  ? Windows 방화벽 상태 확인 불가 또는 비활성화됨
)

rem 설치된 바이러스 백신 소프트웨어 확인
echo  설치된 보안 소프트웨어:
wmic /namespace:\\root\securitycenter2 path antivirusproduct get displayname,productstate 2>nul | findstr /v "displayname" | findstr /v "^$" || echo    확인 불가 또는 설치되지 않음

echo.

rem ==================================================
rem  10. 권장사항 및 요약
rem ==================================================
echo  [10단계] 진단 결과 요약 및 권장사항
echo  ========================================

echo  진단이 완료되었습니다.
echo.
echo  [권장사항]
echo  1. Chrome과 Burp Suite가 모두 설치되어 있는지 확인하세요.
echo  2. 관리자 권한으로 Chrome Burp Proxy Launcher를 실행하세요.
echo  3. Chrome AutoUpdate 확장 프로그램을 설치하여 테스트 자동화하세요.
echo  4. 바이러스 백신 소프트웨어에서 Chrome 프로필 폴더를 예외로 추가하세요.
echo  5. 방화벽에서 Chrome과 Burp Suite의 네트워크 접근을 허용하세요.
echo  6. 포트 8080이 사용 중인 경우, 다른 포트로 변경하세요.
echo.
echo  [Windows 오류 해결]
echo  - 액세스 거부 오류: 관리자 권한으로 실행
echo  - 파일을 찾을 수 없음: Chrome/Burp Suite 설치 경로 확인
echo  - 배치 파일 실행 안됨: Windows Defender 예외 추가
echo  - 네트워크 오류: 방화벽 설정 및 DNS 서버 확인
echo  - 프로필 생성 실패: 디스크 공간 확보 및 권한 설정
echo.
echo  [문제 해결]
echo  - 네트워크 연결 문제가 있는 경우 네트워크 관리자에게 문의하세요.
echo  - 권한 문제가 있는 경우 관리자 권한으로 실행하세요.
echo  - 소프트웨어가 설치되지 않은 경우 해당 소프트웨어를 설치하세요.
echo  - Windows 호환성 문제: "7. Windows 호환성 검사" 메뉴 실행
echo  - 시스템 오류 지속: "8. 자동 복구 시스템" 메뉴 실행
echo.
echo  [로그 파일]
echo  자세한 실행 로그는 Chrome Burp Proxy Launcher 실행 시
echo  C:\Temp\BurpLauncher_Logs\ 폴더에 저장됩니다.
echo.

echo  시스템 검사가 완료되었습니다.
echo  Chrome Burp Proxy Launcher v2.0 Professional by DBDROP (swm5048@naver.com)
echo.
pause