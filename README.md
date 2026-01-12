# Insyd Engineering Plugin

A Claude Code plugin marketplace for JavaScript/TypeScript development workflows.

> Forked from [compound-engineering-plugin](https://github.com/EveryInc/every-marketplace) by Every Inc.

## Quick Start

### 1. Add to Your Project

Create `.claude/settings.json` in your project root:

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

### 2. Start Claude Code

```bash
claude
```

### 3. Use the Commands

```
/workflows:plan     # Plan implementation
/workflows:review   # Review code
/self-check         # Run all checks
```

That's it! See the [Setup Guide](docs/SETUP-GUIDE.md) for detailed instructions.

---

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

## Components

| Type | Count |
|------|-------|
| Agents | 22 |
| Commands | 20 |
| Skills | 11 |
| MCP Servers | 6 |

## Use Cases

1. **Spec Writing** - PRD and TDD specifications
2. **Functional Tests** - Define success criteria
3. **Code Writing** - Frontend and backend development
4. **Test Execution** - Unit, integration, and E2E tests
5. **Code Refactoring** - Simplify and improve code
6. **Codebase Understanding** - Analyze large codebases
7. **Self Checks** - Security, performance, architecture
8. **PR Reviews** - Comprehensive code review

## Documentation

- [Setup Guide](docs/SETUP-GUIDE.md) - Complete setup and usage instructions
- [Plugin Reference](plugins/insyd-engineering/README.md) - Full component reference
- [Changelog](plugins/insyd-engineering/CHANGELOG.md) - Version history
- [MCP Setup](plugins/insyd-engineering/docs/MCP-SETUP.md) - MCP server configuration

## Repository Structure

```
compound-engineering-plugin/
├── .claude-plugin/
│   └── marketplace.json          # Marketplace catalog
├── plugins/
│   ├── insyd-engineering/        # Main plugin
│   │   ├── .claude-plugin/
│   │   │   └── plugin.json
│   │   ├── agents/               # 22 specialized agents
│   │   ├── commands/             # 20 slash commands
│   │   ├── skills/               # 11 skills
│   │   └── docs/
│   ├── claude-mem/               # Memory plugin (external)
│   └── plannotator/              # Plan annotation (external)
└── docs/
    └── SETUP-GUIDE.md            # This setup guide
```

## Optional: Additional Plugins

Enable more plugins from this marketplace:

```json
{
  "enabledPlugins": {
    "insyd-engineering@insyd-plugins": true,
    "claude-mem@insyd-plugins": true,
    "plannotator@insyd-plugins": true
  }
}
```

## Version Pinning

For stability, pin to a specific version:

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
  }
}
```

## Credits

Forked from [compound-engineering-plugin](https://github.com/EveryInc/every-marketplace) originally created by Kieran Klaassen at Every Inc.
