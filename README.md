# Insyd Engineering Plugin

A Claude Code plugin for JavaScript/TypeScript development workflows.

> Forked from [compound-engineering-plugin](https://github.com/EveryInc/every-marketplace) by Every Inc.

## Install

```bash
claude plugin add insyd-ai/compound-engineering-plugin
```

## Workflow

```
Plan → Work → Review → Compound → Repeat
```

| Command | Purpose |
|---------|---------|
| `/workflows:plan` | Turn feature ideas into detailed implementation plans |
| `/workflows:work` | Execute plans with worktrees and task tracking |
| `/workflows:review` | Multi-agent code review before merging |
| `/workflows:compound` | Document learnings to make future work easier |

## Target Stack

- **Backend**: Convex
- **Frontend**: Next.js, Astro, React, Vite
- **Languages**: TypeScript, JavaScript

## Use Cases

1. Spec writing
2. Functional testcases (success criteria)
3. Code writing (frontend, backend)
4. Test writing and execution
5. Code refactoring
6. Understanding large codebases
7. Self checks
8. PR reviews

## Components

| Type | Count |
|------|-------|
| Agents | 22 |
| Commands | 20 |
| Skills | 11 |
| MCP Servers | 7 |

## Learn More

- [Full component reference](plugins/compound-engineering/README.md)
- [Changelog](plugins/compound-engineering/CHANGELOG.md)
- [MCP Setup Guide](plugins/compound-engineering/docs/MCP-SETUP.md)

## Using as a Git Submodule

### Add to Your Project

```bash
# Add as submodule in your project
git submodule add https://github.com/insyd-ai/compound-engineering-plugin.git .claude/plugins/insyd

# Initialize and update
git submodule update --init --recursive
```

### Configure Claude Code

Create/update `.claude/settings.json` in your project:

```json
{
  "plugins": {
    "marketplaces": ["./.claude/plugins/insyd"]
  }
}
```

### Install the Plugin

```bash
claude plugin install insyd-engineering
```

### Install External Plugins (Optional)

For claude-mem memory features:

```bash
/plugin marketplace add thedotmack/claude-mem
/plugin install claude-mem
```

### Environment Variables

Set these for full MCP functionality:

```bash
# Required for GitHub MCP
export GITHUB_PAT="your_github_pat"

# Linear and Figma use OAuth - authenticate via /mcp command
```

## Credits

Forked from [compound-engineering-plugin](https://github.com/EveryInc/every-marketplace) originally created by Kieran Klaassen at Every Inc.
