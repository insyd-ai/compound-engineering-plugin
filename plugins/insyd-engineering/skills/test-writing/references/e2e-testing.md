# E2E Testing Patterns

## Purpose

End-to-end tests verify that complete user workflows work correctly from the browser through the full system.

## When to Write E2E Tests

- Critical user journeys (signup, checkout, onboarding)
- Complex multi-step workflows
- Cross-page interactions
- Features involving browser APIs
- Visual regression testing

## Playwright Setup

```typescript
// playwright.config.ts
import { defineConfig, devices } from '@playwright/test';

export default defineConfig({
  testDir: './tests/e2e',
  fullyParallel: true,
  forbidOnly: !!process.env.CI,
  retries: process.env.CI ? 2 : 0,
  workers: process.env.CI ? 1 : undefined,
  reporter: 'html',
  use: {
    baseURL: 'http://localhost:3000',
    trace: 'on-first-retry',
    screenshot: 'only-on-failure',
  },
  projects: [
    { name: 'chromium', use: { ...devices['Desktop Chrome'] } },
    { name: 'firefox', use: { ...devices['Desktop Firefox'] } },
    { name: 'webkit', use: { ...devices['Desktop Safari'] } },
    { name: 'mobile', use: { ...devices['iPhone 13'] } },
  ],
  webServer: {
    command: 'npm run dev',
    url: 'http://localhost:3000',
    reuseExistingServer: !process.env.CI,
  },
});
```

## Basic Test Structure

```typescript
import { test, expect } from '@playwright/test';

test.describe('User Registration', () => {
  test.beforeEach(async ({ page }) => {
    await page.goto('/register');
  });

  test('registers new user successfully', async ({ page }) => {
    // Fill form
    await page.fill('[data-testid="email"]', 'newuser@example.com');
    await page.fill('[data-testid="password"]', 'SecurePass123!');
    await page.fill('[data-testid="confirm-password"]', 'SecurePass123!');

    // Submit
    await page.click('[data-testid="submit"]');

    // Verify redirect to dashboard
    await expect(page).toHaveURL('/dashboard');
    await expect(page.locator('[data-testid="welcome-message"]')).toContainText('Welcome');
  });

  test('shows validation error for weak password', async ({ page }) => {
    await page.fill('[data-testid="email"]', 'test@example.com');
    await page.fill('[data-testid="password"]', 'weak');
    await page.click('[data-testid="submit"]');

    await expect(page.locator('[data-testid="password-error"]')).toBeVisible();
    await expect(page.locator('[data-testid="password-error"]')).toContainText(
      'Password must be at least 8 characters'
    );
  });
});
```

## Page Object Pattern

```typescript
// pages/login.page.ts
import { Page, Locator } from '@playwright/test';

export class LoginPage {
  readonly page: Page;
  readonly emailInput: Locator;
  readonly passwordInput: Locator;
  readonly submitButton: Locator;
  readonly errorMessage: Locator;

  constructor(page: Page) {
    this.page = page;
    this.emailInput = page.locator('[data-testid="email"]');
    this.passwordInput = page.locator('[data-testid="password"]');
    this.submitButton = page.locator('[data-testid="submit"]');
    this.errorMessage = page.locator('[data-testid="error"]');
  }

  async goto() {
    await this.page.goto('/login');
  }

  async login(email: string, password: string) {
    await this.emailInput.fill(email);
    await this.passwordInput.fill(password);
    await this.submitButton.click();
  }
}

// In tests
test('login with valid credentials', async ({ page }) => {
  const loginPage = new LoginPage(page);
  await loginPage.goto();
  await loginPage.login('user@example.com', 'password123');
  await expect(page).toHaveURL('/dashboard');
});
```

## Testing Forms

