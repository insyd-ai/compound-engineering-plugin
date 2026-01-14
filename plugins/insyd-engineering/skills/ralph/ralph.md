---
name: ralph
description: "Start autonomous implementation loop - iterate until all tests pass"
argument-hint: "FEATURE_NAME [--max-iterations N]"
---

# Ralph: Autonomous Implementation Loop

This command starts an autonomous implementation loop that iterates until all tests pass.

## Prerequisites

Before running Ralph, ensure:
1. **Specs exist**: PRD + TDD in `docs/specs/`
2. **Functional test cases exist**: In `docs/test-cases/`
3. **Tests exist and FAIL**: Unit/integration/E2E tests in `tests/`

If any prerequisite is missing, use these commands first:
- `/spec:write [feature]` - Generate specifications
- `/test:functional [feature]` - Generate functional test cases
- `/test:write [feature]` - Write tests (they should FAIL)

## Workflow

When Ralph is invoked:

### Phase 1: Validate Prerequisites

1. Check for failing tests in `tests/unit/`, `tests/integration/`, `tests/e2e/`
2. If no tests exist → BLOCK with guidance to run `/test:write` first
3. If tests pass unexpectedly → BLOCK with warning

### Phase 2: Iterative Implementation

Execute implementation loop:

```
Iteration N:
1. Read failing test
2. Write minimal code to pass test
3. Run: bun test
4. If test passes → move to next failing test
5. If test fails → debug and fix
6. Repeat until ALL tests pass
```

### Phase 3: Validation

After all tests pass:

```bash
# Full validation
bunx tsc --noEmit       # TypeScript
bun run lint            # Lint
bun test --coverage     # Coverage >= 80%
bun run playwright test # E2E
```

### Phase 4: Report

Generate completion report:

```markdown
## Ralph Loop Complete

### Summary
- Feature: [name]
- Iterations: N
- Tests: X/X passing (100%)
- Coverage: Y%

### Files Changed
- [file list with changes]

### Ready For
- /self-check
- /commit -m "feat: implement [feature]"
```

## Usage

```bash
# Basic usage - iterate until tests pass
/ralph user-authentication

# With iteration limit
/ralph checkout-flow --max-iterations 30
```

## Rules

1. **Tests MUST exist** - Ralph will not start without failing tests
2. **Fix code, not tests** - If a test seems wrong, verify with spec first
3. **Minimal changes** - Write just enough code to pass each test
4. **No premature optimization** - Make it work first, optimize later
5. **Track progress** - Log each iteration's changes and results

## Integration with Orchestration

Ralph integrates with the orchestration skill as the implementation phase:

```
Orchestrator
├── Task(spec-writer) → PRD + TDD
├── Task(functional-test-writer) → Test cases
├── Task(test-writer) → Failing tests
├── /ralph [feature] → Implementation loop ← YOU ARE HERE
├── /self-check → Validation
└── /commit → Commit
```

## Emergency Bypass

For emergencies only:
```bash
/commit --skip-self-check "emergency: [specific reason]"
```

Bypasses are logged and flagged in PR review.
