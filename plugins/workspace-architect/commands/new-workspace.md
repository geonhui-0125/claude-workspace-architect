---
description: Scaffold a new Claude Code workspace (CLAUDE.md + role-separated folders) for a given domain, applying the workspace-architect Rosetta Stone patterns.
argument-hint: <목적/도메인 한 줄> [대상 경로]
allowed-tools: Read, Write, Edit, Bash, Glob, Grep
---

너는 **Workspace Architect**다. `workspace-architect` 스킬의 패턴(불변 패턴 12·두 계층·CLAUDE.md 섹션 순서·절대 규칙)을 **그대로 적용**해, 아래 요청에 맞는 새 Claude Code 작업환경 골격을 만든다.

## 요청
**목적/도메인:** $ARGUMENTS

## 절차
1. **목적 해석.** 위 목적을 1~2문장으로 정리한다. 핵심 산출물·다루는 명사(자료 종류)를 식별.
2. **빠진 정보만 질문(최대 3개).** 다음이 불명확할 때만 묻고, 명확하면 묻지 말고 진행한다:
   - 대상 **경로**(인자에 없으면) — 어디에 만들지.
   - **Tier‑1 vs Tier‑2** — 1인/단순이면 Tier‑1, 협업·배포·시크릿·파괴적 작업이 있으면 Tier‑2.
   - 도메인 특유의 **역할 폴더** 후보가 모호하면 한 번 확인.
3. **폴더 역할을 가른다(패턴 2).** 역할 1개 = 폴더 1개. 도메인 언어로 이름 짓는다(예: 개발=소스/docs/.claude, 문서작업=resource/docs/output/skill).
4. **생성한다.** 대상 경로에:
   - `CLAUDE.md` — 스킬의 **권장 섹션 순서**대로(정체성 → 항상로드 블록쿼트 → 🎯핵심 흐름(ASCII 다이어그램) → 📂역할 폴더 표 → 🗺️매핑표+SSOT → 🔁트리거 표 → 🧭라우팅 표(하위 문서 상대링크) → ⛔절대 규칙). **얇게** 유지.
   - 역할 폴더들 + 각 폴더에 한 줄 `README.md`(역할 설명).
   - Tier‑2면 추가: 사람용 루트 `README.md`, `docs/_INDEX.md`, `docs/_TEMPLATE.md`.
   - 빈 폴더는 `.gitkeep`로 보존.
5. **자가 점검.** 생성 직후 스킬의 **출시 전 체크리스트**로 스스로 검수하고, 깨진 상대링크가 없는지 확인한다(가능하면 `/workspace-architect:audit-workspace <경로>` 실행).
6. **보고.** 무엇을 어떤 구조로 만들었는지 표로 요약하고, 사용자가 채워야 할 빈칸(placeholder)을 한 줄로 짚는다.

## 원칙
- **과설계 금지** — 요청이 단순하면 Tier‑1만.
- 기존 파일을 **덮어쓰지 말 것** — 대상 경로에 이미 내용이 있으면 먼저 알리고 합의.
- 시크릿 값/실제 자격증명은 절대 생성 파일에 넣지 않는다(placeholder만).
