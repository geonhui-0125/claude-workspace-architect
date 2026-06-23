#!/usr/bin/env bash
# workspace-architect — deterministic workspace linter
#
# Usage:
#   audit-workspace.sh [TARGET_DIR]   full audit, human report, exit 1 on errors
#   audit-workspace.sh --hook         PostToolUse guard: read hook JSON on stdin,
#                                      lint only when a CLAUDE.md was written; never blocks (exit 0)

set -u
THIN_WARN=180   # CLAUDE.md soft line-cap; over this → suggest splitting to docs/

lint_claude_md() {
  local f="$1" lines
  lines=$(grep -c '' "$f" 2>/dev/null); lines=${lines:-0}
  if [ "$lines" -gt "$THIN_WARN" ]; then
    echo "[workspace-architect] ⚠️  $(basename "$f") ${lines}줄(>$THIN_WARN) — 얇게 유지 권장. 상세는 docs/로 분리 고려." >&2
  fi
}

# ---- hook mode -------------------------------------------------------------
if [ "${1:-}" = "--hook" ]; then
  payload=$(cat 2>/dev/null)
  fp=$(printf '%s' "$payload" | python3 -c 'import sys,json
try:
    d=json.load(sys.stdin); ti=d.get("tool_input") or {}
    print(ti.get("file_path") or "")
except Exception:
    print("")' 2>/dev/null)
  if [ "$(basename "$fp" 2>/dev/null)" = "CLAUDE.md" ] && [ -f "$fp" ]; then
    lint_claude_md "$fp"
  fi
  exit 0
fi

# ---- full audit ------------------------------------------------------------
TARGET="${1:-${CLAUDE_PROJECT_DIR:-$PWD}}"
TARGET="${TARGET%/}"
errors=0; warns=0

echo "🔎 Workspace audit: $TARGET"
echo

# 1) CLAUDE.md presence + thinness (패턴 1)
if [ -f "$TARGET/CLAUDE.md" ]; then
  lines=$(grep -c '' "$TARGET/CLAUDE.md")
  echo "✅ CLAUDE.md 있음 (${lines}줄)"
  if [ "$lines" -gt "$THIN_WARN" ]; then
    echo "  ⚠️  ${lines}줄(>$THIN_WARN) — 얇게 유지 권장(상세는 docs/로)."
    warns=$((warns+1))
  fi
else
  echo "❌ CLAUDE.md 없음 — 항상 로드되는 지도가 필요(패턴 1)."
  errors=$((errors+1))
fi

# 2) broken relative links across all *.md (패턴 12)
echo
echo "🔗 상대링크 검사… (템플릿 *template*·*.tmpl 은 placeholder라 제외)"
tmp=$(mktemp)
: > "$tmp"
while IFS= read -r md; do
  d=$(dirname "$md")
  while IFS= read -r tgt; do
    tgt="${tgt%% *}"                       # drop optional "title"
    case "$tgt" in
      http://*|https://*|mailto:*|'#'*|"") continue ;;
    esac
    tgt="${tgt%%#*}"                        # strip #anchor
    [ -z "$tgt" ] && continue
    ( cd "$d" && [ -e "$tgt" ] ) || echo "  ❌ ${md#"$TARGET"/} → $tgt (대상 없음)" >> "$tmp"
  done < <(grep -oE '\]\([^)]+\)' "$md" 2>/dev/null | sed -E 's/^\]\(//; s/\)$//')
done < <(find "$TARGET" -name '*.md' -not -path '*/node_modules/*' -not -iname '*template*' -not -iname '*.tmpl' 2>/dev/null)
brokencount=$(grep -c '❌' "$tmp" 2>/dev/null); brokencount=${brokencount:-0}
if [ "$brokencount" -gt 0 ]; then
  cat "$tmp"; errors=$((errors+brokencount))
else
  echo "  ✅ 깨진 상대링크 없음"
fi
rm -f "$tmp"

# 3) docs/_INDEX master-index presence (패턴 11)
echo
if [ -d "$TARGET/docs" ]; then
  cats=$(find "$TARGET/docs" -maxdepth 1 -name '*.md' ! -name '_*' 2>/dev/null | wc -l | tr -d ' ')
  if [ "$cats" -gt 0 ] && [ ! -f "$TARGET/docs/_INDEX.md" ]; then
    echo "⚠️  docs/에 분류 파일 ${cats}개인데 _INDEX.md(마스터 목차) 없음 — 패턴 11 권장."
    warns=$((warns+1))
  else
    echo "✅ docs/ 구성 점검 통과 (분류 ${cats}개)."
  fi
else
  echo "· docs/ 없음 — Tier‑1(단일 목적)이면 정상."
fi

echo
echo "── 요약: ❌ 문제 ${errors} · ⚠️ 경고 ${warns} ──"
echo "(판단형 항목 — 역할 분리·SSOT·트리거/라우팅 표·절대 규칙 — 은 /workspace-architect:audit-workspace 의 서브에이전트 감사로 확인)"
[ "$errors" -gt 0 ] && exit 1 || exit 0