```typescript
test('submits form with all fields', async ({ page }) => {
  await page.goto('/contact');

  // Text inputs
  await page.fill('[name="name"]', 'John Doe');
  await page.fill('[name="email"]', 'john@example.com');

  // Textarea
  await page.fill('[name="message"]', 'Hello, this is a test message.');

  // Select dropdown
  await page.selectOption('[name="category"]', 'support');

  // Checkbox
  await page.check('[name="subscribe"]');

  // Radio button
  await page.check('[name="priority"][value="high"]');

  // File upload
  await page.setInputFiles('[name="attachment"]', 'path/to/file.pdf');

  // Submit
  await page.click('[type="submit"]');

  // Verify success
  await expect(page.locator('.success-message')).toBeVisible();
});
```

## Testing Navigation

```typescript
test('navigates through multi-step wizard', async ({ page }) => {
  await page.goto('/wizard/step-1');

  // Step 1
  await page.fill('[name="name"]', 'Test User');
  await page.click('[data-testid="next"]');
  await expect(page).toHaveURL('/wizard/step-2');

  // Step 2
  await page.selectOption('[name="plan"]', 'premium');
  await page.click('[data-testid="next"]');
  await expect(page).toHaveURL('/wizard/step-3');

  // Step 3 - Submit
  await page.click('[data-testid="submit"]');
  await expect(page).toHaveURL('/wizard/complete');
  await expect(page.locator('h1')).toContainText('Success');
});
```

## Testing Authentication Flows

```typescript
test.describe('Authenticated User', () => {
  test.use({ storageState: 'tests/.auth/user.json' });

  test('accesses protected page', async ({ page }) => {
    await page.goto('/dashboard');
    await expect(page.locator('[data-testid="user-menu"]')).toBeVisible();
  });
});

// Setup: Create auth state
test.describe.configure({ mode: 'serial' });

test('setup: create auth state', async ({ page }) => {
  await page.goto('/login');
  await page.fill('[name="email"]', 'test@example.com');
  await page.fill('[name="password"]', 'password123');
  await page.click('[type="submit"]');
  await page.waitForURL('/dashboard');
  await page.context().storageState({ path: 'tests/.auth/user.json' });
});
```

## Visual Testing

```typescript
test('matches visual snapshot', async ({ page }) => {
  await page.goto('/landing');
  await expect(page).toHaveScreenshot('landing-page.png');
});

test('component matches snapshot', async ({ page }) => {
  await page.goto('/components');
  const card = page.locator('[data-testid="feature-card"]');
  await expect(card).toHaveScreenshot('feature-card.png');
});
```

## Testing API Mocking

```typescript
test('shows error when API fails', async ({ page }) => {
  // Mock API to return error
  await page.route('/api/users', async (route) => {
    await route.fulfill({
      status: 500,
      body: JSON.stringify({ error: 'Internal Server Error' }),
    });
  });

  await page.goto('/users');
  await expect(page.locator('[data-testid="error-message"]')).toBeVisible();
});
```

## Mobile Testing

```typescript
test.describe('Mobile Experience', () => {
  test.use({ viewport: { width: 375, height: 667 } });

  test('shows mobile menu', async ({ page }) => {
    await page.goto('/');
    await page.click('[data-testid="hamburger-menu"]');
    await expect(page.locator('[data-testid="mobile-nav"]')).toBeVisible();
  });
});
```

## Best Practices

1. **Use data-testid** - Stable selectors that survive refactoring
2. **Wait for elements** - Use expect().toBeVisible() instead of sleep
3. **Isolate tests** - Each test should work independently
4. **Test real workflows** - Mirror actual user behavior
5. **Keep tests focused** - One workflow per test
6. **Use page objects** - DRY and maintainable code
7. **Handle flakiness** - Add retries for CI, investigate root causes

## Anti-Patterns to Avoid

- Using arbitrary `page.waitForTimeout()`
- Brittle CSS selectors (`.btn-primary`)
- Testing implementation details
- Too many assertions in one test
- Skipping cleanup between tests
- Ignoring mobile viewport testing
