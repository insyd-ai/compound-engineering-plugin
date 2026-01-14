---
name: self-check
description: This skill should be used for pre-commit validation to verify code correctness against success criteria. It integrates with functional test cases from docs/test-cases/, enforces 80% coverage threshold, and provides validation workflows that can be skipped when needed.
---

# Self-Check Skill

## Overview

This skill provides pre-commit validation to verify code changes meet quality standards and success criteria before committing. It uses Bun as the primary test runner and enforces an 80% coverage threshold.

## When to Use

This skill should be activated:
- Before committing code changes
- When validating implementation against specifications
- As part of the development workflow
- When explicitly requested via `/self-check` command
- Automatically when using `/commit` command

## Validation Workflow

### Step 1: Gather Changes

Identify what has changed:

```bash
# Get staged changes
git diff --staged

# Get list of modified files
git diff --staged --name-only
```

### Step 2: Check for Functional Test Cases

Look for relevant test cases in `docs/test-cases/`:

```bash
# List available test cases
ls docs/test-cases/

# Find test cases related to modified files
# Match by feature name, component, or module
```

### Step 3: Run Validation Checks

#### Code Correctness
- TypeScript compilation: `bunx tsc --noEmit`
- Lint checks: `bun run lint`
- Format verification: `bun run format:check` (if configured)

#### Test Execution
- Unit/Integration tests: `bun test`
- Coverage check: `bun test --coverage`
- E2E tests (if Playwright configured): `bun run playwright test`

#### Coverage Threshold
- **Required**: 80% minimum coverage
- **Target**: 90% for critical paths
- Extract coverage from `bun test --coverage` output
- Block commit if below threshold

#### Success Criteria Verification
If functional test cases exist:
1. Read relevant test case files
2. Verify each success criterion is met
3. Check behavioral specifications match implementation
4. Validate edge cases are handled

### Step 4: Report Results

Generate a validation report:

```markdown
## Self-Check Results

**Status**: ✅ PASS / ❌ FAIL / ⚠️ WARNINGS

### Checks Performed

| Check | Status | Details |
|-------|--------|---------|
| TypeScript | ✅ PASS | 0 errors |
| Lint | ✅ PASS | 0 errors, 2 warnings |
| Tests | ✅ PASS | 15/15 passed |
| Coverage | ✅ PASS | 87% (threshold: 80%) |
| Success Criteria | ✅ PASS | 5/5 verified |

### Issues Found
[List any issues with severity]

### Recommendations
[Suggestions for fixing issues]
```

## Skip Functionality

The self-check can be skipped when needed:

### Skip Methods

1. **Command flag**: `/self-check --skip` or `/commit --skip-self-check`
2. **Environment variable**: `SKIP_SELF_CHECK=true`

### When to Skip

Skip should be used sparingly for:
- Emergency hotfixes
- Work-in-progress commits
- Documentation-only changes
- When explicitly approved by lead

### Skip Acknowledgment

When skipping, acknowledge the bypass:

```markdown
## Self-Check Skipped

**Reason**: [Reason for skipping]
**Acknowledged by**: [Developer name]
**Follow-up**: [When full validation will be performed]
```

## Integration with Commit Workflow

### Automatic Integration

When integrated with the commit workflow:

1. Before commit, self-check runs automatically
2. If all checks pass, commit proceeds
3. If checks fail, user is prompted:
   - Fix issues and retry
   - Skip with acknowledgment
   - Cancel commit

### Manual Usage

Run self-check independently:

```bash
/self-check                    # Full validation
/self-check --quick            # Fast validation (lint + types only)
/self-check --full             # Comprehensive validation
/self-check --skip-tests       # Skip test execution
```

## Validation Without Formal Tests

When no functional test cases exist:

1. **Code Analysis**
   - Verify no obvious bugs (null checks, error handling)
   - Check for security issues (input validation)
   - Validate code follows patterns

2. **Behavioral Verification**
   - Check user-facing behavior works
   - Verify error states are handled
   - Confirm edge cases considered

3. **Manual Verification**
   - Prompt user to confirm behavior
   - Suggest creating functional test cases

## Integration Points

| Command | Integration |
|---------|-------------|
| `/self-check` | Primary command using this skill |
| `/commit` | Runs self-check before commit |
| `/workflows:work` | Runs self-check before shipping |

## Quality Gates

### Pass Criteria

All must be true for PASS:
- [ ] No TypeScript errors
- [ ] No lint errors (warnings allowed)
- [ ] All tests pass
- [ ] Success criteria met (if test cases exist)

### Fail Criteria

Any of these results in FAIL:
- TypeScript compilation errors
- Lint errors (not warnings)
- Test failures
- Unmet success criteria

### Warning Criteria

These generate warnings but allow commit:
- Lint warnings
- Missing test coverage
- No functional test cases for feature

## Best Practices

1. **Run Before Every Commit**: Make self-check part of your workflow
2. **Address Warnings**: Don't ignore warnings, plan to fix them
3. **Create Test Cases**: If validation is weak, create functional test cases
4. **Skip Sparingly**: Use skip only when truly necessary
5. **Follow Up**: If you skip, schedule time to validate later
