# Debugging Guide

## Reading Test Failures

### Bun Test Output

```bash
bun test tests/unit/auth.test.ts

# Output:
✗ should login with valid credentials (5ms)
  Error: Expected "authenticated" but received "unauthorized"

  at tests/unit/auth.test.ts:42:17
```

**Key information:**
- Test name: `should login with valid credentials`
- Expected: `"authenticated"`
- Actual: `"unauthorized"`
- Location: `tests/unit/auth.test.ts:42`

### Common Error Types

| Error | Meaning | Likely Cause |
|-------|---------|--------------|
| `undefined is not a function` | Calling missing function | Import error, typo |
| `Cannot read property of null` | Null reference | Missing null check |
| `Expected X but received Y` | Assertion failed | Logic error |
| `Timeout exceeded` | Async operation slow/stuck | Missing await, infinite loop |
| `TypeError` | Wrong type passed | Type mismatch |

## Debugging Workflow

### Step 1: Reproduce

```bash
# Run specific failing test
bun test tests/unit/auth.test.ts -t "should login"

# Run with verbose output
bun test --verbose tests/unit/auth.test.ts
```

### Step 2: Isolate

Ask these questions:
1. Does this test depend on other tests?
2. Does it work in isolation?
3. What's the minimum code that fails?

### Step 3: Investigate

```typescript
// Add console.log at key points
console.log('Input:', input);
console.log('Intermediate:', result);
console.log('Output:', output);
```

### Step 4: Fix

Apply minimal fix. Don't refactor while debugging.

### Step 5: Verify

```bash
# Run the specific test
bun test tests/unit/auth.test.ts -t "should login"

# Run all related tests
bun test tests/unit/auth.test.ts

# Run full suite
bun test
```

## Common Issues and Fixes

### Async/Await Issues

**Symptom:** Test passes sometimes, fails others
**Cause:** Missing await or race condition

```typescript
// Bad
const result = fetchUser(id);
expect(result.name).toBe('Alice');

// Good
const result = await fetchUser(id);
expect(result.name).toBe('Alice');
```

### Mock Issues

**Symptom:** Works in real code, fails in test
**Cause:** Mock doesn't match real behavior

```typescript
// Check mock setup
vi.mock('../db', () => ({
  getUser: vi.fn(() => ({ id: 1, name: 'Alice' }))
}));

// Verify mock is being used
expect(db.getUser).toHaveBeenCalledWith(1);
```

### Import Issues

**Symptom:** `undefined is not a function`
**Cause:** Wrong import path or missing export

```typescript
// Check exports
export const login = () => { ... };
export default { login };

// Check imports
import { login } from './auth'; // Named
import auth from './auth'; // Default
```

### Type Issues

**Symptom:** TypeScript error in test
**Cause:** Type mismatch between test and implementation

```typescript
// Implementation expects
interface User {
  id: number;
  name: string;
}

// Test provides
const mockUser = { id: 1, name: 'Alice' }; // OK
const badMock = { id: '1', name: 'Alice' }; // Wrong! id should be number
```

### Null/Undefined Issues

**Symptom:** `Cannot read property of null`
**Cause:** Missing null check

```typescript
// Bad
function getName(user) {
  return user.name;
}

// Good
function getName(user) {
  return user?.name ?? 'Unknown';
}
```

## Test-Specific Debugging

### Unit Tests

Focus on:
- Input/output correctness
- Edge cases
- Error handling

```typescript
describe('login', () => {
  it('returns user for valid credentials', async () => {
    // Test happy path
  });

  it('throws for invalid password', async () => {
    // Test error case
  });

  it('handles empty email', async () => {
    // Test edge case
  });
});
```

### Integration Tests

Focus on:
- Component interaction
- Database operations
- API contracts

```typescript
describe('auth integration', () => {
  beforeEach(async () => {
    await db.reset();
    await db.seed();
  });

  it('creates session in database', async () => {
    await login(user);
    const session = await db.sessions.find(user.id);
    expect(session).toBeDefined();
  });
});
```

### E2E Tests

Focus on:
- User flows
- UI interactions
- Real browser behavior

```typescript
test('user can login', async ({ page }) => {
  await page.goto('/login');
  await page.fill('[name=email]', 'user@example.com');
  await page.fill('[name=password]', 'password');
  await page.click('button[type=submit]');

  // Wait for navigation
  await page.waitForURL('/dashboard');

  // Verify login success
  await expect(page.locator('.user-name')).toHaveText('User');
});
```

## When Stuck

### Checklist

- [ ] Re-read the test - do I understand what it expects?
- [ ] Check the error message - what does it actually say?
- [ ] Verify imports - are all functions imported correctly?
- [ ] Check types - do types match between test and implementation?
- [ ] Add logging - what values are actually being passed?
- [ ] Run in isolation - does this test depend on others?

### Escalation

If stuck for 5+ iterations:

1. Document what you've tried
2. Include exact error message
3. List relevant file paths
4. Ask specific question
