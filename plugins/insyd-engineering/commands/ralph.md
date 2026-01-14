---
name: ralph
description: "Start autonomous implementation loop - iterate until all tests pass"
argument-hint: "FEATURE_NAME [--max-iterations N]"
---

# Ralph: Autonomous Implementation Loop

Execute an autonomous implementation loop that iterates until all tests pass.

## Pre-Flight Check

Before starting, validate prerequisites:

### 1. Check for Existing Tests

Look for test files matching the feature name:
- `tests/unit/[feature].test.ts`
- `tests/integration/[feature].test.ts`
- `tests/e2e/[feature].spec.ts`

If no tests found:
```
⛔ CANNOT START RALPH

No tests found for: [feature]

Required: Run /test:write [feature] first

TDD Workflow:
1. /spec:write [feature] → Generate PRD + TDD
2. /test:functional [feature] → Generate test cases
3. /test:write [feature] → Write failing tests
4. /ralph [feature] → Implementation loop (you are here)
```

### 2. Verify Tests Fail (Red Phase)

Run tests to confirm they fail:
```bash
bun test tests/unit/[feature].test.ts
```

If tests pass unexpectedly:
```
⚠️ WARNING: Tests pass without implementation

This suggests either:
1. Implementation already exists
2. Tests are mocked incorrectly
3. Tests are not testing the right thing

Please verify tests before proceeding.
```

## Implementation Loop

### Initialize

```markdown
## Ralph Loop: [Feature Name]

### Goal
Implement [feature] until all tests pass

### Starting State
- Unit tests: X failing
- Integration tests: Y failing
- E2E tests: Z failing

### Completion Criteria
- [ ] All unit tests pass
- [ ] All integration tests pass
- [ ] All E2E tests pass
- [ ] Coverage >= 80%
```

### Iterate

For each iteration:

1. **Identify Next Failing Test**
   - Run: `bun test --reporter=tap`
   - Find first failing test

2. **Understand the Test**
   - Read test code
   - Understand what it expects
   - Identify what code needs to be written

3. **Write Minimal Code**
   - Write just enough to pass this ONE test
   - Don't over-engineer
   - Follow existing patterns

4. **Run Tests**
   ```bash
   bun test tests/unit/[feature].test.ts
   ```

5. **Evaluate**
   - If test passes → log success, move to next failing test
   - If test fails → debug and fix, re-run

6. **Log Progress**
   ```markdown
   ### Iteration N
   - Test: [test name]
   - Status: PASS/FAIL
   - Changes: [files modified]
   - Next: [next failing test or "COMPLETE"]
   ```

### Completion Check

When no more failing tests:

1. **Full Test Suite**
   ```bash
   bun test
   ```

2. **Coverage Check**
   ```bash
   bun test --coverage
   ```
   - Required: >= 80%

3. **E2E Tests**
   ```bash
   bun run playwright test tests/e2e/[feature].spec.ts
   ```

4. **Type Check**
   ```bash
   bunx tsc --noEmit
   ```

5. **Lint**
   ```bash
   bun run lint
   ```

## Completion Report

```markdown
## Ralph Loop Complete ✅

### Summary
- **Feature**: [feature name]
- **Iterations**: N
- **Duration**: [time]

### Test Results
- Unit: X/X passing (100%)
- Integration: Y/Y passing (100%)
- E2E: Z/Z passing (100%)
- Coverage: N%

### Files Created/Modified
- `src/[feature]/index.ts` - Main implementation
- `src/[feature]/types.ts` - Type definitions
- [additional files...]

### Quality Checks
- [ ] TypeScript: No errors
- [ ] Lint: No errors
- [ ] Coverage: >= 80%

### Next Steps
1. Run: /self-check
2. If passes: /commit -m "feat: implement [feature]"
```

## Error Handling

### Stuck on Same Test (3+ iterations)

If making no progress:

1. **Re-read the test** - Understand exactly what it expects
2. **Check related code** - Look for dependencies or setup issues
3. **Simplify** - Remove complexity, test basics first
4. **Check mocks** - Ensure mocks match real behavior

### Iteration Limit Reached

If `--max-iterations` is reached:

```markdown
## Ralph Loop: Iteration Limit Reached

### Status
- Iterations: N (max)
- Tests passing: X/Y
- Tests failing: Z

### Failing Tests
- [test 1]: [reason]
- [test 2]: [reason]

### Request
Need guidance on:
- [specific question about failing tests]
```

## Arguments

| Argument | Description | Default |
|----------|-------------|---------|
| `FEATURE_NAME` | Name of the feature to implement | Required |
| `--max-iterations N` | Stop after N iterations | 50 |

## Examples

```bash
# Implement user authentication
/ralph user-authentication

# Implement with iteration limit
/ralph checkout-flow --max-iterations 30

# Implement specific module
/ralph api-rate-limiting --max-iterations 20
```
