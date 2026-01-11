---
name: self-check
description: Run pre-commit validation checks on staged changes
argument-hint: "[--quick | --full | --skip-tests]"
---

# Self-Check Command

Run pre-commit validation to verify code correctness and success criteria before committing.

## Introduction

This command validates your changes before committing by:
- Checking code correctness (syntax, types, lint)
- Running tests
- Verifying against functional test success criteria (if they exist)
- Reporting issues and recommendations

## Options

<check_options> #$ARGUMENTS </check_options>

| Option | Description |
|--------|-------------|
| `--quick` | Fast validation: lint + types only |
| `--full` | Comprehensive: all checks + reviewer agents |
| `--skip-tests` | Skip test execution |
| (no option) | Standard validation |

## Execution Workflow

### Phase 1: Gather Changes

<gather_changes>

1. **Get Staged Changes**:

   ```bash
   # List staged files
   git diff --staged --name-only

   # Get diff of staged changes
   git diff --staged
   ```

2. **Identify Affected Areas**:
   - Which components are modified
   - Which features are affected
   - Are there related test files

3. **Check for Functional Test Cases**:

   ```bash
   # Look for related test cases
   ls docs/test-cases/
   ```

</gather_changes>

### Phase 2: Run Validation Checks

<validation_checks>

#### Standard Checks (Always Run)

1. **TypeScript Compilation**:
   ```bash
   npx tsc --noEmit
   ```
   - Must pass (0 errors)
   - Warnings are acceptable

2. **Lint Checks**:
   ```bash
   npm run lint
   ```
   - Errors must be fixed
   - Warnings generate advisory

3. **Format Check** (if configured):
   ```bash
   npm run format:check
   ```

#### Test Execution (Unless --skip-tests)

4. **Run Affected Tests**:
   ```bash
   # Run tests for changed files
   npm test -- --changedSince=HEAD~1

   # Or run full test suite if needed
   npm test
   ```

#### Full Check Additional (--full only)

5. **Run Reviewer Agents**:

   Launch selective review agents based on changes:

   - If TypeScript changes: **Task kieran-typescript-reviewer**
   - If security-related: **Task security-sentinel**
   - If performance-critical: **Task performance-oracle**
   - If complex logic: **Task code-simplicity-reviewer**

</validation_checks>

### Phase 3: Success Criteria Verification

<success_criteria>

If functional test cases exist in `docs/test-cases/`:

1. **Read Relevant Test Cases**:
   - Find test cases related to modified features
   - Extract success criteria

2. **Verify Success Criteria**:

   For each success criterion:
   - [ ] Check if implementation meets criterion
   - [ ] Verify behavioral specs are satisfied
   - [ ] Note any gaps

3. **Validation Without Formal Tests**:

   If no functional test cases exist:
   - Check for obvious bugs (null checks, error handling)
   - Verify error states are handled
   - Check edge cases considered
   - Prompt user to confirm behavior works

</success_criteria>

### Phase 4: Report Results

<report_results>

Generate a validation report:

```markdown
## Self-Check Results

**Status**: ✅ PASS | ❌ FAIL | ⚠️ WARNINGS

### Checks Performed

| Check | Status | Details |
|-------|--------|---------|
| TypeScript | ✅ PASS | 0 errors |
| Lint | ✅ PASS | 0 errors, 2 warnings |
| Tests | ✅ PASS | 15/15 passed |
| Success Criteria | ✅ PASS | 5/5 verified |

### Files Checked

- `src/components/Button.tsx` (modified)
- `src/utils/helpers.ts` (modified)
- `src/__tests__/Button.test.tsx` (added)

### Issues Found

#### Errors (Must Fix)
[None found | List of errors]

#### Warnings (Should Review)
[None found | List of warnings]

### Recommendations
[Suggestions for improvement]

---

**Ready to Commit**: Yes | No

If not ready, fix issues and run `/self-check` again.
```

</report_results>

### Phase 5: Decision Point

<decision>

Based on results:

#### If All Checks Pass

```markdown
✅ All checks passed. Ready to commit.

Would you like to:
1. Commit now - run `/commit`
2. Run additional checks - run `/self-check --full`
3. View detailed report
4. Cancel
```

#### If Checks Fail

```markdown
❌ Self-check failed. Please fix the following issues:

**Errors**:
1. [Error 1 with fix suggestion]
2. [Error 2 with fix suggestion]

After fixing, run `/self-check` again.

Or skip with: `/self-check --skip` (not recommended)
```

#### If Warnings Only

```markdown
⚠️ Checks passed with warnings.

**Warnings**:
1. [Warning 1]
2. [Warning 2]

These are advisory and won't block commit.

Would you like to:
1. Commit with warnings - run `/commit`
2. Fix warnings first
3. View detailed report
```

</decision>

## Skip Functionality

<skip>

Self-check can be skipped when necessary:

### How to Skip

- Run: `/self-check --skip`
- Or during commit: `/commit --skip-self-check`

### When to Skip

Skip sparingly for:
- Emergency hotfixes
- Work-in-progress commits
- Documentation-only changes
- When explicitly approved by lead

### Skip Acknowledgment

When skipping, acknowledge:

```markdown
⚠️ Self-check skipped

**Reason**: [User must provide reason]
**Acknowledged**: Self-check will need to run before PR review

Proceeding with commit...
```

</skip>

## Integration with Commit Workflow

<integration>

When used with `/commit`:

1. Self-check runs automatically before commit
2. If all checks pass → commit proceeds
3. If checks fail → user prompted to fix or skip
4. Skip acknowledged and logged in commit message

Example integrated flow:

```
User: /commit "Add user authentication"

[Self-check runs...]

✅ Self-check passed
- TypeScript: 0 errors
- Lint: 0 errors
- Tests: 12/12 passed

Creating commit...
```

</integration>

## Quality Gates

<gates>

### Pass Criteria (All must be true)

- [ ] No TypeScript errors
- [ ] No lint errors (warnings OK)
- [ ] All tests pass
- [ ] Success criteria met (if defined)

### Fail Criteria (Any triggers fail)

- TypeScript compilation errors
- Lint errors (not warnings)
- Test failures
- Unmet success criteria

### Warning Criteria (Advisory only)

- Lint warnings
- Missing test coverage
- No functional test cases defined

</gates>

## Best Practices

1. **Run Before Every Commit**: Make self-check habitual
2. **Fix Warnings**: Don't accumulate technical debt
3. **Create Test Cases**: If validation is weak, add functional tests
4. **Skip Sparingly**: Use skip only when truly necessary
5. **Follow Up**: If you skip, schedule validation later
