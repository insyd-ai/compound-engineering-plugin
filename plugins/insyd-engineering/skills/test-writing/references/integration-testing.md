# Integration Testing Patterns

## Purpose

Integration tests verify that multiple components, modules, or services work correctly together.

## When to Write Integration Tests

- API endpoint handlers
- Database operations
- Service-to-service communication
- Complex workflows involving multiple modules
- Convex functions (queries, mutations, actions)

## Test Levels

| Level | What it Tests | Example |
|-------|---------------|---------|
| Component Integration | Multiple components together | Form with validation |
| API Integration | HTTP handlers with services | Route handlers |
| Database Integration | Data access with real DB | Repository methods |
| Service Integration | Multiple services together | Auth + User service |

## API Integration Testing

### Testing Express/Next.js API Routes

```typescript
import { describe, it, expect, beforeAll, afterAll } from 'vitest';
import request from 'supertest';
import { app } from '../app';

describe('POST /api/users', () => {
  beforeAll(async () => {
    // Setup: seed database
    await db.seed();
  });

  afterAll(async () => {
    // Cleanup
    await db.cleanup();
  });

  it('creates user with valid data', async () => {
    const response = await request(app)
      .post('/api/users')
      .send({
        email: 'test@example.com',
        password: 'securepass123',
      })
      .expect(201);

    expect(response.body).toMatchObject({
      id: expect.any(String),
      email: 'test@example.com',
    });
    expect(response.body).not.toHaveProperty('password');
  });

  it('returns 400 for invalid email', async () => {
    const response = await request(app)
      .post('/api/users')
      .send({
        email: 'invalid',
        password: 'securepass123',
      })
      .expect(400);

    expect(response.body.error).toBe('INVALID_EMAIL');
  });

  it('returns 409 for duplicate email', async () => {
    // Arrange: create user first
    await request(app)
      .post('/api/users')
      .send({ email: 'dupe@example.com', password: 'pass123' });

    // Act & Assert
    const response = await request(app)
      .post('/api/users')
      .send({ email: 'dupe@example.com', password: 'pass456' })
      .expect(409);

    expect(response.body.error).toBe('EMAIL_EXISTS');
  });
});
```

## Convex Integration Testing

```typescript
import { describe, it, expect, beforeEach } from 'vitest';
import { convexTest } from 'convex-test';
import schema from '../convex/schema';
import { api } from '../convex/_generated/api';

describe('tasks', () => {
  const t = convexTest(schema);

  beforeEach(async () => {
    await t.run(async (ctx) => {
      // Reset database state
    });
  });

  it('creates a task', async () => {
    const taskId = await t.mutation(api.tasks.create, {
      title: 'Test task',
      description: 'Test description',
    });

    const task = await t.query(api.tasks.get, { id: taskId });

    expect(task).toMatchObject({
      title: 'Test task',
      description: 'Test description',
      completed: false,
    });
  });

  it('lists tasks for user', async () => {
    // Arrange
    const userId = await t.run(async (ctx) => {
      return await ctx.db.insert('users', { email: 'test@example.com' });
    });

    await t.mutation(api.tasks.create, { title: 'Task 1', userId });
    await t.mutation(api.tasks.create, { title: 'Task 2', userId });

    // Act
    const tasks = await t.query(api.tasks.list, { userId });

    // Assert
    expect(tasks).toHaveLength(2);
  });
});
```

## Database Integration Testing

```typescript
import { describe, it, expect, beforeAll, afterAll, beforeEach } from 'vitest';
import { db, migrateDb, cleanupDb } from '../db';
import { UserRepository } from '../repositories/user';

describe('UserRepository', () => {
  let repo: UserRepository;

  beforeAll(async () => {
    await migrateDb();
    repo = new UserRepository(db);
  });

  beforeEach(async () => {
    await db.delete('users').execute();
  });

  afterAll(async () => {
    await cleanupDb();
  });

  it('creates and retrieves user', async () => {
    const created = await repo.create({
      email: 'test@example.com',
      name: 'Test User',
    });

    const retrieved = await repo.findById(created.id);

    expect(retrieved).toEqual(created);
  });

  it('finds user by email', async () => {
    await repo.create({ email: 'find@example.com', name: 'Find Me' });

    const found = await repo.findByEmail('find@example.com');

    expect(found?.name).toBe('Find Me');
  });

  it('returns null for non-existent user', async () => {
    const found = await repo.findById('non-existent-id');
    expect(found).toBeNull();
  });
});
```

## Testing with Authentication

```typescript
describe('Protected Routes', () => {
  let authToken: string;

  beforeAll(async () => {
    // Create user and get token
    const user = await createTestUser();
    authToken = await generateToken(user);
  });

  it('returns 401 without auth token', async () => {
    await request(app)
      .get('/api/protected')
      .expect(401);
  });

  it('returns 403 for unauthorized user', async () => {
    const limitedToken = await generateToken(regularUser);

    await request(app)
      .get('/api/admin/users')
      .set('Authorization', `Bearer ${limitedToken}`)
      .expect(403);
  });

  it('allows access with valid token', async () => {
    await request(app)
      .get('/api/protected')
      .set('Authorization', `Bearer ${authToken}`)
      .expect(200);
  });
});
```

## Test Data Management

### Factory Pattern

```typescript
// factories/user.ts
export function createUserData(overrides = {}) {
  return {
    email: `test-${Date.now()}@example.com`,
    name: 'Test User',
    password: 'password123',
    ...overrides,
  };
}

// In tests
const userData = createUserData({ name: 'Custom Name' });
```

### Database Seeding

```typescript
// tests/seed.ts
export async function seedDatabase() {
  await db.insert('users').values([
    { id: 'user-1', email: 'user1@test.com', name: 'User 1' },
    { id: 'user-2', email: 'user2@test.com', name: 'User 2' },
  ]);
}

export async function cleanDatabase() {
  await db.delete('users').execute();
}
```

## Best Practices

1. **Isolate tests** - each test gets a clean state
2. **Use transactions** - rollback after each test for speed
3. **Test real scenarios** - don't over-mock
4. **Parallel execution** - design for concurrent running
5. **Clear setup/teardown** - explicit before/after hooks
6. **Meaningful assertions** - verify actual integration behavior

## Anti-Patterns to Avoid

- Sharing state between tests
- Hardcoding test data IDs
- Testing with production databases
- Skipping cleanup (leaving test data)
- Over-mocking (defeats purpose of integration tests)
