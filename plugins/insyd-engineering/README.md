# Insyd Engineering Plugin

Engineering plugin for modern JavaScript/TypeScript development with **TDD enforcement** and **sub-agent orchestration**. Uses Bun test runner and Playwright for E2E. Optimized for Convex, Next.js, Astro, React, and Vite projects.

> Forked from [compound-engineering-plugin](https://github.com/EveryInc/every-marketplace) by Every Inc.

## New in v4.0.0: Sub-Agent Orchestration

This version introduces **Task-based sub-agent orchestration** for complete TDD workflows:

```
/workflows:feature "User authentication with OAuth"
│
├─ Phase 1: Specs (sub-agent)
│   └─ Generate PRD + TDD documents
│
├─ Phase 2: Test Cases (sub-agent)
│   └─ Generate functional test cases
│
├─ Phase 3: Test Writing (sub-agent) ← RED Phase
│   └─ Generate failing tests
│   └─ ⛔ HARD BLOCK: No code without tests
│
├─ Phase 4: Implementation ← /ralph loop
│   └─ Iterate until ALL tests pass
│
├─ Phase 5: Validation
│   └─ /self-check (TypeScript, lint, coverage)
│
└─ Phase 6: Commit
    └─ Only if validation passes
```

**Key commands:**
- `/workflows:feature` - Complete TDD workflow with orchestrated sub-agents
- `/ralph` - Autonomous implementation loop (iterate until tests pass)

## TDD Enforcement (HARD BLOCK)

This plugin enforces **Test-Driven Development** with a HARD BLOCK:
- ⛔ Code writes are **DENIED** (not just asked) without tests
- Tests MUST be written BEFORE implementation code
- 80% coverage threshold required
- `/commit` command runs self-check automatically
- PR reviews validate TDD compliance via commit timestamps

See the `tdd-workflow` and `orchestration` skills for details.

## Use Cases

This plugin is designed for 8 core engineering workflows:

1. **Spec Writing** - Generate PRD and TDD specification documents
2. **Functional Testcases** - Define success criteria and test scenarios
3. **Code Writing** - Frontend (React, Next.js, Astro, Vite) and backend (Convex) development
4. **Test Writing & Execution** - Unit, integration, and E2E tests with Bun and Playwright
5. **Code Refactoring** - Simplify and improve code quality
6. **Codebase Understanding** - Index and analyze large codebases with documentation deliverables
7. **Self Checks** - Pre-commit validation with coverage enforcement
8. **PR Reviews** - Comprehensive code review with TDD validation

## Components

| Component | Count |
|-----------|-------|
| Agents | 24 |
| Commands | 24 |
| Skills | 14 |
| MCP Servers | 6 |
| Hooks | 3 events (with HARD BLOCK TDD enforcement) |

## Agents

Agents are organized into categories for easier discovery.

### Review (13)

| Agent | Description |
|-------|-------------|
| `agent-native-reviewer` | Verify features are agent-native (action + context parity) |
| `architecture-strategist` | Analyze architectural decisions and compliance |
| `code-simplicity-reviewer` | Final pass for simplicity and minimalism |
| `code-simplifier` | Simplify and refactor code for clarity and maintainability |
| `data-integrity-guardian` | Database migrations and data integrity |
| `data-migration-expert` | Validate ID mappings match production, check for swapped values |
| `deployment-verification-agent` | Create Go/No-Go deployment checklists for risky data changes |
| `kieran-typescript-reviewer` | TypeScript code review with strict conventions |
| `julik-frontend-races-reviewer` | Review JavaScript/Stimulus code for race conditions |
| `pattern-recognition-specialist` | Analyze code for patterns and anti-patterns |
| `performance-oracle` | Performance analysis and optimization |
| `security-sentinel` | Security audits and vulnerability assessments |
| `tdd-timestamp-validator` | Validate TDD workflow by checking commit timestamps (blocks merge if < 80%) |

### Research (4)

| Agent | Description |
|-------|-------------|
| `best-practices-researcher` | Gather external best practices and examples |
| `framework-docs-researcher` | Research framework documentation and best practices |
| `git-history-analyzer` | Analyze git history and code evolution |
| `repo-research-analyst` | Research repository structure and conventions |

### Workflow (7)

| Agent | Description |
|-------|-------------|
| `bug-reproduction-validator` | Systematically reproduce and validate bug reports |
| `codebase-indexer` | Generate codebase documentation (CODEBASE_MAP, ARCHITECTURE, API_INDEX, DEPENDENCY_GRAPH) |
| `functional-test-writer` | Generate comprehensive functional test cases |
| `pr-comment-resolver` | Address PR comments and implement fixes |
| `prd-writer` | Generate Product Requirements Documents from user perspective |
| `spec-flow-analyzer` | Analyze user flows and identify gaps in specifications |
| `tdd-writer` | Generate Technical Design Documents for implementation |

## Commands

### Workflow Commands

Core workflow commands use `workflows:` prefix to avoid collisions with built-in commands:

| Command | Description |
|---------|-------------|
| `/workflows:feature` | **NEW** Complete TDD feature development with orchestrated sub-agents |
| `/workflows:plan` | Create implementation plans |
| `/workflows:review` | Run comprehensive code reviews |
| `/workflows:work` | Execute work items systematically |
| `/workflows:compound` | Document solved problems to compound team knowledge |

### Spec & Testing Commands

| Command | Description |
|---------|-------------|
| `/spec:write` | Generate PRD and TDD specification documents |
| `/test:functional` | Generate functional test cases with success criteria |
| `/test:write` | Write unit, integration, or E2E tests |
| `/ralph` | **NEW** Autonomous implementation loop - iterate until all tests pass |
| `/self-check` | Run pre-commit validation checks |
| `/commit` | Git commit with integrated self-check (runs TypeScript, lint, tests, coverage) |
| `/index-codebase` | Generate codebase documentation in `docs/codebase/` |

### Utility Commands

| Command | Description |
|---------|-------------|
| `/agent-native-audit` | Run comprehensive agent-native architecture review |
| `/create-agent-skill` | Create or edit Claude Code skills |
| `/deepen-plan` | Enhance plans with parallel research agents for each section |
| `/generate_command` | Generate new slash commands |
| `/heal-skill` | Fix skill documentation issues |
| `/plan_review` | Multi-agent plan review in parallel |
| `/playwright-test` | Run browser tests on PR-affected pages |
| `/reproduce-bug` | Reproduce bugs using logs and console |
| `/resolve_parallel` | Resolve TODO comments in parallel |
| `/resolve_pr_parallel` | Resolve PR comments in parallel |
| `/resolve_todo_parallel` | Resolve todos in parallel |
| `/triage` | Triage and prioritize issues |

## Skills

### Architecture & Design

| Skill | Description |
|-------|-------------|
| `agent-native-architecture` | Build AI agents using prompt-native architecture |
| `frontend-design` | Create production-grade frontend interfaces |

### Specification & Testing

| Skill | Description |
|-------|-------------|
| `spec-writing` | Templates and guidelines for PRD and TDD creation |
| `test-writing` | Patterns for unit, integration, and E2E testing with Bun |
| `self-check` | Pre-commit validation with 80% coverage enforcement |
| `tdd-workflow` | TDD enforcement rules, bypass policy, and workflow documentation |

### Orchestration & Automation (NEW in v4.0.0)

| Skill | Description |
|-------|-------------|
| `orchestration` | **NEW** Task-based sub-agent orchestration for complex workflows |
| `ralph` | **NEW** Autonomous implementation loop - iterate until tests pass |

### Development Tools

| Skill | Description |
|-------|-------------|
| `compound-docs` | Capture solved problems as categorized documentation |
| `create-agent-skills` | Expert guidance for creating Claude Code skills |
| `skill-creator` | Guide for creating effective Claude Code skills |
| `file-todos` | File-based todo tracking system |
| `git-worktree` | Manage Git worktrees for parallel development |

### File Transfer

| Skill | Description |
|-------|-------------|
| `rclone` | Upload files to S3, Cloudflare R2, Backblaze B2, and cloud storage |

## MCP Servers

| Server | Type | Description |
|--------|------|-------------|
| `pw` | stdio | Browser automation via `@playwright/mcp` |
| `context7` | http | Framework documentation lookup (100+ libraries) |
| `convex` | stdio | Convex backend operations |
| `linear` | stdio | Linear issue tracking integration |
| `github` | http | GitHub repository operations |
| `shadcn` | stdio | shadcn/ui component registry |

### Authentication Required

Some MCP servers require authentication:
- **GitHub**: Set `GITHUB_PAT` environment variable
- **Linear**: Complete OAuth via `/mcp` command

See [MCP-SETUP.md](docs/MCP-SETUP.md) for detailed setup instructions.

### Playwright (`pw`)

**Tools provided:**
- `browser_navigate` - Navigate to URLs
- `browser_take_screenshot` - Take screenshots
- `browser_click` - Click elements
- `browser_fill_form` - Fill form fields
- `browser_snapshot` - Get accessibility snapshot
- `browser_evaluate` - Execute JavaScript

### Context7

**Tools provided:**
- `resolve-library-id` - Find library ID for a framework/package
- `get-library-docs` - Get documentation for a specific library

Supports 100+ frameworks including React, Next.js, Vue, Astro, Convex, and more.

### Convex

**Tools provided:**
- Query deployments and tables
- Execute Convex functions
- Manage backend resources

### Linear

**Tools provided:**
- Create, update, and search issues
- Manage projects and cycles
- Track team activity

### GitHub

**Tools provided:**
- Repository operations (PRs, issues)
- Code search across repositories
- Review and comment on changes

### shadcn

**Tools provided:**
- Browse component registry
- Search for components
- Install components to project

MCP servers start automatically when the plugin is enabled.

## Installation

```bash
claude plugin add insyd-ai/compound-engineering-plugin
```

## Known Issues

### MCP Servers Not Auto-Loading

**Issue:** The bundled MCP servers (Playwright and Context7) may not load automatically when the plugin is installed.

**Workaround:** Manually add them to your project's `.claude/settings.json`:

```json
{
  "mcpServers": {
    "pw": {
      "type": "stdio",
      "command": "bunx",
      "args": ["@playwright/mcp@latest"],
      "env": {}
    },
    "context7": {
      "type": "http",
      "url": "https://mcp.context7.com/mcp"
    }
  }
}
```

Or add them globally in `~/.claude/settings.json` for all projects.

## Version History

See [CHANGELOG.md](CHANGELOG.md) for detailed version history.

## License

MIT

## Credits

Forked from [compound-engineering-plugin](https://github.com/EveryInc/every-marketplace) originally created by Kieran Klaassen at Every Inc.
