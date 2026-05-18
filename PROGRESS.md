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
| 개발 인원 | 1인 |
| MVP 목표 | 2026-07-06 |

---

## 완료된 작업

### ✅ 기획 문서 (`.planning/`)
- `00-vision.md` — 비전, 문제 정의, OKR
- `01-requirements.md` — 사용자 시나리오 3개, MoSCoW 기능 분류
- `02-architecture.md` — 기술 스택, 시스템 구성도, DB 스키마
- `03-ux-flow.md` — 화면 설계, 사용자 플로우 다이어그램
- `04-roadmap.md` — 7주 로드맵, 마일스톤별 체크리스트

### ✅ ADR (`.adr/`)
- `0001` — Flutter 선택 (vs React Native, Swift)
- `0002` — SQLite 온디바이스 저장 (vs Firebase, Supabase)
- `0003` — Claude API 사용 (vs 온디바이스 ML)
- `0004` — Riverpod 상태 관리 (vs BLoC, GetX)
- `0005` — Feature-first 폴더 구조
- `0006` — AI 제안 온디맨드 호출 (vs 백그라운드 프리페치)

### ✅ M0 — 프로젝트 셋업
- Flutter 3.41.9 프로젝트 생성
- 패키지: sqflite, riverpod, dio, flutter_secure_storage, intl, fl_chart, shared_preferences
- SQLite DatabaseHelper (`records` / `patterns` 테이블)
- 하단 탭바 Shell (홈 / 기록 / 통계 / 설정)
- GitHub Actions CI (flutter analyze + test on push/PR)

### ✅ M1 — 수동 기록
- `Record` 모델 + 5개 카테고리 (지출💰 운동💪 식단🍱 수면😴 메모📝)
- `RecordDao`: SQLite CRUD (insert / getAll / getToday / update / delete)
- `RecordListNotifier`: Riverpod `AsyncNotifierProvider`
- `AddRecordSheet`: 카테고리 칩 선택 → 값 입력 → 저장 + 3초 취소 스낵바
- `HomeScreen`: 오늘 요약 카드 + 기록 목록 + FAB
- `HistoryScreen`: 날짜별 그룹 + 길게 눌러 수정/삭제

### ✅ M2 — AI 제안
- `PatternAnalyzer`: 최근 30일 ±2시간 패턴 추출 (최소 3개 데이터 필요)
- `AiService`: Claude API (`claude-sonnet-4-6`) + API 키 Secure Storage 저장
- `SuggestionProvider`: `FutureProvider.autoDispose`
- `SuggestionCard`: 수락 / 수정(폼 프리필) / 건너뜀
- `AddRecordSheet`: 로딩 → 제안 카드 → 수동 입력 폼 플로우
- AI 없을 때 오류 없이 수동 입력 폴백

### ✅ M3 — 완성도
- `OnboardingScreen`: 3장 PageView, 스킵 가능, 완료 플래그(SharedPreferences)
- `StatsScreen`: 주간/월간 탭, fl_chart 막대 차트, 카테고리별 진행바
- AI 제안 ON/OFF 토글 (설정 화면, SharedPreferences 저장)
- `main.dart`: 첫 실행 온보딩 분기
- 전체 탭 4개 실제 화면 연결 완료

### ✅ 문서화
- `README.md`: 기술 스택, 아키텍처, 프로젝트 구조, 시작 가이드 전면 작성
- `PROGRESS.md`: 진행 상태 (현재 파일)

---

## 다음 단계: M4 — 출시 준비 (목표: 2026-07-20)

- [ ] 앱 아이콘 교체 (Android `mipmap` / iOS `AppIcon`)
- [ ] 스플래시 화면 (`flutter_native_splash`)
- [ ] 앱스토어 메타데이터 (스크린샷, 설명문, 키워드)
- [ ] TestFlight (iOS) / 내부 테스트 트랙 (Android) 제출
- [ ] 베타 피드백 반영 버그 수정
- [ ] 정식 출시

