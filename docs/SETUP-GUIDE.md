# Insyd Engineering Plugin - Setup Guide

This guide explains how to integrate the Insyd Engineering Plugin into your projects using Claude Code.

## Table of Contents

- [Overview](#overview)
- [Prerequisites](#prerequisites)
- [Quick Setup](#quick-setup)
- [Detailed Setup](#detailed-setup)
- [Verifying Installation](#verifying-installation)
- [Available Features](#available-features)
- [Usage Examples](#usage-examples)
- [Troubleshooting](#troubleshooting)
- [For Maintainers](#for-maintainers)

---

## Overview

The Insyd Engineering Plugin provides AI-powered engineering tools for JavaScript/TypeScript development:

- **22 Specialized Agents** - Code review, research, and workflow automation
- **20 Slash Commands** - `/workflows:plan`, `/workflows:review`, `/self-check`, etc.
- **11 Skills** - Domain expertise for spec writing, testing, architecture

**Target Stack:** Convex, Next.js, Astro, React, Vite, TypeScript/JavaScript

---

## Prerequisites

1. **Claude Code CLI** installed and authenticated
   ```bash
   # Verify installation
   claude --version
   ```

2. **Git** installed (for cloning marketplace)

3. **A project repository** where you want to use the plugin

---

## Quick Setup

Run these commands in your project root:

```bash
# 1. Create .claude directory
mkdir -p .claude

# 2. Create settings.json with marketplace configuration
cat > .claude/settings.json << 'EOF'
{
  "extraKnownMarketplaces": {
    "insyd-plugins": {
      "source": {
        "source": "git",
        "url": "https://github.com/insyd-ai/compound-engineering-plugin.git"
      }
    }
  },
  "enabledPlugins": {
    "insyd-engineering@insyd-plugins": true
  }
}
EOF

# 3. Start Claude Code
claude
```

That's it! The plugin is now available.

---

## Detailed Setup

### Step 1: Create Configuration Directory

In your project root, create a `.claude` directory:

```bash
mkdir -p .claude
```

### Step 2: Create settings.json

Create `.claude/settings.json` with the following content:

```json
{
  "extraKnownMarketplaces": {
    "insyd-plugins": {
      "source": {
        "source": "git",
        "url": "https://github.com/insyd-ai/compound-engineering-plugin.git"
      }
    }
  },
  "enabledPlugins": {
    "insyd-engineering@insyd-plugins": true
  }
}
```

### Step 3: Commit to Version Control

Add the settings file to git so all team members get the configuration:

```bash
git add .claude/settings.json
git commit -m "Add Insyd Engineering plugin configuration"
git push
```

### Step 4: Start Claude Code

```bash
claude
```

**First-time setup:** Claude Code will prompt you to approve the plugin:

```
Plugin "insyd-engineering" from marketplace "insyd-plugins" wants to be enabled.
[Allow] [Deny] [Always allow from this marketplace]
```

Select **Allow** or **Always allow from this marketplace**.

---

## Verifying Installation

After starting Claude Code, verify the plugin is loaded:

### Check Available Commands

Type `/` and you should see the plugin commands:

```
/workflows:plan
/workflows:review
/workflows:work
/workflows:compound
/self-check
/spec-write
/test-write
...
```

### Test a Command

```
> /workflows:plan
```

Claude should respond with a planning workflow prompt.

---

## Available Features

### Slash Commands

| Command | Description |
|---------|-------------|
| `/workflows:plan` | Create detailed implementation plans |
| `/workflows:review` | Run comprehensive code review |
| `/workflows:work` | Execute work items systematically |
| `/workflows:compound` | Document solved problems |
| `/self-check` | Security, performance, architecture checks |
| `/spec-write` | Write PRD/TDD specifications |
| `/test-write` | Generate unit/integration tests |
| `/test-functional` | Write functional test cases |
| `/reproduce-bug` | Validate bug reproduction steps |
| `/playwright-test` | Run Playwright E2E tests |
| `/triage` | Triage and prioritize issues |
| `/create-agent-skill` | Create new agent skills |
| `/heal-skill` | Fix broken skills |
| `/deepen-plan` | Expand implementation plans |
| `/plan-review` | Review existing plans |
| `/resolve-parallel` | Resolve issues in parallel |
| `/resolve-pr-parallel` | Resolve PR comments in parallel |
| `/resolve-todo-parallel` | Resolve TODOs in parallel |
| `/agent-native-audit` | Audit for agent-native patterns |
| `/generate-command` | Generate new commands |

### Specialized Agents

**Code Review Agents (12):**
- `agent-native-reviewer` - Reviews for agent-native patterns
- `architecture-strategist` - Architecture decisions
- `code-simplicity-reviewer` - Code simplicity analysis
- `code-simplifier` - Suggests simplifications
- `data-integrity-guardian` - Data integrity checks
- `data-migration-expert` - Migration safety
- `deployment-verification-agent` - Deployment readiness
- `julik-frontend-races-reviewer` - Frontend race conditions
- `kieran-typescript-reviewer` - TypeScript best practices
- `pattern-recognition-specialist` - Pattern analysis
- `performance-oracle` - Performance optimization
- `security-sentinel` - Security vulnerabilities

**Research Agents (4):**
- `best-practices-researcher` - Industry best practices
- `framework-docs-researcher` - Framework documentation
- `git-history-analyzer` - Git history analysis
- `repo-research-analyst` - Repository analysis

**Workflow Agents (6):**
- `bug-reproduction-validator` - Bug reproduction
- `functional-test-writer` - Functional tests
- `pr-comment-resolver` - PR comment resolution
- `prd-writer` - PRD documentation
- `spec-flow-analyzer` - Specification analysis
- `tdd-writer` - TDD documentation

### Skills

| Skill | Purpose |
|-------|---------|
| `agent-native-architecture` | Design patterns for AI agents |
| `compound-docs` | Documentation standards |
| `create-agent-skills` | Creating new skills |
| `file-todos` | TODO management |
| `frontend-design` | Frontend design patterns |
| `git-worktree` | Git worktree workflows |
| `rclone` | Cloud storage operations |
| `self-check` | Self-review procedures |
| `skill-creator` | Skill creation utilities |
| `spec-writing` | PRD/TDD specifications |
| `test-writing` | Test creation patterns |

---

## Usage Examples

### Example 1: Planning a New Feature

```
Developer: I need to add user authentication with OAuth

Claude: I'll create a detailed implementation plan.
        [Uses /workflows:plan]

        ## Implementation Plan

        ### Phase 1: Setup
        - Install dependencies (next-auth, etc.)
        - Configure OAuth providers

        ### Phase 2: Implementation
        - Create auth API routes
        - Add session management
        - Create login/logout UI

        ### Phase 3: Testing
        - Unit tests for auth logic
        - Integration tests for OAuth flow

        Shall I proceed with implementation?
```

### Example 2: Code Review Before PR

```
Developer: Review my changes before I create a PR

Claude: [Uses /workflows:review]

        Running comprehensive review with specialized agents...

        ## Security Review (security-sentinel)
        ✅ No SQL injection vulnerabilities
        ✅ Input validation present
        ⚠️ Consider rate limiting on /api/auth endpoint

        ## TypeScript Review (kieran-typescript-reviewer)
        ✅ Types properly defined
        ⚠️ Line 45: Consider using discriminated union

        ## Performance Review (performance-oracle)
        ✅ No N+1 queries detected
        ✅ Proper memoization used

        Overall: Ready for PR with minor suggestions above.
```

### Example 3: Writing Tests

```
Developer: Write tests for the UserService class

Claude: [Uses test-writing skill]

        I'll create comprehensive tests for UserService.

        [Creates unit tests with proper mocking]
        [Creates integration tests with test database]
        [Adds edge case coverage]

        Created:
        - tests/unit/UserService.test.ts
        - tests/integration/UserService.integration.test.ts
```

### Example 4: Self-Check Before Deployment

```
Developer: /self-check

Claude: Running self-checks...

        ## Security Check
        ✅ No hardcoded secrets
        ✅ Dependencies up to date
        ⚠️ 2 moderate vulnerabilities in dev dependencies

        ## Performance Check
        ✅ Bundle size within limits
        ✅ No memory leaks detected

        ## Architecture Check
        ✅ Follows established patterns
        ✅ No circular dependencies

        Ready for deployment with noted advisories.
```

---

## Troubleshooting

### Plugin Not Loading

**Symptom:** Commands like `/workflows:plan` not available

**Solutions:**

1. Check settings.json syntax:
   ```bash
   cat .claude/settings.json | python -m json.tool
   ```

2. Verify file location is `.claude/settings.json` (not `.claude-plugin/`)

3. Restart Claude Code:
   ```bash
   # Exit current session
   exit
   # Start fresh
   claude
   ```

### Permission Denied

**Symptom:** "Plugin not approved" error

**Solution:** When prompted, select "Allow" or "Always allow from this marketplace"

### Marketplace Not Found

**Symptom:** "Cannot fetch marketplace" error

**Solutions:**

1. Check internet connection

2. Verify the marketplace URL is correct:
   ```
   https://github.com/insyd-ai/compound-engineering-plugin.git
   ```

3. If using a private repo, ensure Git credentials are configured

### Outdated Plugin

**Symptom:** Missing new commands or features

**Solution:** Claude Code caches plugins. To force refresh:
```bash
# Clear plugin cache (location may vary by OS)
rm -rf ~/.claude/plugins/insyd-plugins

# Restart Claude Code
claude
```

---

## For Maintainers

### Updating the Plugin for Your Team

When you update the marketplace repository:

```bash
# In compound-engineering-plugin repo
git add .
git commit -m "Add new feature"
git push
```

Team members get updates automatically on their next Claude Code session.

### Pinning to a Specific Version

For stability, pin to a specific tag:

```json
{
  "extraKnownMarketplaces": {
    "insyd-plugins": {
      "source": {
        "source": "git",
        "url": "https://github.com/insyd-ai/compound-engineering-plugin.git",
        "ref": "v2.1.0"
      }
    }
  },
  "enabledPlugins": {
    "insyd-engineering@insyd-plugins": true
  }
}
```

### Adding Multiple Plugins

Enable additional plugins from the marketplace:

```json
{
  "extraKnownMarketplaces": {
    "insyd-plugins": {
      "source": {
        "source": "git",
        "url": "https://github.com/insyd-ai/compound-engineering-plugin.git"
      }
    }
  },
  "enabledPlugins": {
    "insyd-engineering@insyd-plugins": true,
    "claude-mem@insyd-plugins": true,
    "plannotator@insyd-plugins": true
  }
}
```

### Creating Team-Wide Defaults

For organizations, consider creating a shared configuration repository:

```
your-org/claude-config/
└── .claude/
    └── settings.json   ← Shared team configuration
```

Projects can then copy or reference this configuration.

---

## Support

- **Issues:** [GitHub Issues](https://github.com/insyd-ai/compound-engineering-plugin/issues)
- **Plugin Documentation:** See `plugins/insyd-engineering/README.md` in the marketplace repo

---

## Quick Reference Card

```
┌─────────────────────────────────────────────────────────────┐
│  INSYD ENGINEERING PLUGIN - QUICK REFERENCE                 │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  SETUP (one-time per project):                              │
│  mkdir -p .claude                                           │
│  # Create .claude/settings.json with marketplace config     │
│  claude                                                     │
│                                                             │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  COMMON COMMANDS:                                           │
│  /workflows:plan     - Plan implementation                  │
│  /workflows:review   - Review code                          │
│  /self-check         - Run all checks                       │
│  /spec-write         - Write specifications                 │
│  /test-write         - Generate tests                       │
│                                                             │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  WORKFLOW:                                                  │
│  1. /workflows:plan  → Create plan                          │
│  2. Implement        → Write code                           │
│  3. /test-write      → Add tests                            │
│  4. /workflows:review→ Review before PR                     │
│  5. /self-check      → Final verification                   │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```
