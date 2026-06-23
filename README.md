# claude-workspace-architect (local marketplace)

Claude Code **플러그인 + 로컬 마켓플레이스**. 새 Claude Code 작업환경을 *백지에서 시작하지 않고*
검증된 골격으로 설계·생성·감사하게 해준다. (앞서 만든 "로제타스톤" md 가이드를 **능동 하네스**로 승격한 것.)

## 들어 있는 것 — 플러그인 `workspace-architect`
| 컴포넌트 | 무엇 |
|---|---|
| **스킬** `skills/workspace-architect` | 설계 지식(불변 패턴 12·두 계층·CLAUDE.md 섹션 순서·체크리스트·안티패턴). 워크스페이스 설계/정비 맥락이면 **자동 호출**. |
| **커맨드** `/workspace-architect:new-workspace <목적> [경로]` | 패턴대로 CLAUDE.md + 역할 폴더 골격을 **생성**. |
| **커맨드** `/workspace-architect:audit-workspace [경로]` | 워크스페이스를 체크리스트로 **감사**(린터 + 서브에이전트). |
| **서브에이전트** `workspace-auditor` | 판단형 감사관(읽기 전용). |
| **스크립트** `scripts/audit-workspace.sh` | 결정적 린터 — CLAUDE.md 두께·깨진 링크·_INDEX 동기. |
| **훅** `hooks/hooks.json` | PostToolUse 가드 — CLAUDE.md를 편집하면 너무 길 때 가볍게 경고(비차단·자가 게이팅). |

## 설치 (로컬)
```
/plugin marketplace add ~/Documents/claude-workspace-architect
/plugin install workspace-architect@geonhui-local
/plugin list                       # 로드 확인
```
변경하며 개발할 땐:
```
claude --plugin-dir ~/Documents/claude-workspace-architect/plugins/workspace-architect --debug
# 또는 세션 중 컴포넌트 수정 후
/reload-plugins
```

## 쓰는 법
- 새 환경: `/workspace-architect:new-workspace "AI 리서치 노트 관리" ~/research` → 질문 몇 개 후 골격 생성.
- 점검: `/workspace-architect:audit-workspace ~/research` → 통과/경고/문제 + 수정안.
- 설계만 상담: 그냥 "새 워크스페이스 어떻게 짤까" 물으면 스킬이 자동으로 패턴을 적용.

## 구조
```
claude-workspace-architect/
├── .claude-plugin/marketplace.json      ← 마켓플레이스 카탈로그 (name: geonhui-local)
└── plugins/workspace-architect/
    ├── .claude-plugin/plugin.json       ← 플러그인 매니페스트
    ├── skills/workspace-architect/SKILL.md
    ├── commands/{new-workspace,audit-workspace}.md
    ├── agents/workspace-auditor.md
    ├── scripts/audit-workspace.sh
    └── hooks/hooks.json
```

> 배포하려면 이 디렉토리를 git repo로 만들어 push하고, 사용자는 `/plugin marketplace add <repo-url>` 후 설치하면 된다.
