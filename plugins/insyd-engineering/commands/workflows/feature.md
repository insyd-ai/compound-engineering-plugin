---
name: workflows:feature
description: "Complete TDD feature development workflow with orchestrated sub-agents"
argument-hint: "FEATURE_DESCRIPTION"
---

# Orchestrated Feature Development

This command orchestrates the complete TDD workflow using isolated sub-agents for each phase.

## Workflow Overview

```
Claude Code (Orchestrator)
│
├─ Phase 1: Specifications
│   └─ Task(Explore) → Analyze codebase
│   └─ Task(spec-writer) → Generate PRD + TDD
│
├─ Phase 2: Functional Test Cases
│   └─ Task(functional-test-writer) → Generate test cases
│
├─ Phase 3: Test Writing (RED Phase)
│   └─ Task(test-writer) → Generate failing tests
│   └─ Validate: All tests FAIL
│   └─ ⛔ HARD BLOCK if tests don't exist
│
├─ Phase 4: Implementation (GREEN Phase)
│   └─ /ralph [feature] → Iterate until tests pass
│
├─ Phase 5: Validation
│   └─ /self-check → Full validation suite
│
└─ Phase 6: Commit
    └─ /commit -m "feat: [feature]"
```

## Phase 1: Specifications

### Context Gathering

First, gather codebase context using Explore agent:

**Task 1: Codebase Analysis**
```
Use Task tool with subagent_type="Explore":

Prompt: "Analyze codebase for [feature] implementation:
1. Find related existing features
2. Identify patterns and conventions
3. Locate relevant types and interfaces
4. Find integration points

Return:
- Related file paths
- Pattern descriptions
- Type definitions to use
- Integration recommendations"
```

### Spec Generation

**Task 2: Generate PRD + TDD**
```
Use Task tool with subagent_type="feature-dev:code-architect":

Prompt: "Generate specifications for: [feature description]

Context from codebase analysis:
[Include findings from Task 1]

Output:
1. docs/specs/prd/[feature].md - Product Requirements Document
2. docs/specs/tdd/[feature].md - Technical Design Document

Follow templates from spec-writing skill."
```

### Orchestrator Validation

After spec generation:
- [ ] Verify PRD file exists at expected path
- [ ] Verify TDD file exists at expected path
- [ ] Check PRD includes user flows, stories, acceptance criteria
- [ ] Check TDD includes architecture, API specs, security considerations

## Phase 2: Functional Test Cases

**Task 3: Generate Test Cases**
```
Use Task tool with subagent_type="feature-dev:code-architect":

Prompt: "Generate functional test cases for [feature]

Inputs:
- PRD: docs/specs/prd/[feature].md
- TDD: docs/specs/tdd/[feature].md

Output:
- docs/test-cases/[feature]_functional_tests.md

Include:
- Success criteria (SC-001, SC-002, ...)
- Test cases (TC-001: Happy path, TC-002: Error handling, ...)
- Edge cases
- Security scenarios
- Performance scenarios"
```

### Orchestrator Validation

- [ ] Verify test cases file exists
- [ ] Check coverage of all PRD requirements
- [ ] Verify edge cases included

## Phase 3: Test Writing (RED Phase)

**Task 4: Generate Tests**
```
Use Task tool with subagent_type="feature-dev:code-architect":

Prompt: "Write tests for [feature] - TDD RED Phase

Inputs:
- TDD: docs/specs/tdd/[feature].md
- Functional Test Cases: docs/test-cases/[feature]_functional_tests.md
- Existing test patterns: tests/unit/*.test.ts

Output:
- tests/unit/[feature].test.ts
- tests/integration/[feature].test.ts
- tests/e2e/[feature].spec.ts

Requirements:
- Tests MUST fail (no implementation exists)
- Cover all success criteria
- Use Bun test for unit/integration
- Use Playwright for E2E
- Target 80% coverage"
```

### Orchestrator Validation - CRITICAL

**HARD BLOCK CHECK:**

