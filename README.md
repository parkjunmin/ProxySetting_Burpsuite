# ProxySetting_Burpsuite
Chrome Burp Proxy Launcher

개발자: DBDROP (swm5048@naver.com)
버전: v1.2
Chrome Burp Proxy Launcher는 Burp Suite를 사용한 웹 애플리케이션 보안 테스트를 위해 Chrome 브라우저를 Burp Proxy와 함께 쉽게 구성할 수 있는 Windows 배치 스크립트입니다.
주요 기능

Chrome 브라우저를 Burp Suite 프록시와 함께 자동 실행
시스템 프록시 설정 자동 구성 및 해제
매 실행마다 새로운 격리된 Chrome 프로필 생성
이전 프로필 자동 정리로 디스크 공간 절약
프록시 포트 커스텀 설정 기능
Burp Suite 실행 파일 자동 검색 및 실행

사용 방법
사전 요구 사항

Windows 운영체제
Google Chrome 설치
Burp Suite Community/Professional 설치

실행 방법

스크립트 파일(.bat)을 다운로드합니다.
더블 클릭하여 실행하거나 명령 프롬프트에서 실행합니다.
메뉴에서 원하는 옵션을 선택합니다:

1: Chrome을 Burp Proxy와 함께 실행
2: 프록시 설정 해제
3: 프록시 포트 변경



옵션 설명
1. Chrome 실행 (Burp Proxy 사용)

Burp Suite가 실행 중이 아니면 자동으로 실행합니다.
시스템 프록시 설정을 127.0.0.1:포트로 구성합니다(기본값: 8080).
격리된 새 Chrome 프로필을 생성합니다.
이전에 생성된 임시 프로필을 자동으로 정리합니다.
Chrome을 시작하고 Burp Suite 프록시를 통해 트래픽을 라우팅합니다.

2. 프록시 설정 해제

시스템 프록시 설정을 비활성화합니다.
설정이 적용되려면 Chrome을 다시 시작해야 합니다.

3. 프록시 포트 변경

Burp Suite 리스너의 포트 번호를 변경할 수 있습니다.
유효한 포트 범위는 0-65535입니다.

참고 사항

프로필 위치: 프로필은 C:\Temp\ChromeBurpProfile-[랜덤ID] 경로에 생성됩니다.
프록시 설정: 시스템 전체 프록시 설정이 변경되므로 다른 애플리케이션에도 영향을 줄 수 있습니다.
프로필 정리: 스크립트 실행 시 이전 Chrome 프로필 폴더가 자동으로 삭제됩니다.
Burp Suite 설정:

Burp Suite의 Proxy 탭에서 리스너가 스크립트에 설정된 포트에 바인딩되어 있는지 확인하세요.
Intercept 탭에서 'Intercept is on' 설정이 활성화되어 있는지 확인하세요.



문제 해결
문제: Chrome에서 "데이터 디렉터리 만들기 실패" 오류가 발생합니다.
해결: 이 문제는 v1.2에서 해결되었습니다. 프로필 디렉토리가 이제 C:\Temp에 생성됩니다.
문제: Burp Suite에서 트래픽이 캡처되지 않습니다.
해결: 다음 사항을 확인하세요:

Burp Suite가 실행 중인지 확인
Proxy 탭에서 리스너가 올바른 포트(기본값: 8080)에 바인딩되어 있는지 확인
'Intercept is on' 설정이 활성화되어 있는지 확인

라이선스
이 스크립트는 개인 및 교육 목적으로 자유롭게 사용할 수 있습니다. 상업적 용도로 사용하기 전에 개발자에게 문의하세요.
연락처
문제 보고나 기능 제안은 다음 이메일로 연락주세요: swm5048@naver.com
