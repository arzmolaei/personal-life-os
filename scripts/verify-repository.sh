#!/usr/bin/env bash
set -euo pipefail

fail() {
  echo "ERROR: $*" >&2
  exit 1
}

required_files=(
  "README.md"
  "AGENTS.md"
  "PROJECT_STATE.md"
  "CONTRIBUTING.md"
  "docs/PRODUCT.md"
  "docs/ARCHITECTURE.md"
  "docs/TEST_STRATEGY.md"
  "docs/SECURITY_AND_PRIVACY.md"
  "docs/LOGGING_AND_OBSERVABILITY.md"
  "docs/GIT_VERSIONING_AND_RECOVERY.md"
  "docs/MULTI_AGENT_WORKFLOW.md"
  "docs/ROADMAP.md"
  "docs/AGENT_ENTRY_PROMPT.md"
  "docs/adr/README.md"
  ".github/pull_request_template.md"
  ".github/CODEOWNERS"
)

for file in "${required_files[@]}"; do
  [[ -f "$file" ]] || fail "required file missing: $file"
done

echo "Required foundation files: OK"

# Block obvious credential material. This is intentionally conservative and is
# not a replacement for GitHub secret scanning or credential rotation.
# Search tracked text files only and exclude this script's pattern definitions.
if git grep -nIE '(github_pat_[A-Za-z0-9_]{20,}|ghp_[A-Za-z0-9]{20,}|-----BEGIN (RSA |EC |OPENSSH )?PRIVATE KEY-----)' -- ':!scripts/verify-repository.sh' ':!docs/SECURITY_AND_PRIVACY.md'; then
  fail "possible credential/private key material found in tracked files"
fi

echo "Basic tracked-secret pattern check: OK"

# Governance adapters must route back to AGENTS.md rather than defining an
# independent competing process.
for adapter in CLAUDE.md GEMINI.md .github/copilot-instructions.md; do
  [[ -f "$adapter" ]] || fail "agent adapter missing: $adapter"
  grep -q 'AGENTS.md' "$adapter" || fail "$adapter does not point to AGENTS.md"
done

echo "Agent instruction routing: OK"

# Prevent accidental real-user fixture directories from being tracked.
if git ls-files | grep -E '^(private-data|user-data|backups)/' >/dev/null; then
  fail "private/user backup data is tracked"
fi

echo "Private-data path check: OK"

# Confirm initial accepted ADRs are present.
adr_count=$(find docs/adr -maxdepth 1 -type f -name '[0-9][0-9][0-9][0-9]-*.md' | wc -l | tr -d ' ')
if [[ "$adr_count" -lt 2 ]]; then
  fail "expected at least two numbered ADRs; found $adr_count"
fi

echo "ADR baseline: OK ($adr_count ADRs)"

echo "Repository foundation verification passed."
