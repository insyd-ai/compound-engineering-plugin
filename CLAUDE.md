# Insyd Engineering Plugin - Claude Code Plugin

This repository is a Claude Code plugin that provides AI-powered engineering tools for JavaScript/TypeScript development workflows.

> Forked from [compound-engineering-plugin](https://github.com/EveryInc/every-marketplace) by Every Inc.

## Repository Structure

```
insyd-engineering-plugin/
├── .claude-plugin/
│   └── marketplace.json          # Marketplace catalog
└── plugins/
    ├── compound-engineering/     # The plugin
    │   ├── .claude-plugin/
    │   │   └── plugin.json       # Plugin metadata
    │   ├── agents/               # 22 specialized AI agents
    │   │   ├── review/           # Code review agents (12)
    │   │   ├── research/         # Research agents (4)
    │   │   └── workflow/         # Workflow agents (6)
    │   ├── commands/             # 20 slash commands
    │   ├── skills/               # 11 skills
    │   ├── docs/                 # Documentation
    │   │   └── MCP-SETUP.md      # MCP setup guide
    │   ├── README.md             # Plugin documentation
    │   └── CHANGELOG.md          # Version history
    ├── claude-mem/               # External plugin reference
    │   └── .claude-plugin/
    │       └── plugin.json       # Plugin metadata
    └── plannotator/              # External plugin reference
        └── .claude-plugin/
            └── plugin.json       # Plugin metadata
```

## Target Stack

This plugin is optimized for:
- **Backend**: Convex
- **Frontend**: Next.js, Astro, React, Vite
- **Languages**: TypeScript, JavaScript

## Use Cases

1. **Spec Writing** - Analyze specifications for completeness
2. **Functional Testcases** - Define success criteria
3. **Code Writing** - Frontend and backend development
4. **Test Execution** - Unit, integration, and functional tests
5. **Code Refactoring** - Simplify and improve code quality
6. **Codebase Understanding** - Index and analyze large codebases
7. **Self Checks** - Security, performance, architecture reviews
8. **PR Reviews** - Comprehensive code review

## Working with This Repository

### Adding a New Plugin

1. Create plugin directory: `plugins/new-plugin-name/`
2. Add plugin structure:
   ```
   plugins/new-plugin-name/
   ├── .claude-plugin/plugin.json
   ├── agents/
   ├── commands/
   └── README.md
   ```
3. Update `.claude-plugin/marketplace.json` to include the new plugin
4. Test locally before committing

### Updating the Compounding Engineering Plugin

When agents, commands, or skills are added/removed:

#### 1. Count all components

```bash
# Count agents (in subdirectories)
find plugins/compound-engineering/agents -name "*.md" | wc -l

# Count commands
ls plugins/compound-engineering/commands/*.md plugins/compound-engineering/commands/*/*.md 2>/dev/null | wc -l

# Count skills
ls -d plugins/compound-engineering/skills/*/ 2>/dev/null | wc -l
```

#### 2. Update description strings

Update counts in:
- [ ] `plugins/compound-engineering/.claude-plugin/plugin.json` → `description`
- [ ] `.claude-plugin/marketplace.json` → plugin `description`
- [ ] `plugins/compound-engineering/README.md` → components table

#### 3. Update version numbers

- [ ] `plugins/compound-engineering/.claude-plugin/plugin.json` → `version`
- [ ] `.claude-plugin/marketplace.json` → plugin `version`

#### 4. Update documentation

- [ ] `plugins/compound-engineering/README.md` → component lists
- [ ] `plugins/compound-engineering/CHANGELOG.md` → document changes

#### 5. Validate JSON

```bash
cat .claude-plugin/marketplace.json | jq .
cat plugins/compound-engineering/.claude-plugin/plugin.json | jq .
```

### Marketplace.json Structure

```json
{
  "name": "insyd-marketplace",
  "owner": {
    "name": "Insyd-AI",
    "url": "https://github.com/insyd-ai"
  },
  "metadata": {
    "description": "Insyd-AI plugin marketplace",
    "version": "1.0.0"
  },
  "plugins": [
    {
      "name": "insyd-engineering",
      "description": "...",
      "version": "1.0.0",
      "author": { ... },
      "homepage": "https://...",
      "tags": ["..."],
      "source": "./plugins/compound-engineering"
    }
  ]
}
```

## Testing Changes

### Test Locally

1. Install the marketplace:
   ```bash
   claude plugin marketplace add /path/to/this/repo
   ```

2. Install the plugin:
   ```bash
   claude plugin install insyd-engineering
   ```

3. Test commands:
   ```bash
   /workflows:plan
   /workflows:review
   ```

## Common Tasks

### Adding a New Agent

1. Create `plugins/compound-engineering/agents/[category]/new-agent.md`
2. Update plugin.json description with new count
3. Update marketplace.json description with new count
4. Update README.md agent list
5. Update CHANGELOG.md

### Adding a New Command

1. Create `plugins/compound-engineering/commands/new-command.md`
2. Update counts in plugin.json, marketplace.json, README.md
3. Update CHANGELOG.md

### Adding a New Skill

1. Create `plugins/compound-engineering/skills/skill-name/SKILL.md`
2. Update counts everywhere
3. Update CHANGELOG.md

## Component Counts

Current counts:
- **Agents**: 22
- **Commands**: 20
- **Skills**: 11
- **MCP Servers**: 6

## Resources

- [Claude Code Plugin Documentation](https://docs.claude.com/en/docs/claude-code/plugins)
- [Plugin Marketplace Documentation](https://docs.claude.com/en/docs/claude-code/plugin-marketplaces)

## Credits

Forked from [compound-engineering-plugin](https://github.com/EveryInc/every-marketplace) by Kieran Klaassen at Every Inc.
