# Workflow Patterns

## Pattern 1: Full Feature Development

Complete TDD workflow from spec to deployment.

```
Orchestrator
├── Phase 1: Spec Writing
│   └── Task(Explore) → Gather codebase context
│   └── Task(spec-writer) → Generate PRD + TDD
│
├── Phase 2: Test Cases
│   └── Task(functional-test-writer) → Generate test cases
│
├── Phase 3: Test Writing (MUST complete before Phase 4)
│   └── Task(test-writer) → Generate failing tests
│   └── Validate: All tests FAIL (red phase)
│   └── ⚠️ HARD BLOCK if tests don't exist
│
├── Phase 4: Code Implementation
│   └── Iterative loop until tests pass
│   └── Track iterations and progress
│
├── Phase 5: Validation
│   └── Run self-check (TypeScript, lint, tests, coverage)
│
└── Phase 6: Commit (only if validation passes)
```

## Pattern 2: PR Review

Parallel review agents for comprehensive code review.

```
Orchestrator
├── Setup
│   └── Fetch PR metadata, create worktree
│
├── Parallel Reviews (Single message, multiple Task calls)
│   ├── Task(kieran-typescript-reviewer)
│   ├── Task(security-sentinel)
│   ├── Task(performance-oracle)
│   ├── Task(architecture-strategist)
│   ├── Task(tdd-timestamp-validator)
│   └── Task(code-simplicity-reviewer)
│
├── Conditional Reviews
│   ├── IF database changes → Task(data-integrity-guardian)
│   ├── IF migrations → Task(data-migration-expert)
│   └── IF risky deploy → Task(deployment-verification-agent)
│
├── Aggregation
│   └── Combine all findings, prioritize (P1/P2/P3)
│
└── Report
    └── Generate review summary with file-todos
```

## Pattern 3: Bug Fix

Investigate, reproduce, fix with verification.

```
Orchestrator
├── Investigation
│   └── Task(Explore) → Find affected code
│   └── Task(git-history-analyzer) → Check recent changes
│
├── Reproduction
│   └── Task(bug-reproduction-validator) → Verify bug
│
├── Fix Planning
│   └── Task(Plan) → Design fix approach
│
├── Test First
│   └── Write test that reproduces bug (should FAIL)
│
├── Implementation
│   └── Fix code until test passes
│
└── Validation
    └── Run full test suite, ensure no regressions
```

## Pattern 4: Research and Analysis

Parallel research for informed decisions.

```
Orchestrator
├── Parallel Research (Single message)
│   ├── Task(repo-research-analyst) → Internal patterns
│   ├── Task(framework-docs-researcher) → Framework best practices
│   └── Task(best-practices-researcher) → Industry standards
│
├── Synthesis
│   └── Combine research findings
│   └── Identify conflicts or gaps
│
└── Report
    └── Recommendations with supporting evidence
```

## Pattern 5: Codebase Indexing

Generate comprehensive documentation.

```
Orchestrator
├── Analysis
│   └── Task(codebase-indexer) → Full codebase scan
│
├── Documentation Generation
│   ├── CODEBASE_MAP.md (navigation guide)
│   ├── ARCHITECTURE.md (system design)
│   ├── API_INDEX.md (all endpoints)
│   └── DEPENDENCY_GRAPH.md (dependencies)
│
└── Validation
    └── Verify all sections complete
    └── Check for missing modules
```

## Anti-Patterns to Avoid

### DON'T: Sequential where parallel is possible
```
❌ Bad: Task A → wait → Task B → wait → Task C
✅ Good: Task A, B, C in parallel (single message)
```

### DON'T: Skip the red phase
```
❌ Bad: Write tests → they pass → write code
✅ Good: Write tests → they FAIL → write code → they pass
```

### DON'T: Ignore sub-agent failures
```
❌ Bad: Sub-agent fails → continue anyway
✅ Good: Sub-agent fails → retry with enhanced context → escalate if needed
```

### DON'T: Over-orchestrate simple tasks
```
❌ Bad: Single file fix → spawn 5 sub-agents
✅ Good: Single file fix → just do it directly
```

## When to Use Orchestration vs Direct Execution

| Scenario | Approach |
|----------|----------|
| Multi-file feature | Orchestration |
| Single file fix | Direct execution |
| Complex research | Parallel sub-agents |
| Quick lookup | Direct Explore agent |
| Full TDD workflow | Orchestration |
| Hotfix | Direct execution with bypass |
