---
name: tdd-workflow
description: This skill should be used to understand and follow Test-Driven Development workflow requirements. It defines the mandatory order of operations (tests before code), enforcement mechanisms, and bypass procedures for the TDD workflow used in this plugin.
---

# TDD Workflow Skill

## Overview

This skill enforces Test-Driven Development (TDD) practices across all development work. Tests MUST be written BEFORE implementation code - this is non-negotiable and enforced by hooks.

## The TDD Workflow (MANDATORY)

```
┌─────────────────────────────────────────────────────────────────┐
│                    TDD DEVELOPMENT ORDER                        │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  1. Write Specs ──► 2. Write Functional ──► 3. Write Tests     │
│     (PRD + TDD)        Test Cases            (Unit/Int/E2E)    │
│                                                                 │
│                            │                                    │
│                            ▼                                    │
│                                                                 │
│  6. Self-Check ◄── 5. Run Tests & ◄── 4. Write Implementation  │
│     & Commit         Fix Code              Code                │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

### Step 1: Write Specifications
- Create PRD (Product Requirements Document) - non-technical
- Create TDD (Technical Design Document) - implementation details
- Use `/spec:write` command

### Step 2: Write Functional Test Cases
- Define success criteria
- Document expected behaviors
- Use `/test:functional` command
- Output: `tests/functional/[FeatureName]_functional_tests.md`

### Step 3: Write Tests (BEFORE Code)
Write all tests first - they should FAIL because implementation doesn't exist yet.

```bash
# Unit tests
bun test          # Should fail - no implementation

# Integration tests
bun test          # Should fail

# E2E tests
bun run playwright test    # Should fail
```

**Test File Patterns:**
- `*.test.ts`, `*.test.js`
- `*.spec.ts`, `*.spec.js`
- Files in `tests/`, `__tests__/`, `test/`

### Step 4: Write Implementation Code
NOW write the actual code. The TDD enforcer hook will allow writes because tests exist.

### Step 5: Run Tests & Fix
Run tests repeatedly until ALL pass:

```bash
bun test                    # Unit + Integration
bun test --coverage         # Check coverage >= 80%
bun run playwright test     # E2E
```

**Requirements:**
- ALL tests must pass (100% success)
- Coverage must be >= 80%
- If tests fail, FIX THE CODE (not the tests)

### Step 6: Self-Check & Commit
Use `/commit` command which runs self-check automatically:

```bash
/commit -m "Add user authentication feature"
```

## Enforcement Mechanisms

### 1. Hook Enforcement (PreToolUse)

A hook runs on every Write/Edit operation:
- Checks if file is a test file → allows write
- Checks if file is config/docs → allows write
- For implementation files → checks if corresponding test exists
- If no test found → BLOCKS write with guidance

**What happens when blocked:**
```
TDD ENFORCEMENT: No test file found for 'auth'.

To proceed, either:
1. Write tests first using /test:write for auth
2. Create a test file: auth.test.ts
3. Bypass with --skip-tdd 'your reason here'

TDD workflow: Tests must exist before implementation code.
```

### 2. Stop Hook Enforcement

Before task completion, a prompt hook verifies:
- If implementation code was written
- If tests were run after code changes
- Asks user to run tests if not done

### 3. Commit Enforcement

The `/commit` command:
- Runs full self-check (TypeScript, lint, tests, coverage)
- Blocks commit if checks fail
- Allows bypass with `--skip-self-check "reason"`

### 4. PR Review Enforcement

The `tdd-timestamp-validator` agent in PR reviews:
- Analyzes git commit timestamps
- Verifies tests were committed BEFORE implementation
- Can block PR merge if TDD score < 80%

## Bypass Procedures

### During Development (--skip-tdd)

For exceptional cases, bypass TDD enforcement:

```bash
# Bypass is logged in commit message
/commit -m "Emergency fix" --skip-self-check "Production down, critical auth bug"
```

**Requirements:**
- Reason is MANDATORY
- Logged in commit message
- Flagged in PR review
- User acknowledges responsibility

### Valid Bypass Reasons

These are acceptable:
- "emergency hotfix for production"
- "WIP branch, not ready for review"
- "documentation only change"
- "config file update only"
- "reverting previous commit"

### Invalid Bypass Reasons

These will be flagged in PR review:
- "no time"
- "testing later"
- "tests are slow"
- "" (empty reason)
- Single word reasons

See [bypass-policy.md](./references/bypass-policy.md) for detailed bypass policy.

## Test File Detection

The TDD enforcer looks for tests in these locations:

| Implementation File | Expected Test Locations |
|---------------------|-------------------------|
| `src/auth.ts` | `src/auth.test.ts`, `tests/auth.test.ts`, `src/__tests__/auth.test.ts` |
| `lib/helpers.js` | `lib/helpers.test.js`, `tests/helpers.test.js` |
| `app/api/route.ts` | `app/api/route.test.ts`, `tests/api/route.test.ts` |

**Patterns checked:**
1. Same directory: `{dir}/{name}.test.{ext}`
2. `__tests__` subdirectory: `{dir}/__tests__/{name}.test.{ext}`
3. `tests/` at project root: `tests/{name}.test.{ext}`
4. Parallel structure: `tests/{relative_path}.test.{ext}`

## Coverage Requirements

| Level | Threshold | Enforcement |
|-------|-----------|-------------|
| Minimum | 80% | Blocks commit |
| Target | 90% | Recommended |
| Critical paths | 95% | Strongly recommended |

## Commands

| Command | TDD Integration |
|---------|-----------------|
| `/test:write` | Write tests for a feature |
| `/test:functional` | Create functional test cases |
| `/self-check` | Run all validations |
| `/commit` | Commit with self-check |
| `/workflows:review` | PR review with TDD validation |

## References

- [bypass-policy.md](./references/bypass-policy.md) - Detailed bypass policy and valid reasons
- [enforcement-rules.md](./references/enforcement-rules.md) - Technical details of enforcement
