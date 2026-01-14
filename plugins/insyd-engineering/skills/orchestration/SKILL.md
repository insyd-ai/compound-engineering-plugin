---
name: orchestration
description: This skill should be used when orchestrating complex multi-step workflows that benefit from isolated sub-agent contexts. It provides patterns for spawning Task-based sub-agents, aggregating results, and coordinating workflows across spec writing, test generation, code implementation, and validation phases.
---

# Sub-Agent Orchestration Skill

## Overview

This skill defines how Claude Code acts as an **orchestrator** that spawns **isolated sub-agents** for specific tasks. Each sub-agent runs in its own context window, preventing context pollution and enabling parallel execution.

## When to Use

This skill should be activated when:
- Implementing multi-step features (spec → tests → code → validation)
- Running parallel research or review tasks
- Coordinating workflows that benefit from isolated contexts
- Aggregating results from multiple specialized agents

## Architecture

```
┌─────────────────────────────────────────────────────────────────────────┐
│                    CLAUDE CODE (ORCHESTRATOR)                           │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                         │
│  ┌──────────────┐   ┌──────────────┐   ┌──────────────┐                │
│  │  Sub-Agent   │   │  Sub-Agent   │   │  Sub-Agent   │                │
│  │   (Task 1)   │   │   (Task 2)   │   │   (Task 3)   │                │
│  │  [isolated]  │   │  [isolated]  │   │  [isolated]  │                │
│  └──────┬───────┘   └──────┬───────┘   └──────┬───────┘                │
│         │                  │                  │                         │
│         └────────┬─────────┴─────────┬───────┘                         │
│                  │                   │                                  │
│                  ▼                   ▼                                  │
│           ┌──────────────────────────────────┐                         │
│           │     RESULTS AGGREGATION          │                         │
│           │  - Validate outputs              │                         │
│           │  - Coordinate next steps         │                         │
│           │  - Track workflow progress       │                         │
│           └──────────────────────────────────┘                         │
│                                                                         │
└─────────────────────────────────────────────────────────────────────────┘
```

## Key Benefits

| Benefit | Description |
|---------|-------------|
| **Isolated Contexts** | Each sub-agent gets fresh context, no bleeding between tasks |
| **Parallel Execution** | Multiple sub-agents can run concurrently |
| **Better Visibility** | Orchestrator tracks all sub-agent activities |
| **Task Enrichment** | Orchestrator can enhance tasks before spawning |
| **Result Aggregation** | Centralized collection and validation of outputs |

## Spawning Sub-Agents

Use the **Task tool** to spawn sub-agents with isolated contexts:

### Pattern: Single Sub-Agent

```
Task tool call:
- subagent_type: "Explore" | "Plan" | "feature-dev:*" | custom agent
- description: "Brief description (3-5 words)"
- prompt: "Detailed task instructions with all necessary context"
```

### Pattern: Parallel Sub-Agents

For independent tasks, spawn multiple sub-agents in a single message:

```
[Message with multiple Task tool calls]
├── Task 1: subagent_type="Explore" → Research codebase
├── Task 2: subagent_type="Explore" → Find similar patterns
└── Task 3: subagent_type="Plan" → Design approach
```

### Pattern: Sequential Sub-Agents

For dependent tasks, wait for results before spawning next:

```
Phase 1: Task (spec-writer) → PRD + TDD documents
         ↓ Wait for results
Phase 2: Task (test-writer) → Test files
         ↓ Wait for results
Phase 3: Task (code-writer) → Implementation
```

## Workflow Phases

### Phase 1: Specification (Sub-Agent)

**Orchestrator actions:**
1. Analyze feature request
2. Enrich with codebase context
3. Spawn spec-writing sub-agent

**Sub-agent task:**
```markdown
Generate PRD and TDD for: [feature description]

Context:
- Existing patterns: [list from codebase analysis]
- Target stack: Bun, TypeScript, [framework]
- Output location: docs/specs/

Requirements:
- PRD: User-focused, Mermaid diagrams, acceptance criteria
- TDD: Architecture, API specs, database schema, security considerations

Return: File paths of generated documents
```

**Orchestrator validation:**
- Verify files exist at expected paths
- Check PRD covers user flows
- Check TDD covers security, performance, architecture

### Phase 2: Test Cases (Sub-Agent)

**Orchestrator actions:**
1. Read generated PRD/TDD
2. Extract requirements for test cases
3. Spawn functional-test sub-agent

**Sub-agent task:**
```markdown
Generate functional test cases for: [feature]

Context:
- PRD: [content or path]
- TDD: [content or path]
- Output: docs/test-cases/[feature]_functional_tests.md

Requirements:
- Success criteria with unique IDs (SC-001, SC-002)
- Test cases covering happy path, error states, edge cases
- Behavioral specifications (When X, Then Y)
```

### Phase 3: Test Writing (Sub-Agent) - BEFORE Code

**HARD BLOCK:** This phase MUST complete before Phase 4.

**Orchestrator actions:**
1. Verify specs and test cases exist
2. Spawn test-writing sub-agent
3. **Validate all tests FAIL** (red phase)

