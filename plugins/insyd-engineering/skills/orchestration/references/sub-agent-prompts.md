# Sub-Agent Prompt Templates

Effective prompts for spawning sub-agents with the Task tool.

## Template Structure

Every sub-agent prompt should include:

1. **Task Description** - Clear, specific objective
2. **Context** - Relevant background information
3. **Inputs** - What data the sub-agent has access to
4. **Outputs** - Expected deliverables with file paths
5. **Constraints** - Rules, limits, requirements
6. **Success Criteria** - How to know when done

## Spec Writing Sub-Agent

```markdown
## Task: Generate PRD and TDD for [Feature Name]

### Context
Project: [Project name]
Stack: Bun, TypeScript, [Framework], Convex
Feature request: [User's original request]

### Existing Patterns (from codebase analysis)
- Authentication: [pattern]
- API structure: [pattern]
- Database: [pattern]

### Inputs
- User requirements: [summary]
- Related code: [file paths]
- Similar features: [file paths]

### Outputs
Create the following files:
1. `docs/specs/prd/[feature].md` - Product Requirements Document
2. `docs/specs/tdd/[feature].md` - Technical Design Document

### PRD Requirements
- User-focused language (no technical jargon)
- Mermaid diagrams for user flows
- User stories with acceptance criteria
- Non-functional requirements (performance, accessibility)

### TDD Requirements
- Architecture diagram (Mermaid)
- API specifications (endpoints, request/response, errors)
- Database schema (tables, relationships, indexes)
- Security considerations (4 categories: bad actors, users, resources, authorization)
- Performance strategy (caching, optimization)

### Success Criteria
- PRD covers all user-facing requirements
- TDD provides complete implementation guidance
- All diagrams render correctly
- Security section addresses all interaction types
```

## Test Writing Sub-Agent

