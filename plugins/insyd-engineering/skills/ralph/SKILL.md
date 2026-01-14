---
name: ralph
description: This skill should be used for autonomous iterative implementation loops where Claude works on a task repeatedly until completion. It provides patterns for iterating until tests pass, with built-in progress tracking, failure handling, and completion verification.
---

# Ralph: Autonomous Implementation Loop

## Overview

Ralph is an autonomous implementation methodology where Claude works iteratively on a task until completion. Named after Ralph Wiggum's persistent nature, this approach keeps iterating until genuine completion is achieved.

## When to Use

This skill should be activated when:
- Implementing code that must pass existing tests (TDD green phase)
- Fixing bugs through iterative debugging
- Refactoring with continuous validation
- Any task requiring "work until done" behavior

## Core Concept

```
┌─────────────────────────────────────────────────────────────────┐
│                    RALPH ITERATION LOOP                         │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│   ┌──────────┐    ┌───────────┐    ┌──────────────┐            │
│   │  WRITE   │ →  │  VALIDATE │ →  │  COMPLETE?   │            │
│   │  CODE    │    │  (tests)  │    │              │            │
│   └──────────┘    └───────────┘    └──────┬───────┘            │
│        ▲                                   │                    │
│        │              NO                   │ YES                │
│        └───────────────────────────────────┤                    │
│                                            ▼                    │
│                                     ┌──────────────┐           │
│                                     │    DONE      │           │
│                                     └──────────────┘           │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

## Iteration Protocol

### 1. Initial Assessment
Before starting the loop:
```markdown
## Ralph Loop: [Task Name]

### Goal
[What needs to be accomplished]

### Completion Criteria
- [ ] All unit tests pass
- [ ] All integration tests pass
- [ ] All E2E tests pass
- [ ] Coverage >= 80%

### Starting State
- Tests passing: X/Y
- Tests failing: Z
- Coverage: N%
```

### 2. Iteration Cycle

Each iteration follows this pattern:

```bash
# 1. Run tests to identify failures
bun test

# 2. Identify FIRST failing test
# Focus on one test at a time

# 3. Write/fix code to pass that test

# 4. Run tests again
bun test

# 5. If still failing, debug
# 6. If passing, move to next failure
# 7. Repeat until ALL pass
```

### 3. Progress Tracking

Track progress after each iteration:

```markdown
## Iteration N

### Changes Made
- [file]: [change description]

### Test Results
- Before: X/Y passing
- After: X+1/Y passing
- Failed: [test names]

### Next Action
- [What to do in next iteration]
```

### 4. Completion Verification

When all tests pass, verify completion:

```bash
# Full test suite
bun test

# Coverage check
bun test --coverage

# E2E tests
bun run playwright test

# Type check
bunx tsc --noEmit

# Lint
bun run lint
```

## Implementation Strategies

### Strategy 1: Test-by-Test

Focus on one failing test at a time:

```
Iteration 1: Fix test_user_login
Iteration 2: Fix test_user_logout
Iteration 3: Fix test_session_management
...
```

**Best for:** Independent tests, clear requirements

### Strategy 2: Layer-by-Layer

Implement bottom-up by layer:

```
Layer 1: Database models
Layer 2: Service layer
Layer 3: API endpoints
Layer 4: Frontend components
```

**Best for:** Deeply connected code, dependency chains

### Strategy 3: Feature Slice

Implement vertical slices:

```
Slice 1: User registration (DB + API + UI)
Slice 2: User authentication (DB + API + UI)
Slice 3: User profile (DB + API + UI)
```

**Best for:** Feature-focused development

## Error Handling

### Stuck Detection

If the same test fails for 3+ iterations:

1. **Re-read the test** - Understand what it actually expects
2. **Check related code** - Look for misunderstandings
3. **Read error messages** - They often explain the issue
4. **Simplify** - Remove complexity, test basics first

### Common Failure Patterns

| Pattern | Solution |
|---------|----------|
| Type mismatch | Check function signatures, add type guards |
| Null/undefined | Add null checks, use optional chaining |
| Async timing | Add await, check Promise resolution |
| Mock issues | Verify mock setup matches real behavior |
| Import errors | Check paths, export statements |

### Escalation

If stuck after 5+ iterations on same issue:

```markdown
## Stuck: [Issue Description]

### What I Tried
1. [Attempt 1]
2. [Attempt 2]
3. [Attempt 3]

### Error
[Exact error message]

### Files Involved
- [file paths]

### Request
Need guidance on: [specific question]
```

## Integration with Orchestration

When used with the orchestration skill:

```
Orchestrator
├── Phase 1-3: Specs + Tests (Task sub-agents)
│
├── Phase 4: Code Implementation (Ralph loop)
│   └── Ralph Skill activated
│   └── Iterate until tests pass
│   └── Track iterations
│   └── Report completion
│
└── Phase 5-6: Validation + Commit (Orchestrator)
```

### Reporting to Orchestrator

After Ralph loop completes, report:

```markdown
## Ralph Loop Complete

### Summary
- Task: [task name]
- Iterations: N
- Duration: [time]

### Final State
- Tests: X/X passing (100%)
- Coverage: N% (threshold: 80%)

### Files Changed
- [file]: [changes]
- [file]: [changes]

### Ready For
- Self-check validation
- Commit
```

## Best Practices

### DO

- **Focus on one test at a time** - Don't try to fix everything at once
- **Read error messages carefully** - They usually explain the problem
- **Run tests frequently** - After every meaningful change
- **Track progress** - Know how many tests you've fixed
- **Keep changes minimal** - Write just enough to pass the test

### DON'T

- **Change tests to pass** - Fix the code, not the tests
- **Skip coverage check** - It reveals missing tests
- **Ignore warnings** - They often become errors
- **Over-engineer** - Write minimal code to pass
- **Rush completion** - Genuine completion only

## Completion Criteria

A Ralph loop is complete when:

1. **ALL tests pass** (100% success rate)
2. **Coverage meets threshold** (80% minimum)
3. **No TypeScript errors** (strict mode)
4. **No lint errors** (warnings OK)
5. **E2E tests pass** (if applicable)

## References

- [iteration-strategies.md](./references/iteration-strategies.md) - Detailed iteration approaches
- [debugging-guide.md](./references/debugging-guide.md) - Common debugging patterns
