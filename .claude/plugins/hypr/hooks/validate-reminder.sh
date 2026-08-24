#!/usr/bin/env bash
# Hypr PostToolUse hook.
#
# After an Edit/Write to a source file in a project with generated Hypr rules:
#   - if ast-grep checks are configured (sgconfig.yml) and ast-grep + jq are
#     installed, run the checks on the edited file and report real violations;
#   - otherwise fall back to a gentle reminder to validate against the rules.
# Deliberately non-intrusive:
#   - stays completely silent unless the project has generated rules
#     (.claude/rules/*.md) AND the edited file is source code;
#   - PostToolUse cannot block a tool that already ran, so this only injects
#     an informational reminder via `additionalContext` (never an error);
#   - always exits 0 so it never surfaces as a hook failure.
#
# Input: PostToolUse event JSON on stdin (fields: tool_input.file_path, cwd).

input="$(cat)"

# Extract a string field. Prefer jq; fall back to a grep/sed parse so the
# hook works on machines without jq.
get_field() {
  local jqpath="$1" key="$2"
  if command -v jq >/dev/null 2>&1; then
    printf '%s' "$input" | jq -r "$jqpath // empty" 2>/dev/null
  else
    printf '%s' "$input" \
      | grep -o "\"$key\"[[:space:]]*:[[:space:]]*\"[^\"]*\"" 2>/dev/null \
      | head -n1 \
      | sed -E "s/.*:[[:space:]]*\"([^\"]*)\"/\1/"
  fi
}

file_path="$(get_field '.tool_input.file_path' 'file_path')"
cwd="$(get_field '.cwd' 'cwd')"
[ -n "$cwd" ] || cwd="$PWD"

# No file path -> nothing to remind about.
[ -n "$file_path" ] || exit 0

# Only nudge in projects that actually have generated Hypr rules.
ls "$cwd"/.claude/rules/*.md >/dev/null 2>&1 || exit 0

# Never nudge for edits to the rules/agents themselves.
case "$file_path" in
  */.claude/*|.claude/*) exit 0 ;;
esac

# Only nudge for source code (positive allowlist of code extensions).
case "$file_path" in
  *.ts|*.tsx|*.js|*.jsx|*.mjs|*.cjs|*.vue|*.svelte|\
  *.py|*.rb|*.go|*.rs|*.java|*.kt|*.php|*.cs|*.swift|*.scala|\
  *.c|*.cc|*.cpp|*.h|*.hpp|*.css|*.scss) ;;
  *) exit 0 ;;
esac

base="$(basename "$file_path")"

emit() { # $1 = message; escape and print as additionalContext
  local m
  m="$(printf '%s' "$1" | sed 's/\\/\\\\/g; s/"/\\"/g')"
  printf '{"hookSpecificOutput":{"hookEventName":"PostToolUse","additionalContext":"%s"}}\n' "$m"
}

# If ast-grep checks are configured AND ast-grep + jq are installed, run the
# checks on this file and report real violations instead of a generic reminder.
# (No global ast-grep install -> fall through to the reminder; no per-edit cost.)
if [ -f "$cwd/sgconfig.yml" ] && command -v ast-grep >/dev/null 2>&1 && command -v jq >/dev/null 2>&1; then
  violations="$( (cd "$cwd" && ast-grep scan -c sgconfig.yml "$file_path" --json 2>/dev/null) \
    | jq -r '[.[] | "\(.ruleId) (L\(.range.start.line + 1))"] | join(", ")' 2>/dev/null )"
  if [ -n "$violations" ]; then
    emit "ast-grep found rule violations in $base: $violations. Fix to conform; run /hypr:conformance for the full report."
    exit 0
  fi
  # No violations found. This may mean the file is conformant OR that no check
  # covers this file's language — either way fall through to the advisory
  # reminder below (the rule set has advisory rules ast-grep can't enforce).
fi

# No machine-check violations (or ast-grep unavailable): gentle reminder.
emit "Edited $base — confirm it follows the project rules in .claude/rules/; run /hypr:validate if unsure."
exit 0