---

## 새 기기에서 이어하는 방법

### 1. 필수 설치
```
Flutter SDK → flutter.dev 에서 Windows용 zip 다운로드 후 C:\flutter 압축 해제
              시스템 환경변수 PATH에 C:\flutter\bin 추가

Git          → git-scm.com

GitHub CLI   → cli.github.com 설치 후 gh auth login
```

### 2. 레포 클론 및 실행
```bash
git clone https://github.com/SD1056/My_app.git
cd My_app
flutter pub get
flutter run
```

### 3. AI 기능 활성화
- 앱 실행 → 설정 탭 → Claude API 키 입력
- console.anthropic.com 에서 API 키 발급 (sk-ant-...)
- 3일 이상 기록 후 AI 제안 활성화 (동일 시간대 3개 이상 필요)

### 4. Claude Code에서 맥락 복원
```
https://github.com/SD1056/My_app 이 프로젝트 이어서 작업하려고 해.
PROGRESS.md 읽고 M4 출시 준비부터 시작해줘.
```

---

## 프로젝트 구조

```
Myapp/
├── .adr/                              # 아키텍처 결정 기록 (ADR)
│   ├── 0000-index.md
│   ├── 0001-flutter-cross-platform.md
│   ├── 0002-local-sqlite-no-backend.md
│   ├── 0003-claude-api-cloud-ai.md
│   ├── 0004-riverpod-state-management.md
│   ├── 0005-feature-first-structure.md
│   └── 0006-on-demand-ai-suggestion.md
├── .github/workflows/flutter_ci.yml  # GitHub Actions CI
├── .planning/                         # 기획 문서
│   ├── 00-vision.md
│   ├── 01-requirements.md
│   ├── 02-architecture.md
│   ├── 03-ux-flow.md
│   └── 04-roadmap.md
├── lib/
│   ├── main.dart                      # 진입점, 온보딩 분기
│   ├── core/
│   │   ├── database/database_helper.dart
│   │   └── ai/
│   │       ├── ai_service.dart        # Claude API 클라이언트
│   │       └── pattern_analyzer.dart  # 패턴 추출 로직
│   ├── features/
│   │   ├── record/                    # M1: 수동 기록
│   │   │   ├── domain/record.dart
│   │   │   ├── data/record_dao.dart
│   │   │   └── presentation/
│   │   │       ├── record_provider.dart
│   │   │       ├── add_record_sheet.dart
│   │   │       └── home_screen.dart
│   │   ├── suggestion/                # M2: AI 제안
│   │   │   └── presentation/
│   │   │       ├── suggestion_provider.dart
│   │   │       └── suggestion_card.dart
│   │   ├── history/presentation/history_screen.dart
│   │   ├── stats/presentation/stats_screen.dart      # M3
│   │   ├── onboarding/presentation/onboarding_screen.dart  # M3
│   │   └── settings/presentation/settings_screen.dart
│   └── shared/
│       ├── theme/app_theme.dart
│       └── widgets/app_shell.dart
├── README.md                          # 프로젝트 전체 문서
└── PROGRESS.md                        # 현재 파일
```

---

## 커밋 히스토리

| 커밋 | 내용 |
|------|------|
| `84b11c8` | docs: ADR 6개 추가 |
| `57e25c1` | docs: README 전면 작성 |
| `9207663` | docs: PROGRESS.md 최초 작성 |
| `5c5090d` | feat: M3 온보딩, 통계, AI 토글 |
| `710a505` | feat: M2 AI 제안 기능 |
| `692d93d` | feat: M1 수동 기록 기능 |
| `bf477c2` | feat: M0 프로젝트 셋업 |
| `7d9e667` | docs: 로드맵 |
| `77d9197` | docs: UX 플로우 |
| `2cac14b` | docs: 아키텍처 |
| `7ad2497` | docs: 비전 & 요구사항 |
