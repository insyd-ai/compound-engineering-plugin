# TDD Enforcement Rules

## Technical Implementation

### Hook Configuration

Location: `plugins/insyd-engineering/hooks/hooks.json`

```json
{
  "hooks": {
    "SessionStart": [...],      // Detect test framework
    "PreToolUse": [...],        // Block writes without tests
    "Stop": [...]               // Verify tests were run
  }
}
```

### PreToolUse Hook Logic

The `tdd-enforcer.sh` script runs on every Write/Edit operation:

```
Input: Tool input JSON with file_path

Decision Tree:
├── Is test file? (*.test.*, *.spec.*, /tests/)
│   └── YES → Allow (exit 0)
├── Is config/doc file? (*.json, *.md, *.yml, etc.)
│   └── YES → Allow (exit 0)
├── Is implementation file? (*.ts, *.js, *.tsx, *.jsx)
│   ├── Find corresponding test file
│   │   ├── Pattern 1: Same directory
│   │   ├── Pattern 2: __tests__ subdirectory
│   │   ├── Pattern 3: tests/ at project root
│   │   └── Pattern 4: Parallel test structure
│   ├── Test found?
│   │   ├── YES → Allow (exit 0)
│   │   └── NO → Block (exit 2)
│   └── Output: Helpful error message
└── Default → Allow (exit 0)
```

### Exit Codes

| Code | Meaning | Action |
|------|---------|--------|
| 0 | Success | Operation allowed |
| 2 | Block | Operation blocked, error shown |
| Other | Error | Non-blocking error, logged |

### Hook Output Format

When blocking:

```json
{
  "hookSpecificOutput": {
    "permissionDecision": "ask"
  },
  "systemMessage": "TDD ENFORCEMENT: No test file found..."
}
```

## Test File Detection Patterns

### Pattern 1: Same Directory

```
src/utils/auth.ts
  ↓ looks for
src/utils/auth.test.ts
src/utils/auth.spec.ts
```

### Pattern 2: __tests__ Subdirectory

```
src/utils/auth.ts
  ↓ looks for
src/utils/__tests__/auth.test.ts
```

### Pattern 3: Tests Directory at Root

```
src/utils/auth.ts
  ↓ looks for
tests/auth.test.ts
tests/unit/auth.test.ts
test/auth.test.ts
```

### Pattern 4: Parallel Structure

```
src/utils/auth.ts
  ↓ looks for
tests/utils/auth.test.ts
```

## File Extensions Supported

### Test File Extensions

```
*.test.ts, *.test.js, *.test.tsx, *.test.jsx
*.spec.ts, *.spec.js, *.spec.tsx, *.spec.jsx
```

### Implementation File Extensions

```
*.ts, *.js, *.tsx, *.jsx
```

### Ignored File Extensions

```
*.json, *.yml, *.yaml, *.toml      # Config
*.md, *.mdx, *.txt                  # Documentation
*.css, *.scss, *.sass, *.less       # Styling
*.env, *.config.*                   # Environment
```

## Stop Hook Logic

The Stop hook uses a prompt to verify TDD compliance:

```
Conditions checked:
1. Were Write/Edit tools used on implementation files?
2. If yes, were test commands run (bun test, playwright)?
3. If tests not run, prompt user to run them

Actions:
- If tests run → Allow completion
- If tests not run → Ask user to run or provide bypass
```

## Coverage Enforcement

### Threshold Configuration

Default: 80% minimum coverage

### How Coverage is Checked

1. Run `bun test --coverage`
2. Parse coverage output
3. Extract total percentage
4. Compare against threshold

### Coverage Report Format

```
----------|---------|----------|---------|---------|
File      | % Stmts | % Branch | % Funcs | % Lines |
----------|---------|----------|---------|---------|
All files |   87.5  |   82.3   |   91.2  |   87.5  |
----------|---------|----------|---------|---------|
```

## PR Review Enforcement

### TDD Timestamp Validator

Checks commit history to verify TDD order:

```bash
# Get first commit for implementation file
git log --diff-filter=A --format="%ai" -- src/auth.ts

# Get first commit for test file
git log --diff-filter=A --format="%ai" -- tests/auth.test.ts

# Compare: test timestamp must be <= implementation timestamp
```

### TDD Score Calculation

```
TDD Score = (Files with tests first) / (Total impl files) * 100

Thresholds:
- 100%: PASS
- 80-99%: WARNING (advisory)
- <80%: FAIL (blocks merge)
```

### Special Cases

| Case | Handling |
|------|----------|
| Same commit | Valid (test and impl committed together) |
| Squashed commits | Cannot validate, note as advisory |
| Single commit PR | Cannot validate order |
| Refactoring | Check if tests also modified |

## Error Messages

### Missing Test File

```
TDD ENFORCEMENT: No test file found for 'auth'.

To proceed, either:
1. Write tests first using /test:write for auth
2. Create a test file: auth.test.ts
3. Bypass with --skip-tdd 'your reason here'

TDD workflow: Tests must exist before implementation code.
```

### Tests Not Run

```
Before completing: Implementation code was written but tests weren't run.

Please run:
  bun test
  bun test --coverage

Or bypass with --skip-tdd 'reason'
```

### Coverage Below Threshold

```
❌ Coverage check failed

Coverage: 67% (threshold: 80%)

Increase test coverage by:
1. Adding tests for uncovered functions
2. Testing more edge cases
3. Checking coverage report for gaps

Run: bun test --coverage
```
