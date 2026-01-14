#!/bin/bash
# detect-test-framework.sh
# Detects test framework configuration at session start and sets environment variables
# for use by other hooks and commands.

set -euo pipefail

cd "$CLAUDE_PROJECT_DIR" || exit 1

# Default TDD enforcement mode
echo "export TDD_ENFORCEMENT=hard" >> "$CLAUDE_ENV_FILE"

# Detect package manager and test runner
if [ -f "bun.lockb" ] || [ -f "bunfig.toml" ]; then
  echo "export PACKAGE_MANAGER=bun" >> "$CLAUDE_ENV_FILE"
  echo "export TEST_RUNNER=bun" >> "$CLAUDE_ENV_FILE"
  echo "export TEST_CMD='bun test'" >> "$CLAUDE_ENV_FILE"
  echo "export COVERAGE_CMD='bun test --coverage'" >> "$CLAUDE_ENV_FILE"
  echo "export INSTALL_CMD='bun install'" >> "$CLAUDE_ENV_FILE"
elif [ -f "package.json" ]; then
  # Check if bun is specified in package.json
  if grep -q '"bun"' package.json 2>/dev/null; then
    echo "export PACKAGE_MANAGER=bun" >> "$CLAUDE_ENV_FILE"
    echo "export TEST_RUNNER=bun" >> "$CLAUDE_ENV_FILE"
    echo "export TEST_CMD='bun test'" >> "$CLAUDE_ENV_FILE"
    echo "export COVERAGE_CMD='bun test --coverage'" >> "$CLAUDE_ENV_FILE"
    echo "export INSTALL_CMD='bun install'" >> "$CLAUDE_ENV_FILE"
  else
    # Fallback to npm
    echo "export PACKAGE_MANAGER=npm" >> "$CLAUDE_ENV_FILE"
    echo "export TEST_RUNNER=npm" >> "$CLAUDE_ENV_FILE"
    echo "export TEST_CMD='npm test'" >> "$CLAUDE_ENV_FILE"
    echo "export COVERAGE_CMD='npm test -- --coverage'" >> "$CLAUDE_ENV_FILE"
    echo "export INSTALL_CMD='npm install'" >> "$CLAUDE_ENV_FILE"
  fi
fi

# Detect Playwright for E2E tests
if [ -f "playwright.config.ts" ] || [ -f "playwright.config.js" ]; then
  echo "export E2E_FRAMEWORK=playwright" >> "$CLAUDE_ENV_FILE"
  # Use bun if available, otherwise npx
  if [ -f "bun.lockb" ] || [ -f "bunfig.toml" ]; then
    echo "export E2E_CMD='bun run playwright test'" >> "$CLAUDE_ENV_FILE"
    echo "export E2E_UI_CMD='bun run playwright test --ui'" >> "$CLAUDE_ENV_FILE"
  else
    echo "export E2E_CMD='npx playwright test'" >> "$CLAUDE_ENV_FILE"
    echo "export E2E_UI_CMD='npx playwright test --ui'" >> "$CLAUDE_ENV_FILE"
  fi
fi

# Detect test directories
if [ -d "tests" ]; then
  echo "export TEST_DIR=tests" >> "$CLAUDE_ENV_FILE"
elif [ -d "test" ]; then
  echo "export TEST_DIR=test" >> "$CLAUDE_ENV_FILE"
elif [ -d "__tests__" ]; then
  echo "export TEST_DIR=__tests__" >> "$CLAUDE_ENV_FILE"
fi

# Detect E2E test directory
if [ -d "tests/e2e" ]; then
  echo "export E2E_TEST_DIR=tests/e2e" >> "$CLAUDE_ENV_FILE"
elif [ -d "e2e" ]; then
  echo "export E2E_TEST_DIR=e2e" >> "$CLAUDE_ENV_FILE"
fi

# Detect TypeScript
if [ -f "tsconfig.json" ]; then
  echo "export HAS_TYPESCRIPT=true" >> "$CLAUDE_ENV_FILE"
  if [ -f "bun.lockb" ] || [ -f "bunfig.toml" ]; then
    echo "export TSC_CMD='bunx tsc --noEmit'" >> "$CLAUDE_ENV_FILE"
  else
    echo "export TSC_CMD='npx tsc --noEmit'" >> "$CLAUDE_ENV_FILE"
  fi
fi

# Detect linting configuration
if [ -f "eslint.config.js" ] || [ -f "eslint.config.mjs" ] || [ -f ".eslintrc.js" ] || [ -f ".eslintrc.json" ]; then
  echo "export HAS_ESLINT=true" >> "$CLAUDE_ENV_FILE"
  echo "export LINT_CMD='bun run lint'" >> "$CLAUDE_ENV_FILE"
fi

# Set coverage threshold
echo "export COVERAGE_THRESHOLD=80" >> "$CLAUDE_ENV_FILE"

exit 0