```markdown
## Task: Write Tests for [Feature Name] (RED Phase)

### Context
This is the TDD RED phase. Tests should FAIL because implementation doesn't exist yet.

### Inputs
- TDD Document: `docs/specs/tdd/[feature].md`
- Functional Test Cases: `docs/test-cases/[feature]_functional_tests.md`
- Test patterns: `tests/unit/*.test.ts` (existing examples)

### Outputs
Create the following test files:
1. `tests/unit/[feature].test.ts` - Unit tests
2. `tests/integration/[feature].test.ts` - Integration tests
3. `tests/e2e/[feature].spec.ts` - Playwright E2E tests

### Test Framework
- Unit/Integration: Bun test
- E2E: Playwright via Bun

### Requirements
- Tests MUST fail initially (no implementation exists)
- Cover all success criteria from functional test cases
- Include edge cases and error scenarios
- Target 80% coverage for implementation
- Use existing test patterns as reference

### Test Categories Required
1. **Happy Path** - Normal successful flows
2. **Error States** - Invalid inputs, failures
3. **Edge Cases** - Boundary conditions, empty states
4. **Security** - Authorization, input validation
5. **Performance** - Load handling (E2E only)

### Success Criteria
- All test files created at specified paths
- Tests compile without errors
- Tests fail when run (expected - no implementation)
- Each success criterion from functional tests has corresponding test
```

## Code Implementation Sub-Agent

```markdown
## Task: Implement [Feature Name] Until All Tests Pass

### Context
TDD GREEN phase. Failing tests exist. Write code to make them pass.

### Inputs
- Test files:
  - `tests/unit/[feature].test.ts`
  - `tests/integration/[feature].test.ts`
  - `tests/e2e/[feature].spec.ts`
- TDD Document: `docs/specs/tdd/[feature].md`
- Related code: [file paths for reference]

### Outputs
Implementation files in:
- `src/[feature]/` - Core implementation
- `src/api/[feature]/` - API routes (if needed)
- `convex/[feature].ts` - Convex backend (if needed)

### Process
1. Read failing test
2. Identify what code needs to be written
3. Write minimal code to pass ONE test
4. Run: `bun test tests/unit/[feature].test.ts`
5. If test fails, debug and fix
6. Move to next failing test
7. Repeat until ALL tests pass

### Constraints
- Write minimal code to pass tests (no over-engineering)
- Follow existing patterns in codebase
- Use TypeScript strict mode
- No `any` types
- Handle errors explicitly

### Completion Criteria
- ALL unit tests pass
- ALL integration tests pass
- ALL E2E tests pass
- Coverage >= 80%

DO NOT return until all tests pass. Keep iterating until complete.
```

## PR Review Sub-Agent (TypeScript)

```markdown
## Task: TypeScript Code Review for PR #[number]

### Context
Reviewing TypeScript code changes in PR.

### Inputs
- PR diff: [changes summary]
- Changed files: [file list]
- PR description: [description]

### Review Criteria
1. **Type Safety**
   - No `any` types
   - Proper generic usage
   - Correct null handling
   - Type guards where needed

2. **Code Quality**
   - Functions < 50 lines
   - Clear naming
   - No code duplication
   - Proper error handling

3. **Conventions**
   - camelCase for variables/functions
   - PascalCase for types/components
   - Consistent imports
   - No unused exports

4. **Testing**
   - Tests exist for new code
   - Tests cover edge cases
   - No test code in production

### Output Format
Return findings as:

```json
{
  "findings": [
    {
      "file": "src/auth/login.ts",
      "line": 42,
      "severity": "high|medium|low",
      "category": "type-safety|quality|convention|testing",
      "issue": "Description of issue",
      "suggestion": "How to fix"
    }
  ],
  "summary": {
    "total": N,
    "high": N,
    "medium": N,
    "low": N,
    "blocking": true|false
  }
}
```

### Blocking Criteria
Mark as blocking if:
- `any` type used without justification
- Missing error handling
- Security vulnerability
- Missing tests for critical code
```

## Bug Fix Sub-Agent

```markdown
## Task: Fix Bug - [Bug Description]

### Context
Bug report: [description]
Expected behavior: [expected]
Actual behavior: [actual]

### Reproduction
Steps to reproduce:
1. [step 1]
2. [step 2]
3. [bug occurs]

### Inputs
- Affected file: [file path]
- Related tests: [test paths]
- Error logs: [relevant logs]

### Process
1. Write test that reproduces bug (should FAIL)
2. Debug to find root cause
3. Fix the code
4. Verify test passes
5. Run full test suite (no regressions)

### Output
- Test file proving bug is fixed
- Code changes with explanation
- Root cause analysis

### Success Criteria
- New test exists that would have caught bug
- Bug is fixed (test passes)
- No regression in other tests
- Root cause documented
```

## Codebase Research Sub-Agent

```markdown
## Task: Research [Topic] in Codebase

### Context
Need to understand: [specific question]
Purpose: [why this research is needed]

### Search Strategy
1. Find files related to [topic]
2. Identify patterns and conventions
3. Document dependencies
4. Note inconsistencies or issues

### Questions to Answer
- Where is [X] implemented?
- What patterns are used for [Y]?
- How does [Z] integrate with other modules?
- Are there any inconsistencies?

### Output Format
Return structured findings:

```markdown
## Research: [Topic]

### Key Findings
1. [Finding 1]
2. [Finding 2]

### File Locations
- Primary: [paths]
- Related: [paths]

### Patterns Identified
- [Pattern 1]: used in [locations]
- [Pattern 2]: used in [locations]

### Dependencies
- External: [packages]
- Internal: [modules]

### Recommendations
- [Recommendation 1]
- [Recommendation 2]
```
```

## Best Practices for Sub-Agent Prompts

### DO
- Provide specific file paths
- Include relevant context from codebase
- Set clear success criteria
- Specify output format

### DON'T
- Leave task ambiguous
- Forget to mention constraints
- Skip providing examples
- Omit success criteria
