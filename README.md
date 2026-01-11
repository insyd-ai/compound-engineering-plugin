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
| Agents | 18 |
| Commands | 16 |
| Skills | 8 |
| MCP Servers | 2 |

## Learn More

- [Full component reference](plugins/compound-engineering/README.md)
- [Changelog](plugins/compound-engineering/CHANGELOG.md)

## Credits

Forked from [compound-engineering-plugin](https://github.com/EveryInc/every-marketplace) originally created by Kieran Klaassen at Every Inc.