**Sub-agent task:**
```markdown
Write tests for: [feature]

Context:
- Functional test cases: [path]
- TDD specifications: [path]
- Test framework: Bun test + Playwright

Output:
- tests/unit/[feature].test.ts
- tests/integration/[feature].test.ts
- tests/e2e/[feature].spec.ts

Requirements:
- All tests should FAIL (implementation doesn't exist yet)
- Coverage targets: 80% minimum
- Follow patterns from existing tests
```

**Orchestrator validation:**
```bash
# Run tests - they MUST fail
bun test tests/unit/[feature].test.ts
# Expected: FAIL (0 passing, N failing)
```

If tests pass (unexpected), BLOCK and investigate.

### Phase 4: Code Implementation (Iterative Loop)

**Pre-requisite check (HARD BLOCK):**
```
IF (tests do not exist) OR (tests pass unexpectedly):
    BLOCK → "Cannot proceed without failing tests"
    SUGGEST → "Run /test:write first"
```

**Implementation approach:**
Use iterative refinement loop (Ralph pattern):

```markdown
Implement [feature] until all tests pass.

Context:
- Test files: [paths]
- TDD specifications: [path]
- Target files: src/[feature]/

Process:
1. Read failing tests
2. Implement code to make one test pass
3. Run: bun test
4. If tests fail, debug and fix
5. Repeat until ALL tests pass

Completion criteria:
- ALL unit tests pass
- ALL integration tests pass
- ALL E2E tests pass
- Coverage >= 80%
```

**Orchestrator monitoring:**
- Track iteration count
- Validate test results after each iteration
- Escalate if stuck (> 10 iterations without progress)

### Phase 5: Validation (Orchestrator)

**Orchestrator runs self-check:**
```bash
# Compilation
bunx tsc --noEmit

# Lint
bun run lint

# Tests with coverage
bun test --coverage

# E2E tests
bun run playwright test
```

**Validation criteria:**
- [ ] TypeScript: 0 errors
- [ ] Lint: 0 errors (warnings OK)
- [ ] Tests: 100% passing
- [ ] Coverage: >= 80%
- [ ] E2E: All pass

### Phase 6: Commit (If Validation Passes)

Only proceed if all validation passes:
```bash
/commit -m "feat: implement [feature]"
```

## Task Enrichment

Before spawning sub-agents, the orchestrator SHOULD enrich tasks with:

### Codebase Context
```markdown
## Existing Patterns
- Authentication: src/auth/ uses JWT + httpOnly cookies
- Database: Convex with optimistic updates
- API routes: Next.js App Router pattern
```

### Conventions
```markdown
## Project Conventions
- Naming: camelCase for functions, PascalCase for components
- Testing: Colocated tests (*.test.ts next to implementation)
- Errors: Typed errors with error codes
```

### Related Code
```markdown
## Related Files
- Similar feature: src/checkout/ (reference implementation)
- Shared utils: src/lib/validation.ts
- Types: src/types/user.ts
```

## Result Aggregation

After sub-agents complete, orchestrator should:

### 1. Collect Results
```markdown
## Sub-Agent Results

### Spec Writing (Sub-Agent 1)
- Status: Complete
- Outputs:
  - docs/specs/prd/authentication.md
  - docs/specs/tdd/authentication.md

### Test Generation (Sub-Agent 2)
- Status: Complete
- Outputs:
  - tests/unit/auth.test.ts (15 tests)
  - tests/integration/auth.test.ts (8 tests)
  - tests/e2e/auth.spec.ts (5 tests)

### Code Implementation (Sub-Agent 3)
- Status: Complete
- Outputs:
  - src/auth/login.ts
  - src/auth/logout.ts
  - src/auth/middleware.ts
```

### 2. Validate Completeness
- [ ] All expected files created
- [ ] Files contain expected content
- [ ] Tests pass
- [ ] Coverage meets threshold

### 3. Report Summary
```markdown
## Orchestration Summary

**Workflow**: Feature Implementation
**Feature**: User Authentication
**Status**: COMPLETE

**Sub-Agents Spawned**: 3
**Total Iterations**: 7 (code implementation)
**Time**: [duration]

**Outputs**:
- 2 specification documents
- 28 test cases
- 3 implementation files
- Coverage: 87%

**Ready for**: PR creation
```

## Error Handling

### Sub-Agent Failure
If a sub-agent fails:
1. Log the failure reason
2. Check if retryable
3. Retry with enhanced context (up to 2 retries)
4. If still failing, escalate to user

### Validation Failure
If validation fails:
1. Identify failing checks
2. Spawn fix sub-agent with specific guidance
3. Re-run validation
4. If still failing, report to user

### Context Overflow
If sub-agent context fills:
1. Break task into smaller pieces
2. Spawn multiple focused sub-agents
3. Aggregate partial results

## References

- [workflow-patterns.md](./references/workflow-patterns.md) - Common workflow patterns
- [sub-agent-prompts.md](./references/sub-agent-prompts.md) - Effective sub-agent prompt templates