1. Run tests to verify they exist:
```bash
bun test tests/unit/[feature].test.ts
```

2. Tests MUST fail:
- If tests don't exist → BLOCK, return to Phase 3
- If tests pass → BLOCK, investigate (implementation shouldn't exist)
- If tests fail → PROCEED to Phase 4

```
✅ RED PHASE VERIFIED: Tests exist and fail
   - Unit: 0/15 passing
   - Integration: 0/8 passing
   - E2E: 0/5 passing

Proceeding to implementation...
```

## Phase 4: Implementation (GREEN Phase)

### Pre-requisite Check

```
IF (tests do not exist):
    ⛔ HARD BLOCK
    Return: "Cannot implement without tests. Run Phase 3 first."

IF (tests pass unexpectedly):
    ⛔ HARD BLOCK
    Return: "Tests pass without implementation. Verify test setup."
```

### Execute Ralph Loop

```bash
/ralph [feature] --max-iterations 50
```

Ralph will:
1. Read failing tests
2. Write minimal code to pass each test
3. Iterate until ALL tests pass
4. Report completion

### Orchestrator Monitoring

Track Ralph progress:
- Current iteration
- Tests passing vs failing
- Files being modified

If stuck (no progress for 5+ iterations):
- Provide debugging guidance
- Suggest alternative approaches

## Phase 5: Validation

After Ralph completes, run full validation:

```bash
# TypeScript check
bunx tsc --noEmit

# Lint check
bun run lint

# Full test suite with coverage
bun test --coverage

# E2E tests
bun run playwright test
```

### Validation Report

```markdown
## Validation Results

### Checks
| Check | Status | Details |
|-------|--------|---------|
| TypeScript | ✅ | 0 errors |
| Lint | ✅ | 0 errors, 2 warnings |
| Unit Tests | ✅ | 15/15 passing |
| Integration | ✅ | 8/8 passing |
| E2E | ✅ | 5/5 passing |
| Coverage | ✅ | 87% (threshold: 80%) |

### Decision
✅ READY FOR COMMIT
```

If validation fails:
- Return to Phase 4 (implementation)
- Fix failing checks
- Re-validate

## Phase 6: Commit

Only proceed if Phase 5 passes:

```bash
/commit -m "feat: implement [feature]

- Add [component] for [functionality]
- Include tests (87% coverage)
- Follow TDD workflow

Specs: docs/specs/prd/[feature].md
Tests: docs/test-cases/[feature]_functional_tests.md"
```

## Orchestration Summary Report

At workflow completion:

```markdown
## Feature Development Complete ✅

### Feature: [name]

### Workflow Summary
| Phase | Status | Output |
|-------|--------|--------|
| 1. Specs | ✅ | PRD + TDD |
| 2. Test Cases | ✅ | Functional tests |
| 3. Tests (RED) | ✅ | Unit + Integration + E2E |
| 4. Implementation | ✅ | Source files |
| 5. Validation | ✅ | All checks pass |
| 6. Commit | ✅ | Committed |

### Sub-Agent Activity
- Codebase analysis: 1 task
- Spec generation: 1 task
- Test case generation: 1 task
- Test writing: 1 task
- Implementation: 12 Ralph iterations

### Files Created
- docs/specs/prd/[feature].md
- docs/specs/tdd/[feature].md
- docs/test-cases/[feature]_functional_tests.md
- tests/unit/[feature].test.ts
- tests/integration/[feature].test.ts
- tests/e2e/[feature].spec.ts
- src/[feature]/*.ts

### Quality Metrics
- Test coverage: 87%
- TypeScript: Strict mode
- TDD compliance: 100%

### Ready For
- PR creation: /pr:create
- Code review: /workflows:review
```

## Usage

```bash
# Full TDD workflow for a feature
/workflows:feature "User authentication with email/password and OAuth support"

# Feature with specific scope
/workflows:feature "Checkout flow with cart, payment, and order confirmation"
```
