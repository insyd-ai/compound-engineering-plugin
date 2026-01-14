#!/bin/bash
# tdd-enforcer.sh
# TDD enforcement hook for PreToolUse on Write/Edit operations.
# Validates that test files exist before allowing implementation code to be written.
# Uses pattern matching to find corresponding test files.

set -euo pipefail

# Read input from stdin (Claude Code hook input)
input=$(cat)

# Extract file path from tool input
file_path=$(echo "$input" | jq -r '.tool_input.file_path // empty')

# Skip if no file path provided
if [ -z "$file_path" ]; then
  exit 0
fi

# Normalize path for pattern matching
normalized_path="$file_path"

# ========================================
# ALWAYS ALLOW: Test files
# ========================================
if [[ "$normalized_path" == *".test."* ]] || \
   [[ "$normalized_path" == *".spec."* ]] || \
   [[ "$normalized_path" == *"/tests/"* ]] || \
   [[ "$normalized_path" == *"/__tests__/"* ]] || \
   [[ "$normalized_path" == *"/test/"* ]]; then
  exit 0
fi

# ========================================
# ALWAYS ALLOW: Configuration and documentation
# ========================================
# Config files
if [[ "$normalized_path" == *.json ]] || \
   [[ "$normalized_path" == *.yml ]] || \
   [[ "$normalized_path" == *.yaml ]] || \
   [[ "$normalized_path" == *.toml ]] || \
   [[ "$normalized_path" == *.config.* ]] || \
   [[ "$normalized_path" == *".env"* ]] || \
   [[ "$normalized_path" == *"package.json" ]] || \
   [[ "$normalized_path" == *"tsconfig"* ]] || \
   [[ "$normalized_path" == *"eslint"* ]] || \
   [[ "$normalized_path" == *"prettier"* ]]; then
  exit 0
fi

# Documentation files
if [[ "$normalized_path" == *.md ]] || \
   [[ "$normalized_path" == *.mdx ]] || \
   [[ "$normalized_path" == *.txt ]] || \
   [[ "$normalized_path" == *"/docs/"* ]]; then
  exit 0
fi

# Styling files
if [[ "$normalized_path" == *.css ]] || \
   [[ "$normalized_path" == *.scss ]] || \
   [[ "$normalized_path" == *.sass ]] || \
   [[ "$normalized_path" == *.less ]]; then
  exit 0
fi

# ========================================
# CHECK: TypeScript/JavaScript implementation files
# ========================================
if [[ "$normalized_path" == *.ts ]] || \
   [[ "$normalized_path" == *.tsx ]] || \
   [[ "$normalized_path" == *.js ]] || \
   [[ "$normalized_path" == *.jsx ]]; then

  # Extract base name without extension
  filename=$(basename "$normalized_path")
  base_name="${filename%.*}"
  # Handle .tsx, .jsx extensions
  base_name="${base_name%.tsx}"
  base_name="${base_name%.jsx}"
  dir_name=$(dirname "$normalized_path")

  # Track if test found
  test_found=false

  # ----------------------------------------
  # Pattern 1: Same directory (file.test.ts, file.spec.ts)
  # ----------------------------------------
  for ext in "test.ts" "test.js" "spec.ts" "spec.js" "test.tsx" "test.jsx" "spec.tsx" "spec.jsx"; do
    if [ -f "${dir_name}/${base_name}.${ext}" ]; then
      test_found=true
      break
    fi
  done

  # ----------------------------------------
  # Pattern 2: __tests__ subdirectory
  # ----------------------------------------
  if [ "$test_found" = false ] && [ -d "${dir_name}/__tests__" ]; then
    for ext in "test.ts" "test.js" "spec.ts" "spec.js" "test.tsx" "test.jsx"; do
      if [ -f "${dir_name}/__tests__/${base_name}.${ext}" ]; then
        test_found=true
        break
      fi
    done
  fi

  # ----------------------------------------
  # Pattern 3: tests/ directory at project root
  # ----------------------------------------
  if [ "$test_found" = false ]; then
    project_root="${CLAUDE_PROJECT_DIR:-$(pwd)}"
    for test_dir in "tests/unit" "tests" "test" "__tests__"; do
      if [ -d "${project_root}/${test_dir}" ]; then
        for ext in "test.ts" "test.js" "spec.ts" "spec.js"; do
          if [ -f "${project_root}/${test_dir}/${base_name}.${ext}" ]; then
            test_found=true
            break 2
          fi
        done
      fi
    done
  fi

  # ----------------------------------------
  # Pattern 4: Parallel test directory structure
  # Example: src/utils/helper.ts -> tests/utils/helper.test.ts
  # ----------------------------------------
  if [ "$test_found" = false ]; then
    project_root="${CLAUDE_PROJECT_DIR:-$(pwd)}"
    # Get relative path from project root
    rel_path="${normalized_path#${project_root}/}"
    # Replace src/ with tests/
    test_rel_path="${rel_path/src\//tests\/}"
    test_rel_path="${test_rel_path/lib\//tests\/}"
    # Try to find test file
    for ext in "test.ts" "test.js" "spec.ts" "spec.js"; do
      potential_test="${project_root}/${test_rel_path%.*}.${ext}"
      if [ -f "$potential_test" ]; then
        test_found=true
        break
      fi
    done
  fi

  # ----------------------------------------
  # DECISION: HARD BLOCK or allow
  # ----------------------------------------
  if [ "$test_found" = false ]; then
    # Output HARD DENIAL - no code without tests
    cat <<EOF >&2
{
  "hookSpecificOutput": {
    "permissionDecision": "deny"
  },
  "systemMessage": "⛔ TDD HARD BLOCK: No test file found for '${base_name}'.\n\n┌────────────────────────────────────────────────────┐\n│  CANNOT WRITE IMPLEMENTATION CODE WITHOUT TESTS   │\n└────────────────────────────────────────────────────┘\n\n📋 Required TDD Workflow:\n1. /spec:write → Generate PRD + TDD specs\n2. /test:functional → Generate functional test cases\n3. /test:write → Write unit/integration/E2E tests (RED phase)\n4. THEN write implementation code (GREEN phase)\n\n🔧 To proceed:\n• Run: /test:write ${base_name}\n• Or create: ${base_name}.test.ts\n\n⚠️  Bypass (emergencies only):\n• /commit --skip-self-check 'emergency: [reason]'\n\nThis is a HARD BLOCK. Tests MUST exist before code."
}
EOF
    exit 2
  fi
fi

# Default: allow the operation
exit 0
