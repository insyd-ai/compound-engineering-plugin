# Unit Testing Patterns

## Purpose

Unit tests verify that individual functions, methods, or components work correctly in isolation.

## When to Write Unit Tests

- New functions or methods
- Complex business logic
- Utility functions
- React/Vue components
- Data transformations
- Validation logic

## Framework Setup

### Vitest (Recommended for Vite/React)

```typescript
// vitest.config.ts
import { defineConfig } from 'vitest/config';

export default defineConfig({
  test: {
    globals: true,
    environment: 'jsdom', // for React
    setupFiles: ['./tests/setup.ts'],
    coverage: {
      provider: 'v8',
      reporter: ['text', 'html'],
    },
  },
});
```

### Jest

```javascript
// jest.config.js
module.exports = {
  testEnvironment: 'jsdom',
  setupFilesAfterEnv: ['<rootDir>/tests/setup.ts'],
  moduleNameMapper: {
    '^@/(.*)$': '<rootDir>/src/$1',
  },
};
```

## Test Structure (AAA Pattern)

```typescript
import { describe, it, expect, beforeEach } from 'vitest';

describe('calculateTotal', () => {
  // Arrange (setup common to all tests)
  const baseItems = [
    { price: 10, quantity: 2 },
    { price: 5, quantity: 1 },
  ];

  it('calculates total for multiple items', () => {
    // Arrange
    const items = [...baseItems];

    // Act
    const result = calculateTotal(items);

    // Assert
    expect(result).toBe(25);
  });

  it('returns 0 for empty cart', () => {
    // Act
    const result = calculateTotal([]);

    // Assert
    expect(result).toBe(0);
  });
});
```

## Mocking Patterns

### Mocking Functions

```typescript
import { vi } from 'vitest';

// Mock a module
vi.mock('./api', () => ({
  fetchUser: vi.fn().mockResolvedValue({ id: 1, name: 'Test' }),
}));

// Mock a specific function
const mockFn = vi.fn().mockReturnValue('mocked');

// Verify mock calls
expect(mockFn).toHaveBeenCalled();
expect(mockFn).toHaveBeenCalledWith('arg1', 'arg2');
expect(mockFn).toHaveBeenCalledTimes(2);
```

### Mocking External Services

```typescript
import { vi } from 'vitest';

// Mock fetch
global.fetch = vi.fn().mockResolvedValue({
  ok: true,
  json: () => Promise.resolve({ data: 'test' }),
});

// Mock localStorage
const localStorageMock = {
  getItem: vi.fn(),
  setItem: vi.fn(),
  clear: vi.fn(),
};
global.localStorage = localStorageMock;
```

## React Component Testing

```typescript
import { render, screen, fireEvent } from '@testing-library/react';
import { Button } from './Button';

describe('Button', () => {
  it('renders with correct text', () => {
    render(<Button>Click me</Button>);
    expect(screen.getByText('Click me')).toBeInTheDocument();
  });

  it('calls onClick when clicked', () => {
    const handleClick = vi.fn();
    render(<Button onClick={handleClick}>Click</Button>);

    fireEvent.click(screen.getByText('Click'));

    expect(handleClick).toHaveBeenCalledTimes(1);
  });

  it('is disabled when loading', () => {
    render(<Button loading>Click</Button>);
    expect(screen.getByRole('button')).toBeDisabled();
  });
});
```

## Testing Async Code

```typescript
import { describe, it, expect } from 'vitest';

describe('fetchData', () => {
  it('fetches data successfully', async () => {
    const result = await fetchData('123');
    expect(result).toEqual({ id: '123', data: 'test' });
  });

  it('throws on network error', async () => {
    await expect(fetchData('invalid')).rejects.toThrow('Network error');
  });
});
```

## Testing Error Cases

```typescript
describe('validateEmail', () => {
  it('throws error for invalid email', () => {
    expect(() => validateEmail('invalid')).toThrow('Invalid email format');
  });

  it('throws specific error type', () => {
    expect(() => validateEmail('')).toThrow(ValidationError);
  });
});
```

## Coverage Thresholds

```typescript
// vitest.config.ts
export default defineConfig({
  test: {
    coverage: {
      thresholds: {
        statements: 80,
        branches: 80,
        functions: 80,
        lines: 80,
      },
    },
  },
});
```

## Best Practices

1. **One assertion per test** (when practical)
2. **Descriptive test names** that explain the scenario
3. **Independent tests** that don't rely on order
4. **Fast execution** - mock slow dependencies
5. **Test behavior, not implementation**
6. **Use factories** for test data

## Anti-Patterns to Avoid

- Testing implementation details
- Brittle tests tied to CSS selectors
- Shared mutable state between tests
- Testing framework code
- Over-mocking (test nothing real)
