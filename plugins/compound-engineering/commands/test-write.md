---
name: test:write
description: Write unit, integration, or functional tests for code or features
argument-hint: "[file path, feature name, or --unit|--integration|--e2e]"
---

# Test Writing Command

Write tests (unit, integration, or E2E) for specified code or features.

## Introduction

This command creates automated tests following project conventions and best practices for:
- Unit tests (individual function/component testing)
- Integration tests (module interaction testing)
- E2E tests (end-to-end user flow testing)

## Input

<test_input> #$ARGUMENTS </test_input>

If no input provided, ask for:
- What needs testing (file, function, feature, or component)
- Test type preference (unit, integration, E2E, or auto-detect)

## Execution Workflow

### Phase 1: Determine Test Type and Scope

<thinking>
Analyze the input to determine the appropriate test type and scope.
</thinking>

<detection_rules>

| Input | Test Type | Scope |
|-------|-----------|-------|
| `--unit` flag | Unit | Specified target |
| `--integration` flag | Integration | Specified target |
| `--e2e` flag | E2E | Specified target |
| Single function file | Unit | Function |
| React component | Unit | Component |
| API route file | Integration | Endpoint |
| Convex function | Integration | Query/Mutation |
| Feature name | E2E | Full flow |
| No flag, complex module | Integration | Module interactions |

</detection_rules>

<tasks>

1. **Identify Testing Framework**

   Check project configuration:
   ```bash
   # Check for Vitest
   ls vitest.config.* 2>/dev/null

   # Check for Jest
   ls jest.config.* 2>/dev/null

   # Check for Playwright
   ls playwright.config.* 2>/dev/null

   # Check package.json for test scripts
   cat package.json | grep -A5 '"scripts"'
   ```

2. **Read Target Code**

   - Read the file/function/component to be tested
   - Identify testable units
   - Map dependencies that need mocking

3. **Check for Existing Tests**

   - Look for existing test files
   - Understand test patterns used in project
   - Follow existing conventions

4. **Check for Functional Test Cases**

   ```bash
   ls docs/test-cases/
   ```

   If functional test cases exist, use them as test specifications.

</tasks>

### Phase 2: Generate Tests

<test_generation>

#### For Unit Tests

1. **Identify Test Cases**:
   - Happy path (valid inputs, expected outputs)
   - Edge cases (null, empty, boundaries)
   - Error cases (invalid inputs, exceptions)

2. **Create Test File**:
   - Location: `__tests__/[filename].test.ts` or `[filename].test.ts`
   - Import target and testing utilities
   - Use AAA pattern (Arrange, Act, Assert)

3. **Write Tests**:

   ```typescript
   import { describe, it, expect, vi } from 'vitest';
   import { functionToTest } from '../source';

   describe('functionToTest', () => {
     it('returns expected value for valid input', () => {
       // Arrange
       const input = 'valid';

       // Act
       const result = functionToTest(input);

       // Assert
       expect(result).toBe('expected');
     });

     it('throws error for invalid input', () => {
       expect(() => functionToTest(null)).toThrow('Invalid input');
     });
   });
   ```

#### For Integration Tests

1. **Identify Integration Points**:
   - API endpoints
   - Database operations
   - Service interactions
   - External API calls

2. **Create Test File**:
   - Location: `__tests__/integration/[feature].test.ts`
   - Set up test database/mocks
   - Include setup and teardown

3. **Write Tests**:

   ```typescript
   import { describe, it, expect, beforeAll, afterAll } from 'vitest';
   import request from 'supertest';
   import { app } from '../app';

   describe('POST /api/users', () => {
     beforeAll(async () => {
       await setupTestDb();
     });

     afterAll(async () => {
       await cleanupTestDb();
     });

     it('creates user with valid data', async () => {
       const response = await request(app)
         .post('/api/users')
         .send({ email: 'test@example.com', password: 'secure123' })
         .expect(201);

       expect(response.body).toMatchObject({
         id: expect.any(String),
         email: 'test@example.com',
       });
     });
   });
   ```

#### For E2E Tests

1. **Identify User Flows**:
   - Critical user journeys
   - Multi-step workflows
   - Cross-page interactions

2. **Create Test File**:
   - Location: `tests/e2e/[feature].spec.ts`
   - Use Page Object pattern for maintainability
   - Include visual checks if relevant

3. **Write Tests**:

   ```typescript
   import { test, expect } from '@playwright/test';

   test.describe('User Registration', () => {
     test('completes registration flow', async ({ page }) => {
       await page.goto('/register');

       await page.fill('[data-testid="email"]', 'new@example.com');
       await page.fill('[data-testid="password"]', 'SecurePass123!');
       await page.click('[data-testid="submit"]');

       await expect(page).toHaveURL('/dashboard');
       await expect(page.locator('[data-testid="welcome"]')).toBeVisible();
     });
   });
   ```

</test_generation>

### Phase 3: Execute and Validate

<execution>

1. **Run Tests**:

   ```bash
   # Run the new tests
   npm test -- path/to/test.test.ts

   # Run with coverage
   npm test -- --coverage path/to/test.test.ts
   ```

2. **Verify Tests Pass**:
   - All tests should pass
   - Fix any failing tests
   - Ensure no flaky tests

3. **Check Coverage**:
   - Review coverage report
   - Add tests for uncovered paths if needed

</execution>

### Phase 4: Report Results

<report>

Present test results:

```markdown
## Tests Written: [Target Name]

**Test Type**: Unit | Integration | E2E
**File Created**: [path/to/test.test.ts]
**Tests Added**: X

### Test Summary

| Test Name | Category | Status |
|-----------|----------|--------|
| [test name] | Happy Path | PASS |
| [test name] | Error Case | PASS |

### Coverage

| Metric | Coverage |
|--------|----------|
| Statements | X% |
| Branches | X% |
| Functions | X% |
| Lines | X% |

### Next Steps

1. Run full test suite: `npm test`
2. Add more edge cases if needed
3. Run `/self-check` before committing
```

</report>

## Test Patterns Reference

Use the test-writing skill for detailed patterns:

```
skill: test-writing
```

Reference files:
- Unit testing: `skills/test-writing/references/unit-testing.md`
- Integration testing: `skills/test-writing/references/integration-testing.md`
- E2E testing: `skills/test-writing/references/e2e-testing.md`

## Quality Checklist

Before completing:

- [ ] Tests follow project conventions
- [ ] All tests pass
- [ ] No flaky tests (run multiple times to verify)
- [ ] Mocks used appropriately (not over-mocking)
- [ ] Test names are descriptive
- [ ] AAA pattern followed
- [ ] Edge cases covered
- [ ] Error cases covered

## Key Principles

### Test Behavior, Not Implementation

**Bad**: Testing internal function calls
**Good**: Testing inputs produce expected outputs

### Keep Tests Independent

**Bad**: Tests depend on previous test state
**Good**: Each test sets up its own state

### Use Descriptive Names

**Bad**: `it('works')`
**Good**: `it('returns user profile when given valid user ID')`

### Don't Over-Mock

**Bad**: Mock everything, test nothing real
**Good**: Mock external dependencies, test real logic
