@echo off
setlocal enabledelayedexpansion
chcp 65001 > nul

title Chrome Burp Suite Toolkit v2.0 by DBDROP

rem ==================================================
rem  Chrome Burp Suite Toolkit v2.0
rem  Created by DBDROP (swm5048@naver.com)
rem  통합 실행 메뉴
rem ==================================================

:MAIN_MENU
cls
echo.
echo ████████████████████████████████████████████████████████████████
echo ██                                                            ██
echo ██    Chrome Burp Suite Toolkit v2.0 Professional            ██
echo ██    Created by DBDROP (swm5048@naver.com)                  ██
echo ██                                                            ██
echo ████████████████████████████████████████████████████████████████
echo.
echo  웹 애플리케이션 보안 테스트를 위한 전문 도구 모음
echo.
echo  ┌────────────────────────────────────────────────────────────┐
echo  │                     메인 메뉴                              │
echo  ├────────────────────────────────────────────────────────────┤
echo  │                                                            │
echo  │  1. 🚀 Chrome Burp Proxy Launcher 실행                   │
echo  │     └─ Chrome과 Burp Suite를 연동하여 보안 테스트 시작    │
echo  │                                                            │
echo  │  2. 🔍 시스템 환경 검사                                   │
echo  │     └─ 시스템 상태 진단 및 문제 해결 도구                 │
echo  │                                                            │
echo  │  3. 📚 사용법 및 도움말                                   │
echo  │     └─ 상세한 사용 가이드 및 문제 해결 방법               │
echo  │                                                            │
echo  │  4. ℹ️  프로그램 정보                                      │
echo  │     └─ 버전 정보 및 개발자 정보                           │
echo  │                                                            │
echo  │  5. ❌ 종료                                               │
echo  │                                                            │
echo  └────────────────────────────────────────────────────────────┘
echo.

choice /c 12345 /n /m " 선택하세요 (1-5): "
if errorlevel 5 goto EXIT
if errorlevel 4 goto INFO
if errorlevel 3 goto HELP
if errorlevel 2 goto SYSTEM_CHECK
if errorlevel 1 goto MAIN_LAUNCHER

:MAIN_LAUNCHER
cls
echo.
echo  Chrome Burp Proxy Launcher를 시작합니다...
echo.
if exist "Burp_Start.bat" (
    call "Burp_Start.bat"
) else (
    echo  [오류] Burp_Start.bat 파일을 찾을 수 없습니다.
    echo  [안내] 파일이 동일한 폴더에 있는지 확인하세요.
    pause
)
goto MAIN_MENU

:SYSTEM_CHECK
cls
echo.
echo  시스템 환경 검사를 시작합니다...
echo.
if exist "System_Check.bat" (
    call "System_Check.bat"
) else (
    echo  [오류] System_Check.bat 파일을 찾을 수 없습니다.
    echo  [안내] 파일이 동일한 폴더에 있는지 확인하세요.
    pause
)
goto MAIN_MENU

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
echo    • "1. Chrome Burp Proxy Launcher 실행" 선택
echo.
echo  3단계: Chrome 실행
echo    • 메뉴에서 "1. Chrome 실행 (Burp Proxy 사용)" 선택
echo    • 자동으로 Burp Suite 실행 및 프록시 설정
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
echo    4. Chrome AutoUpdate 확장 프로그램과 함께 사용하여 자동 테스트
echo.
echo  ❓ Chrome 프로필 생성 오류:
echo    1. 관리자 권한으로 실행
echo    2. "8. 자동 복구 시스템" 메뉴 실행
echo    3. Windows Defender 예외 설정 추가
echo    4. C:\Temp 폴더 쓰기 권한 확인
echo.
echo  ❓ Windows 호환성 문제:
echo    1. "7. Windows 호환성 검사" 메뉴 실행
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
echo    └─ https://chromewebstore.google.com/detail/chromeautoupdate/ddcjfdggpnkjeigdalbfgmmanbndampa?authuser=0&hl=ko
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
echo  프로그램명    : Chrome Burp Suite Toolkit
echo  버전          : v2.0 Professional
echo  개발자        : DBDROP
echo  이메일        : swm5048@naver.com
echo  GitHub        : https://github.com/parkjunmin
echo  프로젝트 URL  : https://github.com/parkjunmin/ProxySetting_Burpsuite
echo  라이선스      : MIT License
echo  개발 언어     : Windows Batch Script
echo  지원 OS       : Windows 10/11 (64비트 권장)
echo.
echo  🌟 v2.0 Professional의 새로운 기능
echo  ───────────────────────────────────────────────────────────────
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
echo  총 코드 라인 수    : 800+ 라인
echo  지원 기능 수       : 15개 주요 기능
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
echo.
echo  💝 감사 인사
echo  ───────────────────────────────────────────────────────────────
echo.
echo  이 프로그램을 사용해주셔서 감사합니다.
echo  웹 애플리케이션 보안 테스트의 효율성 향상에 도움이 되기를 바랍니다.
echo.
echo  버그 리포트나 개선 제안은 언제든지 환영합니다!
echo  GitHub Issues: https://github.com/parkjunmin/ProxySetting_Burpsuite/issues
echo.
pause
goto MAIN_MENU

:EXIT
cls
echo.
echo  Chrome Burp Suite Toolkit을 종료합니다.
echo.
echo  ┌────────────────────────────────────────────────────────────┐
echo  │                                                            │
echo  │  웹 애플리케이션 보안 테스트에 도움이 되셨기를 바랍니다.  │
echo  │                                                            │
echo  │  개발자: DBDROP (swm5048@naver.com)                       │
echo  │  GitHub: https://github.com/parkjunmin                    │
echo  │                                                            │
echo  │  ⭐ 유용하셨다면 GitHub에서 Star를 눌러주세요!             │
echo  │                                                            │
echo  └────────────────────────────────────────────────────────────┘
echo.
echo  안전한 하루 되세요! 🛡️
echo.
timeout /t 3 >nul
exit /b