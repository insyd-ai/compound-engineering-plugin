# TDD Bypass Policy

## Overview

While TDD enforcement is mandatory, there are legitimate cases where bypassing is necessary. This document outlines the policy for bypassing TDD enforcement.

## Bypass Methods

### 1. During Development (--skip-tdd flag)

Used with the `/commit` command:

```bash
/commit -m "message" --skip-self-check "reason"
```

### 2. Environment Variable

For automated pipelines:

```bash
SKIP_SELF_CHECK=true /commit -m "message"
```

**Note:** This still requires a reason in the commit message.

## Valid Bypass Reasons

### Tier 1: Always Acceptable

| Reason | Example |
|--------|---------|
| Emergency hotfix | "Production down, critical auth bug - emergency fix" |
| Reverting commit | "Reverting commit abc123 that broke builds" |
| Security patch | "CVE-2024-xxxx security patch, tests will follow" |

### Tier 2: Acceptable with Justification

| Reason | Example |
|--------|---------|
| WIP branch | "WIP branch, will add tests before PR review" |
| Prototype | "Prototype for stakeholder demo, not for merge" |
| Config only | "Configuration change only, no logic to test" |

### Tier 3: Acceptable for Specific Files

| File Type | Example Reason |
|-----------|----------------|
| Documentation | "README update only" |
| Config files | "ESLint config update" |
| Type definitions | "Types-only change, no runtime code" |

## Invalid Bypass Reasons

These reasons will be **flagged in PR review** and may block merge:

| Invalid Reason | Why It's Invalid |
|----------------|------------------|
| "no time" | Time management issue, not a valid exception |
| "testing later" | Violates TDD principle entirely |
| "tests are slow" | Optimize tests, don't skip them |
| "" (empty) | Must provide justification |
| "just trust me" | Not acceptable |
| Single word | Not enough context |

## Audit Trail

### What Gets Logged

When bypass is used:

1. **Commit Message**: Includes `[Self-check skipped: reason]`
2. **PR Review**: `tdd-timestamp-validator` flags the skip
3. **Metrics**: Tracked for team metrics (if configured)

### Example Commit Message with Bypass

```
Fix authentication timeout issue

[Self-check skipped: Emergency hotfix - production auth failing for 50% of users]

Co-Authored-By: Claude Opus 4.5 <noreply@anthropic.com>
```

## PR Review Handling

### What PR Reviewers See

The `tdd-timestamp-validator` agent will report:

```markdown
## TDD Workflow Validation Report

### Skip Detected

| Commit | Skip Reason | Valid? |
|--------|-------------|--------|
| abc123 | "Emergency hotfix - production auth failing" | ✅ Valid |
| def456 | "no time" | ❌ Invalid |

### Recommendation

- Commit abc123: Acceptable, emergency situation documented
- Commit def456: **Requires follow-up** - Tests must be added before merge
```

### Blocking vs Non-Blocking

| Skip Type | Blocks Merge? |
|-----------|---------------|
| Valid reason, Tier 1 | No |
| Valid reason, Tier 2 | No, with warning |
| Invalid reason | **Yes** |
| No reason provided | **Yes** |

## Best Practices

### For Developers

1. **Plan ahead**: Write tests early to avoid bypass needs
2. **Document clearly**: If bypassing, explain fully
3. **Follow up**: If you bypass for WIP, add tests before PR
4. **Ask for help**: If unsure, ask team lead

### For Reviewers

1. **Check skip reasons**: Validate they're legitimate
2. **Request tests**: For invalid skips, require tests before merge
3. **Track patterns**: Frequent bypasses may indicate process issues

## Emergency Procedures

### True Emergency (Production Down)

1. Create fix with bypass
2. Deploy immediately
3. Create follow-up ticket for tests
4. Add tests within 24 hours
5. Document in post-mortem

### Non-Emergency Skip

1. Consider if bypass is truly needed
2. If proceeding, provide detailed reason
3. Ensure tests are added in same PR
4. Request review approval
