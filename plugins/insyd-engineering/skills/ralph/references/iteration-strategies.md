# Iteration Strategies

## Strategy Selection

| Scenario | Recommended Strategy |
|----------|---------------------|
| New feature implementation | Test-by-Test |
| Complex refactoring | Layer-by-Layer |
| Bug fixes | Minimal Fix First |
| Performance optimization | Benchmark-Driven |

## Test-by-Test Strategy

### Process

1. List all failing tests
2. Sort by complexity (simplest first)
3. For each test:
   - Read test code
   - Understand expectation
   - Write minimal code to pass
   - Run test
   - Move to next

### Example

```
Failing tests:
1. test_create_user (simple)
2. test_update_user (medium)
3. test_delete_user (medium)
4. test_user_permissions (complex)

Order of attack: 1 → 2 → 3 → 4
```

### When It Works Best

- Tests are relatively independent
- Each test covers one feature
- Clear requirements per test

## Layer-by-Layer Strategy

### Process

1. Identify layers (DB → Service → API → UI)
2. Start from bottom layer
3. Complete each layer before moving up
4. Run tests at each layer completion

### Example

```
Layer progression:
1. Database models (src/db/models/)
2. Repository layer (src/db/repositories/)
3. Service layer (src/services/)
4. API routes (src/api/)
5. Frontend (src/components/)

At each layer:
- Write code
- Run layer-specific tests
- Ensure all pass before proceeding
```

### When It Works Best

- Deep dependency chains
- Strict layered architecture
- Integration-heavy features

## Minimal Fix Strategy (for bugs)

### Process

1. Identify exact failure point
2. Write smallest possible fix
3. Test fix works
4. Check for regressions
5. Refactor if needed

### Example

```
Bug: User login fails for emails with '+'

Minimal fix:
- Before: email.split('@')[0]
- After: email // don't split, use full email

Test:
- test_login_plus_email passes
- All other login tests still pass
```

### When It Works Best

- Bug fixes
- Production hotfixes
- Time-critical issues

## Benchmark-Driven Strategy (performance)

### Process

1. Establish baseline metrics
2. Profile to find bottleneck
3. Fix bottleneck
4. Re-measure
5. Repeat until target met

### Example

```
Target: API response < 100ms

Iteration 1:
- Current: 450ms
- Bottleneck: N+1 query
- Fix: Add eager loading
- Result: 180ms

Iteration 2:
- Current: 180ms
- Bottleneck: JSON serialization
- Fix: Use streaming response
- Result: 85ms ✓
```

### When It Works Best

- Performance optimization
- Scalability issues
- Resource constraints

## Hybrid Approaches

### Feature Slice + Test-by-Test

Combine vertical slicing with test-focused iteration:

```
Feature: User Authentication

Slice 1: Login
- test_login_success → implement
- test_login_failure → implement
- test_login_rate_limit → implement

Slice 2: Logout
- test_logout_success → implement
- test_logout_all_devices → implement

Slice 3: Session
- test_session_create → implement
- test_session_extend → implement
- test_session_expire → implement
```

### Layer + Minimal Fix

For bug fixes in layered systems:

```
1. Identify which layer has the bug
2. Apply minimal fix at that layer
3. Run tests for that layer
4. Run integration tests
5. Run E2E tests
```

## Choosing the Right Strategy

### Decision Tree

```
Is this a bug fix?
├── YES → Minimal Fix Strategy
└── NO
    │
    Is the feature deeply layered?
    ├── YES → Layer-by-Layer
    └── NO
        │
        Is performance the concern?
        ├── YES → Benchmark-Driven
        └── NO → Test-by-Test (default)
```

## Common Pitfalls

### Over-complexity

**Problem:** Trying to implement everything at once
**Solution:** Focus on one test/layer at a time

### Test Modification

**Problem:** Changing tests to pass
**Solution:** If test seems wrong, verify with spec first

### Skipping Validation

**Problem:** Not running tests after each change
**Solution:** Run tests after EVERY meaningful change

### Premature Optimization

**Problem:** Optimizing before tests pass
**Solution:** Make it work, then make it fast
