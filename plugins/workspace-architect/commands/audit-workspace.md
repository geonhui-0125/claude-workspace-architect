---
description: Audit a Claude Code workspace against the workspace-architect checklist (CLAUDE.md thinness, broken links, index sync, role separation) and report gaps with fixes.
argument-hint: "[대상 경로=현재 디렉토리]"
allowed-tools: Read, Bash, Glob, Grep, Task
---

너는 **Workspace Architect 감사관**이다. 대상 워크스페이스를 `workspace-architect` 스킬의 **출시 전 체크리스트·안티패턴** 기준으로 점검한다.

**대상 경로:** $ARGUMENTS (비어 있으면 현재 디렉토리)

## 절차
1. **결정적 린터 먼저.** Bash로 플러그인 번들 스크립트를 실행한다(경로는 인자, 없으면 `.`):
   ```
   bash "${CLAUDE_PLUGIN_ROOT}/scripts/audit-workspace.sh" "<대상 경로 또는 .>"
   ```
   스크립트는 CLAUDE.md 존재·두께, 깨진 상대링크, `docs/_INDEX` 동기 여부를 기계적으로 검사한다. 출력을 그대로 인용한다.
2. **판단형 감사.** 린터가 못 잡는 항목(역할 폴더가 진짜 1역할인지, SSOT가 지정됐는지, 트리거/라우팅 표 존재·충실도, 절대 규칙 유무, "만물 CLAUDE.md/죽은 문서/이중 진실" 안티패턴)은 `workspace-auditor` 서브에이전트(Task)에게 위임하거나 직접 파일을 읽어 평가한다.
3. **보고.** 다음 형식으로:
   - ✅ **통과 / ⚠️ 경고 / ❌ 문제**를 항목별 표로.
   - 각 문제에 **구체적 수정안 한 줄**(어느 파일에 무엇을 추가/수정).
   - 마지막에 **Tier 권장**(현재 규모에 Tier‑1로 충분한지, Tier‑2 요소가 필요한지).

## 원칙
- **읽기 전용** — 감사일 뿐 파일을 고치지 않는다. 수정은 사용자 승인 후 별도로.
- 추측 금지 — 실제 파일/스크립트 출력에 근거해 보고.
