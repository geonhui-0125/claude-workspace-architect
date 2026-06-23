---
name: workspace-architect
description: >-
  Use when designing, scaffolding, refactoring, or auditing a Claude Code working environment —
  i.e. authoring a CLAUDE.md plus folder structure, or deciding how to organize a new repo/workspace
  so Claude Code works well in it. Provides the invariant "Rosetta Stone" patterns (thin always-loaded
  map, role-separated folders, routing + trigger tables, single source of truth, absolute rules,
  optional .claude harness), the two tiers, a recommended CLAUDE.md section order, a pre-ship
  checklist, and anti-patterns. Pair with /workspace-architect:new-workspace to generate a workspace
  and /workspace-architect:audit-workspace to check one.
allowed-tools: Read, Write, Edit, Bash, Glob, Grep
---

# Workspace Architect — Claude Code 환경 설계 로제타스톤

좋은 Claude Code 환경 = **항상 로드되는 얇은 지도(`CLAUDE.md`)** + **역할이 하나씩인 폴더들** +
**라우팅·트리거 표** + **살아있는 문서 규칙**, 그리고 필요하면 **`.claude/` 하네스**로 규칙을 강제.
도메인(개발·문서작업·리서치·운영)이 달라도 이 골격은 변하지 않는다 — 슬롯을 도메인 언어로 "번역"할 뿐.

## 언제 이 스킬을 쓰나
- "새 작업환경/워크스페이스를 만들자", "CLAUDE.md를 어떻게 쓰지", "이 repo를 Claude가 잘 쓰게 정리"
- 기존 환경이 어수선해 재정비 → 먼저 `/workspace-architect:audit-workspace`로 진단
- 새로 만들 땐 `/workspace-architect:new-workspace <목적/도메인>`로 골격 생성

## 두 계층 (필요한 만큼만 — 과설계 금지)
| | Tier‑1 (거의 모든 환경) | Tier‑2 (규모/협업/위험 커질 때 추가) |
|---|---|---|
| 구성 | `CLAUDE.md` + 역할 폴더 + (선택)`docs/` | + 사람용 `README.md` + `docs/_INDEX·_TEMPLATE` + `.claude/`(hooks·skills·commands·agents) |
| 적합 | 1인, 단일 목적 | 다인 협업, 배포·시크릿·파괴적 작업 존재 |

> Tier‑1로 시작하고, **아픈 지점에서만** Tier‑2를 올린다: 규칙을 자꾸 어김→hook, 문서가 낡음→트리거표, 새 작업자→README.

## 불변 패턴 12 (이 골격의 "언어")
| # | 패턴 | 왜 |
|:-:|---|---|
| 1 | **CLAUDE.md = 항상 로드되는 얇은 지도** | 매 세션 자동 로드 → 짧고 핵심만, 상세는 `docs/`로 위임해 context 절약 |
| 2 | **역할 폴더 분리표** | 폴더마다 역할 하나. 섞이면 "어디 두지?"가 매번 발생 |
| 3 | **라우팅 표 (작업→위치)** | "이 작업엔 여기를 봐라"가 context 절약 핵심 |
| 4 | **트리거 매핑 표 (변화→갱신)** | 문서를 살아있게: 무엇이 바뀌면 어떤 문서를 고칠지 박제 |
| 5 | **단일 진실의 원천(SSOT) 지정** | 같은 사실이 두 곳에 있으면 어긋남. 원천 명시 + 나머진 미러 |
| 6 | **얇은 인덱스 + docs/ 상세 분리** | 한 파일에 다 넣으면 무겁고 안 읽힘 |
| 7 | **절대 규칙(번호 매김)** | 타협 불가 가드(시크릿·파괴적 작업 등)를 명시 |
| 8 | **살아있는 문서 정책** | 코드/사실이 바뀌면 같은 작업단위에서 문서도 갱신 |
| 9 | **(Tier‑2) .claude/ 하네스** | 규칙을 의지가 아니라 하네스 레벨에서 결정적으로 강제 |
| 10 | **(선택) 사람용 README** | 에이전트용 CLAUDE.md와 분리된 온보딩 |
| 11 | **반복물용 _TEMPLATE + _INDEX** | 새 항목을 같은 모양으로 찍어냄 + 마스터 목차 |
| 12 | **표기 컨벤션** | 표 우선·상대경로 링크·이모지 마커·날짜 항목 → 스캔성·일관성 |

### 로제타 번역 예 (같은 슬롯, 다른 도메인)
| 슬롯 | 개발 환경 | 문서작업 환경 |
|---|---|---|
| 핵심 흐름 | 로컬 빌드 → dev 배포·검증 → prod 머지 | 자료 → resource 보관 → docs 색인 → output 산출 |
| 역할 폴더 | 코드 repo·`docs/`·`.claude/` | `resource/`·`docs/`·`output/`·`skill/` |
| SSOT | `docs/`(스킬은 래퍼) | `CLAUDE.md` 매핑표(`_INDEX`는 미러) |
| 절대 규칙 | 시크릿 금지·prod 라이브·핫픽스 금지 | 원문 가공 금지·색인 누락 금지 |

> 새 환경 X를 설계할 땐 이 표 오른쪽에 X를 채워 보라. 안 채워지는 슬롯이 곧 아직 안 정한 부분이다.

## CLAUDE.md 권장 섹션 순서 (얇게 유지 — 길면 docs/로)
1. `# 제목 — 한 줄 정체성`
2. `>` 블록쿼트: "항상 로드되는 지도" + context 절약 안내 + "어디 볼지 모르면 라우팅 표부터"
3. **🎯 핵심 흐름** (가능하면 ASCII 다이어그램)
4. **📂 역할 폴더 표** (패턴 2)
5. **🗺️ 분류/구성 매핑표** + SSOT 명시 (패턴 5)
6. **🔁 트리거 표** (패턴 4)
7. **🧭 라우팅 표** (패턴 3 — 하위 문서 전부 상대링크)
8. **⛔ 절대 규칙** (패턴 7)
9. (Tier‑2) 하네스/README 포인터

## 출시 전 체크리스트
- [ ] `CLAUDE.md`가 1화면 안에 핵심을 보여주는가? (넘치면 `docs/`로)
- [ ] 모든 폴더가 역할 한 줄로 설명되는가?
- [ ] 라우팅 표가 있고 모든 하위 문서로 상대경로 링크가 걸렸는가?
- [ ] 트리거 표가 "무엇이 바뀌면 무엇을 갱신"을 덮는가?
- [ ] 중복 사실에 SSOT가 지정되고 미러 동기 규칙이 있는가?
- [ ] 절대 규칙이 명시적인가? (특히 시크릿·파괴적 작업)
- [ ] 깨진 링크/유령 경로가 없는가?

## 안티패턴
- **만물 CLAUDE.md** → 얇은 인덱스 + docs/ 분리. **진행 로그 떡칠** → 목적별 폴더 분산.
- **죽은 문서** → 트리거 표 + 살아있는 정책. **이중 진실** → SSOT 지정.
- **의지에 기댄 규칙** → 위험 환경은 `.claude/` hook. **과설계** → Tier‑1로 시작.

## 동작 방식
- 생성: `/workspace-architect:new-workspace <목적/도메인, 또는 스펙 @파일·URL·gh:owner/repo/path> [경로]` — 외부 스펙이면 먼저 받아 요구사항으로 삼고, 위 패턴대로 CLAUDE.md + 폴더 골격 생성.
- 점검: `/workspace-architect:audit-workspace [경로]` — 결정적 린터 + `workspace-auditor` 서브에이전트로 체크리스트 감사.
