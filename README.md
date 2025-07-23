# Chrome Burp Proxy Launcher v2.0 Professional

<div align="center">

![Version](https://img.shields.io/badge/version-2.0-blue.svg)
![Platform](https://img.shields.io/badge/platform-Windows-lightgrey.svg)
![License](https://img.shields.io/badge/license-MIT-green.svg)
![Security](https://img.shields.io/badge/security-enhanced-green.svg)

**웹 애플리케이션 보안 테스트를 위한 전문적인 Chrome-Burp Suite 통합 런처**

</div>

## 🌟 v2.0 Professional의 새로운 기능

### 🔒 **보안 강화**
- **격리된 보안 프로필**: 완전히 분리된 Chrome 프로필로 안전한 테스트 환경 제공
- **강화된 SSL/TLS 처리**: 인증서 오류 자동 처리 및 보안 테스트 최적화
- **프라이버시 보호**: 확장 프로그램, 동기화, 추적 기능 완전 비활성화

### 📊 **진단 및 모니터링**
- **실시간 연결 진단**: 5단계 시스템 진단으로 문제 즉시 해결
- **상세 로깅 시스템**: 모든 작업 내역을 시간별로 기록 및 추적
- **프로세스 상태 모니터링**: Chrome 및 Burp Suite 실행 상태 실시간 표시

### ⚙️ **고급 설정 관리**
- **영구 설정 저장**: 사용자 설정을 config.ini 파일로 자동 저장
- **지능형 경로 탐지**: Burp Suite Community/Professional 자동 감지
- **포트 충돌 방지**: 사용 중인 포트 자동 감지 및 경고

### 🛡️ **시스템 안정성**
- **관리자 권한 확인**: 최적 성능을 위한 권한 상태 검증
- **안전한 프로세스 종료**: 2단계 Chrome 종료로 데이터 손실 방지
- **시스템 요구사항 검증**: 실행 전 필수 조건 자동 확인

## 🚀 주요 기능

### 🎯 **원클릭 보안 테스트 환경**
- Chrome과 Burp Suite를 한 번의 클릭으로 완벽 연동
- 보안 테스트에 최적화된 브라우저 설정 자동 적용
- SSL/TLS 인증서 문제 자동 해결

### 🔄 **지능형 프록시 관리**
- 시스템 프록시 자동 설정/해제
- 사설 IP 대역 자동 우회 설정
- 포트 사용 가능성 실시간 확인

### 🧹 **자동 정리 시스템**
- 이전 세션의 Chrome 프로필 자동 삭제
- 임시 파일 및 폴더 정리
- 시스템 리소스 최적화

## 📋 시스템 요구사항

- **운영체제**: Windows 10/11 (64비트 권장)
- **브라우저**: Google Chrome (최신 버전)
- **보안 도구**: Burp Suite Community/Professional
- **권한**: 관리자 권한 (최적 성능을 위해 권장)
- **네트워크**: 인터넷 연결 (외부 IP 확인용)

## 🔧 설치 및 설정

### 1. 프로그램 다운로드
```bash
git clone https://github.com/parkjunmin/ProxySetting_Burpsuite.git
cd ProxySetting_Burpsuite
```

### 2. 필수 소프트웨어 설치
- [Google Chrome](https://www.google.com/chrome/) 설치
- [Burp Suite Community](https://portswigger.net/burp/communitydownload) 또는 Professional 설치

### 3. 실행
- `Burp_Start.bat` 파일을 **관리자 권한으로 실행** (권장)
- 또는 일반 권한으로 실행 (일부 기능 제한될 수 있음)

## 📖 사용 방법

### 메인 메뉴 옵션

```
==================================================
     Chrome Burp Proxy Launcher v2.0 Professional
     Created by DBDROP (swm5048@naver.com)
==================================================

 외부 IP: 203.0.113.1
 내부 IP: 192.168.1.5
 현재 프록시 포트: 8080
 Burp Suite: BurpSuiteCommunity.exe

 시스템 프록시 상태: 비활성화
 Chrome 상태: 중지됨
 Burp Suite 상태: 중지됨

--------------------------------------------------
 1. Chrome 실행 (Burp Proxy 사용)
 2. 프록시 설정 해제
 3. 프록시 포트 변경
 4. 연결 상태 진단
 5. 로그 파일 보기
 6. 설정 초기화
--------------------------------------------------
```

### 🎯 **옵션 1: Chrome 실행 (Burp Proxy 사용)**

**수행 작업:**
1. **시스템 검증**: 필수 구성 요소 및 권한 확인
2. **Burp Suite 실행**: 자동 감지 및 실행 (15초 대기)
3. **Chrome 안전 종료**: 기존 프로세스 2단계 종료
4. **보안 프로필 생성**: 격리된 테스트 환경 구성
5. **프록시 설정**: 시스템 전체 프록시 127.0.0.1:8080 활성화
6. **보안 Chrome 실행**: 강화된 보안 설정으로 실행

**보안 강화 옵션:**
- 모든 확장 프로그램 비활성화
- 자동 업데이트 및 동기화 차단
- JavaScript, 플러그인 제어 설정
- SSL/TLS 인증서 오류 자동 우회
- 웹 보안 정책 완화 (테스트용)

### 🔧 **옵션 2: 프록시 설정 해제**
- 시스템 프록시 설정 완전 비활성화
- Chrome 재시작 안내 제공
- 변경 사항 로그 기록

### ⚙️ **옵션 3: 프록시 포트 변경**
- 포트 범위 검증 (1024-65535)
- 포트 사용 중 상태 확인
- Burp Suite 리스너 설정 안내
- 설정 파일 자동 저장

### 🩺 **옵션 4: 연결 상태 진단**
**5단계 시스템 진단:**
1. **네트워크 연결**: 로컬호스트 ping 테스트
2. **포트 상태**: 프록시 포트 사용 여부 확인
3. **프로세스 상태**: Chrome/Burp Suite 실행 상태
4. **프록시 설정**: 시스템 프록시 활성화 상태
5. **인터넷 연결**: 외부 네트워크 연결 테스트

### 📝 **옵션 5: 로그 파일 보기**
- 일별 로그 파일 자동 생성
- 모든 작업 내역 시간별 기록
- 메모장으로 상세 로그 확인 가능
- 문제 해결 및 디버깅 지원

### 🔄 **옵션 6: 설정 초기화**
- 모든 사용자 설정 초기화
- config.ini 파일 삭제
- 기본 설정으로 복원
- Burp Suite 경로 재탐지

## 💡 고급 사용법

### SSL/TLS 인증서 설치 (중요)

웹 애플리케이션의 HTTPS 트래픽을 분석하려면 Burp Suite CA 인증서를 설치해야 합니다:

1. **Chrome에서 https://burp 접속**
2. **"CA Certificate" 다운로드**
3. **인증서 설치**:
   - 다운로드한 인증서 더블클릭
   - "인증서 저장소" → "신뢰할 수 있는 루트 인증 기관"에 저장
   - 보안 경고 "예" 선택

### Burp Suite 프록시 리스너 설정

1. **Burp Suite → Proxy → Options**
2. **Proxy Listeners 섹션에서 확인**:
   - Interface: `127.0.0.1:8080` (또는 설정한 포트)
   - Running: ✓ 체크됨
3. **Intercept 탭에서 "Intercept is on" 활성화**

### 프록시 우회 설정

다음 주소들은 자동으로 프록시를 우회합니다:
- `localhost`, `127.*.*.*`
- `10.*.*.*` (사설망 A클래스)
- `172.16.*.*` ~ `172.31.*.*` (사설망 B클래스)
- `192.168.*.*` (사설망 C클래스)

## ⚠️ 문제 해결

### 자주 발생하는 문제들

#### 🚫 **Burp Suite에서 트래픽이 보이지 않는 경우**

**해결 방법:**
1. **"4. 연결 상태 진단"** 메뉴로 시스템 상태 확인
2. Burp Suite Proxy 리스너가 올바른 포트에 바인딩되어 있는지 확인
3. Chrome에서 `https://burp`에 접속하여 CA 인증서 설치
4. Intercept 탭에서 "Intercept is on" 활성화 확인

#### 🔒 **Chrome 프로필 생성 오류**

**해결 방법:**
1. **관리자 권한으로 실행**
2. `C:\Temp` 폴더 쓰기 권한 확인
3. 바이러스 백신 소프트웨어의 실시간 보호 기능 일시 비활성화
4. 디스크 용량 확인 (최소 100MB 여유 공간 필요)

#### 🌐 **네트워크 연결 문제**

**해결 방법:**
1. 방화벽 설정에서 Chrome 및 Burp Suite 허용
2. 기업 네트워크의 경우 네트워크 관리자에게 문의
3. VPN 사용 시 VPN 설정 확인

#### 📁 **로그 파일 접근 불가**

**해결 방법:**
1. `C:\Temp\BurpLauncher_Logs` 폴더 권한 확인
2. 관리자 권한으로 프로그램 재실행
3. 바이러스 백신의 파일 보호 기능 확인

## 📊 로그 시스템

### 로그 파일 위치
```
C:\Temp\BurpLauncher_Logs\launcher_YYYYMMDD.log
```

### 로그 내용
- 프로그램 시작/종료 시간
- 시스템 검증 결과
- Burp Suite 및 Chrome 실행 상태
- 프록시 설정 변경 내역
- 오류 및 경고 메시지
- 사용자 작업 내역

### 로그 활용
- 문제 발생 시 원인 분석
- 시스템 성능 모니터링
- 보안 테스트 세션 추적

## 🔧 설정 파일 (config.ini)

프로그램 실행 폴더에 자동 생성되는 설정 파일:

```ini
PROXY_PORT=8080
BURP_PATH=C:\Users\...\BurpSuiteCommunity.exe
LAST_UPDATE=2024-01-15 14:30:25
AUTHOR=DBDROP (swm5048@naver.com)
```

## 🛡️ 보안 고려사항

### 테스트 환경 격리
- 프로덕션 환경과 완전히 분리된 테스트 환경 사용 권장
- 중요한 개인정보나 인증 정보가 포함된 사이트에서의 테스트 주의

### 데이터 보호
- 테스트 완료 후 Chrome 프로필 자동 삭제
- Burp Suite 프로젝트 파일의 안전한 관리
- 로그 파일의 정기적인 정리

### 네트워크 보안
- 테스트 트래픽이 외부로 유출되지 않도록 주의
- 기업 네트워크에서 사용 시 보안 정책 준수

## 📜 라이선스

이 프로젝트는 MIT 라이선스 하에 배포됩니다. 자세한 내용은 LICENSE 파일을 참조하세요.

## 👨‍💻 개발자 정보

**DBDROP**
- 📧 **이메일**: swm5048@naver.com
- 🐙 **GitHub**: [parkjunmin](https://github.com/parkjunmin)
- 🔗 **프로젝트**: [Chrome Burp Proxy Launcher](https://github.com/parkjunmin/ProxySetting_Burpsuite)

## 🤝 기여하기

프로젝트 개선에 참여해주세요!

### 기여 방법
1. 이 저장소를 Fork합니다
2. 새로운 기능 브랜치를 생성합니다 (`git checkout -b feature/AmazingFeature`)
3. 변경사항을 커밋합니다 (`git commit -m 'Add some AmazingFeature'`)
4. 브랜치에 Push합니다 (`git push origin feature/AmazingFeature`)
5. Pull Request를 생성합니다

### 버그 리포트
[Issues 페이지](https://github.com/parkjunmin/ProxySetting_Burpsuite/issues)에서 버그를 신고해주세요.

**버그 리포트 시 포함할 정보:**
- Windows 버전
- Chrome 버전
- Burp Suite 버전 (Community/Professional)
- 오류 메시지 또는 로그 파일 내용
- 재현 단계

## 🌟 후원하기

이 프로젝트가 도움이 되셨다면 GitHub에서 ⭐를 눌러주세요!

## 📈 버전 히스토리

### v2.0 Professional (2024-01-15)
- ✨ 보안 강화된 Chrome 프로필 시스템
- 📊 5단계 연결 상태 진단 기능
- 📝 상세 로깅 시스템 구현
- ⚙️ 영구 설정 저장 기능
- 🛡️ 관리자 권한 및 시스템 요구사항 검증
- 🔧 지능형 Burp Suite 경로 탐지
- 🧹 향상된 자동 정리 시스템

### v1.2 (2023-12-01)
- 🔄 기본 프록시 설정 기능
- 🌐 IP 주소 표시 기능
- 📁 Chrome 프로필 관리
- ⚙️ 포트 변경 기능

---

<div align="center">

**Chrome Burp Proxy Launcher v2.0 Professional**

웹 애플리케이션 보안 테스트의 새로운 표준

*Created with ❤️ by DBDROP*

</div>
