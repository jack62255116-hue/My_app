# 개발 진행 상태

> 마지막 업데이트: 2026-05-18

---

## 프로젝트 개요

| 항목 | 내용 |
|------|------|
| 앱 이름 | Myapp |
| 플랫폼 | Flutter (iOS + Android) |
| 핵심 기능 | AI(Claude API)가 데이터 입력 패턴을 학습해 자동 제안 |
| GitHub | https://github.com/SD1056/My_app |
| 브랜치 | master |

---

## 완료된 마일스톤

### ✅ M0 — 프로젝트 셋업
- Flutter 3.41.9 프로젝트 생성
- 패키지: sqflite, riverpod, dio, flutter_secure_storage, intl, fl_chart, shared_preferences
- SQLite DatabaseHelper (records / patterns 테이블)
- 하단 탭바 Shell (홈 / 기록 / 통계 / 설정)
- GitHub Actions CI (flutter analyze + test)

### ✅ M1 — 수동 기록
- Record 모델 + 5개 카테고리 (지출💰 운동💪 식단🍱 수면😴 메모📝)
- RecordDao: SQLite CRUD
- RecordListNotifier: Riverpod 상태 관리
- AddRecordSheet: 카테고리 칩 선택 → 값 입력 → 저장 + 3초 취소 스낵바
- HomeScreen: 오늘 요약 카드 + 기록 목록 + FAB
- HistoryScreen: 날짜별 그룹 + 길게 눌러 수정/삭제

### ✅ M2 — AI 제안
- PatternAnalyzer: 최근 30일 ±2시간 패턴 추출 (최소 3개 데이터 필요)
- AiService: Claude API (claude-sonnet-4-6) + flutter_secure_storage API 키 저장
- SuggestionProvider: autoDispose FutureProvider
- SuggestionCard: 수락 / 수정(프리필) / 건너뜀
- AddRecordSheet: 로딩 → 제안 카드 → 수동 입력 플로우

### ✅ M3 — 완성도
- OnboardingScreen: 3장 PageView, 스킵 가능, SharedPreferences 완료 플래그
- StatsScreen: 주간/월간 탭, fl_chart 막대 차트, 카테고리별 진행바
- AI 제안 ON/OFF 토글 (설정 화면, SharedPreferences 저장)
- main.dart: 첫 실행 온보딩 분기

---

## 다음 단계: M4 — 출시 준비 (07-06 ~ 07-20)

- [ ] 앱 아이콘 교체 (android/ios 각각)
- [ ] 스플래시 화면
- [ ] 앱스토어 메타데이터 (스크린샷, 설명, 키워드)
- [ ] TestFlight (iOS) / 내부 테스트 트랙 (Android) 제출
- [ ] 베타 피드백 반영 버그 수정

---

## 새 기기에서 이어하는 방법

### 1. 필수 설치
```bash
# Flutter SDK
# flutter.dev 에서 Windows용 zip 다운로드 후 C:\flutter 에 압축 해제
# 시스템 환경변수 PATH에 C:\flutter\bin 추가

# Git
# git-scm.com 에서 설치

# GitHub CLI
# cli.github.com 에서 설치 후: gh auth login
```

### 2. 레포 클론
```bash
git clone https://github.com/SD1056/My_app.git
cd My_app
flutter pub get
```

### 3. 에뮬레이터 또는 기기 연결 후 실행
```bash
flutter run
```

### 4. AI 기능 활성화
- 앱 실행 → 설정 탭 → Claude API 키 입력
- Anthropic Console(console.anthropic.com)에서 API 키 발급

---

## 프로젝트 구조

```
lib/
├── main.dart                          # 앱 진입점, 온보딩 분기
├── core/
│   ├── database/database_helper.dart  # SQLite 초기화
│   └── ai/
│       ├── ai_service.dart            # Claude API 클라이언트
│       └── pattern_analyzer.dart      # 패턴 추출 로직
├── features/
│   ├── record/                        # M1: 수동 기록
│   │   ├── domain/record.dart
│   │   ├── data/record_dao.dart
│   │   └── presentation/
│   │       ├── record_provider.dart
│   │       ├── add_record_sheet.dart
│   │       └── home_screen.dart
│   ├── suggestion/                    # M2: AI 제안
│   │   └── presentation/
│   │       ├── suggestion_provider.dart
│   │       └── suggestion_card.dart
│   ├── history/presentation/          # 기록 히스토리
│   ├── stats/presentation/            # M3: 통계
│   ├── onboarding/presentation/       # M3: 온보딩
│   └── settings/presentation/         # 설정 (API 키, AI 토글)
└── shared/
    ├── theme/app_theme.dart
    └── widgets/app_shell.dart         # 하단 탭바 Shell
.planning/
├── 00-vision.md
├── 01-requirements.md
├── 02-architecture.md
├── 03-ux-flow.md
└── 04-roadmap.md
```

---

## 커밋 히스토리

| 커밋 | 내용 |
|------|------|
| `5c5090d` | feat: M3 onboarding, stats, AI toggle |
| `710a505` | feat: M2 AI suggestion feature |
| `692d93d` | feat: M1 manual record feature |
| `bf477c2` | feat: M0 project setup |
| `7d9e667` | docs: roadmap |
| `77d9197` | docs: UX flow |
| `2cac14b` | docs: architecture |
| `7ad2497` | docs: vision & requirements |
