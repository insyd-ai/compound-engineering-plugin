---
name: commit
description: Create a git commit with integrated self-check validation
argument-hint: "[-m 'message'] [--skip-self-check 'reason']"
allowed-tools: Bash(git:*), Bash(bun:*), Bash(bunx:*)
---

# Commit Command

Create a git commit with mandatory self-check validation before committing. Ensures code quality, test execution, and coverage requirements are met.

## Context

<context>
- Current status: !`git status`
- Staged changes: !`git diff --staged --stat`
- Recent commits: !`git log --oneline -5`
</context>

## Arguments

<args> #$ARGUMENTS </args>

| Argument | Description |
|----------|-------------|
| `-m 'message'` | Commit message (required) |
| `--skip-self-check 'reason'` | Skip validation with mandatory reason |

## Workflow

### Step 1: Parse Arguments

1. Check if `-m` flag is provided with a message
2. Check for `--skip-self-check` flag
3. If `--skip-self-check` is provided, extract the reason (required)

### Step 2: Run Self-Check (Unless Skipped)

If NOT skipping self-check, run these validations:

#### 2.1 TypeScript Check

```bash
bunx tsc --noEmit
```

**Pass criteria**: Exit code 0 (no errors)

#### 2.2 Lint Check

```bash
bun run lint
```

**Pass criteria**: Exit code 0 (no errors, warnings OK)

#### 2.3 Run Unit/Integration Tests

```bash
bun test
```

**Pass criteria**: All tests pass

#### 2.4 Coverage Check

```bash
bun test --coverage
```

**Pass criteria**: Coverage >= 80%

Extract coverage from output and verify threshold.

#### 2.5 E2E Tests (If playwright configured)

If `playwright.config.ts` exists:

```bash
bun run playwright test
```

**Pass criteria**: All E2E tests pass

### Step 3: Evaluate Results

#### If ALL checks pass:

```
✅ Self-Check Passed

| Check | Status | Details |
|-------|--------|---------|
| TypeScript | ✅ PASS | 0 errors |
| Lint | ✅ PASS | 0 errors |
| Tests | ✅ PASS | X/X passed |
| Coverage | ✅ PASS | Y% (threshold: 80%) |

Proceeding with commit...
```

Then proceed to Step 4.

#### If ANY check fails:

```
❌ Self-Check Failed

| Check | Status | Details |
|-------|--------|---------|
| TypeScript | ❌ FAIL | 3 errors |
| Lint | ✅ PASS | 0 errors |
| Tests | ❌ FAIL | 2/15 failed |
| Coverage | ⚠️ N/A | Tests must pass first |

**Issues Found:**
1. TypeScript errors in src/utils/auth.ts:42
2. Test failure in tests/auth.test.ts

**Required Actions:**
1. Fix TypeScript errors
2. Fix failing tests
3. Run `/commit` again

To bypass (NOT RECOMMENDED):
/commit -m "message" --skip-self-check "your reason here"
```

**STOP HERE. Do not commit.**

### Step 4: Create Commit

If self-check passed OR `--skip-self-check` was provided:

#### If self-check passed:

```bash
git add -A
git commit -m "[message]

Self-check: PASSED
- TypeScript: 0 errors
- Tests: X/X passed
- Coverage: Y%
"
```

#### If self-check was skipped:

```bash
git add -A
git commit -m "[message]

⚠️ Self-check: SKIPPED
Reason: [user's reason]
Acknowledged: Developer takes responsibility for validation
"
```

### Step 5: Report Results

#### Success:

```
✅ Commit created successfully

Commit: [hash]
Message: [message]
Files committed: [count]

**Files:**
- [file list]

**Next steps:**
- Push: `git push`
- Create PR: `/pr`
- More commits: `/commit`
```

#### Skip Warning:

```
⚠️ Commit created with self-check skipped

Commit: [hash]
Message: [message]
Skip reason: [reason]

**Warning:** This commit bypassed validation.
- Tests may not pass
- Coverage may be below threshold
- PR review will flag this skip

**Recommended:** Run `/self-check` before pushing.
```

## Skip Behavior

### Valid Reasons for Skip

These reasons are acceptable:
- "emergency hotfix for production"
- "WIP branch, not ready for review"
- "documentation only change"
- "config file update only"
- "reverting previous commit"

### Invalid Reasons (Will Be Flagged in PR Review)

These will be flagged:
- "no time"
- "testing later"
- "tests are slow"
- "" (empty reason)
- Single word reasons

### Audit Trail

When `--skip-self-check` is used:
1. Reason is logged in commit message
2. Flagged in PR review by tdd-timestamp-validator
3. May require additional review approval

## Examples

### Standard commit:

```
/commit -m "Add user authentication feature"
```

### Commit with skip:

```
/commit -m "Emergency hotfix for login" --skip-self-check "Production down, fixing critical auth bug"
```

### Commit after fixing issues:

```
/commit -m "Fix TypeScript errors in auth module"
```

## Integration Points

| Component | Integration |
|-----------|-------------|
| `/self-check` | Runs same validation independently |
| `/workflows:review` | Detects skipped self-checks |
| `tdd-timestamp-validator` | Validates TDD compliance |
| Hooks | PreToolUse enforces TDD before writes |
