---
name: test-writing
description: This skill should be used when writing unit tests, integration tests, or functional tests. It provides patterns for test creation, execution, and reporting using Bun test for unit/integration and Playwright for E2E tests. Supports TDD workflow where tests are written BEFORE implementation code.
---

# Test Writing Skill

## Overview

This skill provides structured approaches for writing and executing tests at different levels:

1. **Unit Tests**: Individual function/component testing
2. **Integration Tests**: Module interaction testing
3. **Functional Tests**: End-to-end feature testing

## TDD Workflow (CRITICAL)

Tests MUST be written BEFORE implementation code. This is enforced by hooks.

**Order:**
1. Write test file (`feature.test.ts`)
2. Run tests - they should FAIL (no implementation yet)
3. Write implementation code (`feature.ts`)
4. Run tests - they should PASS
5. Refactor if needed

## When to Use

This skill should be activated when:
- Writing tests for new code (BEFORE implementation)
- Adding test coverage to existing code
- Creating test cases from specifications
- Running and reporting on test results

## Testing Frameworks

This plugin uses Bun as the primary test runner:

| Test Type | Framework | Config File | Run Command |
|-----------|-----------|-------------|-------------|
| Unit | Bun test | bunfig.toml | `bun test` |
| Integration | Bun test | bunfig.toml | `bun test` |
| E2E | Playwright | playwright.config.ts | `bun run playwright test` |
| Convex | Bun test with Convex | convex.config.ts | `bun test` |

## Coverage Requirements

- **Minimum threshold**: 80%
- **Target**: 90% for critical business logic
- **Command**: `bun test --coverage`

## References

For detailed patterns by test type:
- Unit Testing: [unit-testing.md](./references/unit-testing.md)
- Integration Testing: [integration-testing.md](./references/integration-testing.md)
- E2E Testing: [e2e-testing.md](./references/e2e-testing.md)

## Templates

Use the functional test case template at [functional-test-template.md](./assets/functional-test-template.md) for documenting test cases.

## Test Writing Workflow

### Step 1: Determine Test Type

| Scenario | Test Type |
|----------|-----------|
| Testing a single function in isolation | Unit |
| Testing component renders correctly | Unit |
| Testing multiple modules work together | Integration |
| Testing API endpoints | Integration |
| Testing full user workflows | E2E/Functional |
| Testing browser interactions | E2E |

### Step 2: Identify Test Cases

From specifications or code:
1. Happy path (primary success scenario)
2. Edge cases (boundary values, empty states)
3. Error cases (invalid input, failures)
4. Authorization cases (if applicable)

### Step 3: Write Tests

Follow the AAA pattern:
1. **Arrange**: Set up test data and conditions
2. **Act**: Execute the code being tested
3. **Assert**: Verify the expected outcome

### Step 4: Execute and Report

```bash
# Run all tests
bun test

# Run specific test file
bun test path/to/test.test.ts

# Run with coverage
bun test --coverage

# Run in watch mode
bun test --watch

# Run E2E tests
bun run playwright test

# Run E2E with UI
bun run playwright test --ui
```

## Test Naming Conventions

### File Naming
- Unit/Integration: `[filename].test.ts` or `[filename].spec.ts`
- E2E: `[feature].spec.ts` in tests/e2e/ directory

### Test Naming
Use descriptive names that explain the scenario:

```typescript
describe('UserService', () => {
  describe('createUser', () => {
    it('creates user with valid email and password', () => {});
    it('throws error when email is invalid', () => {});
    it('throws error when password is too short', () => {});
  });
});
```

## Integration with Other Commands

| Command | Integration |
|---------|-------------|
| `/test:write` | Primary command that uses this skill |
| `/test:functional` | Creates test case documentation |
| `/self-check` | Runs tests as part of validation |
| `/workflows:work` | Runs tests during development |

## Quality Checklist

Before finalizing tests:

- [ ] All happy paths covered
- [ ] Edge cases identified and tested
- [ ] Error cases have explicit assertions
- [ ] Tests are independent (no shared state)
- [ ] Tests are deterministic (no flaky tests)
- [ ] Mocks/stubs used appropriately
- [ ] Test names are descriptive
- [ ] Coverage meets project requirements
