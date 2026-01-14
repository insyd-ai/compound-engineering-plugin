# Changelog

All notable changes to the Insyd Engineering plugin will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [4.1.0] - 2026-01-14

### Enhanced

**Ralph Autonomous Loop - Parallel Subagents:**
- `/ralph` command now supports spawning multiple isolated subagents for parallel implementation
- Each subagent gets fresh context with only its relevant tests (no context bleeding)
- Automatic module analysis to identify parallelizable work
- Dependency graph generation for sequencing dependent modules
- Result aggregation with retry logic for partial completions

**New Features:**
- `--parallel` flag to force parallel mode
- `--modules M1,M2,M3` to manually specify modules to parallelize
- `--sequential` flag to force original single-agent behavior
- Automatic mode selection based on test count and module independence

**Architecture:**
```
RALPH ORCHESTRATOR
├── Phase 1: Analysis (parse tests, identify modules, create dependency graph)
├── Phase 2: Parallel Implementation (spawn N subagents for independent modules)
├── Phase 3: Result Aggregation (collect outputs, handle partial completions)
└── Phase 4: Validation (full test suite, coverage, completion report)
```

**Benefits:**
- Isolated contexts prevent bleeding between modules
- Faster completion via parallel execution
- Better focus (each subagent only sees relevant tests)
- Easier debugging (failures isolated to specific modules)
- Retry efficiency (only retry failed modules, not entire feature)

### Updated

- `skills/ralph/ralph.md` - Complete rewrite with parallel subagent orchestration patterns
- `commands/ralph.md` - Enhanced with module analysis and subagent spawning workflows

### Summary

- **24 agents** (unchanged)
- **24 commands** (unchanged)
- **14 skills** (unchanged)
- **6 MCP servers** (unchanged)

---

## [4.0.0] - 2026-01-14

### Added

**Sub-Agent Orchestration System (NEW):**
- `skills/orchestration/` - New skill for Task-based sub-agent management
  - Patterns for spawning isolated sub-agents
  - Workflow coordination across spec → test → code phases
  - Result aggregation and validation
  - Reference: `workflow-patterns.md`, `sub-agent-prompts.md`

**Ralph Autonomous Loop (NEW):**
- `skills/ralph/` - Autonomous implementation loop skill
  - Iterate until all tests pass (TDD GREEN phase)
  - Progress tracking and stuck detection
  - Debugging guidance and escalation patterns
  - Reference: `iteration-strategies.md`, `debugging-guide.md`
- `/ralph` command - Start autonomous implementation loop
  - Pre-flight validation (tests must exist and fail)
  - Iterative implementation until tests pass
  - Completion report with quality metrics

**New Commands (2):**
- `/ralph` - Autonomous implementation loop that iterates until all tests pass
- `/workflows:feature` - Complete TDD feature development with orchestrated sub-agents

### Changed

**TDD Enforcement Enhanced (BREAKING):**
- `hooks/tdd-enforcer.sh` - Now uses HARD BLOCK (`permissionDecision: deny`) instead of ask
  - Implementation code writes are completely blocked without tests
  - Clear guidance on TDD workflow steps
  - Emergency bypass requires `/commit --skip-self-check "emergency: reason"`

### Summary

- **24 agents** (unchanged)
- **24 commands** (+2: ralph, workflows:feature)
- **14 skills** (+2: orchestration, ralph)
- **6 MCP servers** (unchanged)
- **1 hooks configuration** (enhanced: hard-block TDD enforcement)

### Migration Notes

This is a **MAJOR** version bump due to:
1. **TDD enforcement is now HARD BLOCK** - Code writes denied (not just asked) without tests
2. **New orchestration workflow** - `/workflows:feature` provides complete TDD pipeline
3. **Ralph loop** - Autonomous implementation until tests pass

**New Workflow:**
```
/workflows:feature "feature description"
├─ Phase 1: Spec Writing (sub-agent)
├─ Phase 2: Functional Test Cases (sub-agent)
├─ Phase 3: Test Writing - RED Phase (sub-agent)
├─ Phase 4: Implementation - /ralph (iterative)
├─ Phase 5: Validation - /self-check
└─ Phase 6: Commit
```

---

## [3.0.0] - 2026-01-14

### Added

**TDD Enforcement (BREAKING CHANGE):**
- `hooks/hooks.json` - Claude Code hooks for TDD workflow enforcement
- `hooks/detect-test-framework.sh` - SessionStart hook to detect Bun/Playwright test setup
- `hooks/tdd-enforcer.sh` - PreToolUse hook that blocks implementation code writes until tests exist
- Stop hook prompt that verifies tests were run before task completion

**New Agents (2):**
- `tdd-timestamp-validator` - PR review agent that validates TDD compliance by checking git commit timestamps. Blocks merge if TDD score < 80%
- `codebase-indexer` - Generates codebase documentation (CODEBASE_MAP.md, ARCHITECTURE.md, API_INDEX.md, DEPENDENCY_GRAPH.md)

**New Commands (2):**
- `/commit` - Git commit with integrated self-check validation. Runs TypeScript, lint, tests, and coverage checks before committing. Supports `--skip-self-check "reason"` bypass
- `/index-codebase` - Analyze and index codebase, generating documentation deliverables in `docs/codebase/`

**New Skill (1):**
- `tdd-workflow` - Comprehensive TDD workflow documentation including enforcement rules, bypass policy, and test file detection patterns

### Changed

**Bun Test Integration:**
- Updated `self-check` skill - All test commands now use `bun test`, `bun test --coverage`, `bun run playwright test`
- Updated `test-writing` skill - Added TDD workflow section, Bun as primary test runner, 80% coverage requirements
- Updated `/self-check` command - Bun commands, E2E integration, coverage threshold
- Added 80% coverage threshold enforcement across all validation points

**PR Review Enhancement:**
- `/workflows:review` - Added `tdd-timestamp-validator` as conditional agent. Validates TDD workflow was followed by checking commit timestamps. Can block PR merge if score < 80%

### Summary

- **24 agents** (+2: tdd-timestamp-validator, codebase-indexer)
- **22 commands** (+2: commit, index-codebase)
- **12 skills** (+1: tdd-workflow)
- **6 MCP servers** (unchanged)
- **1 hooks configuration** (NEW: 3 hook events)

### Migration Notes

This is a **MAJOR** version bump due to:
1. **TDD enforcement is now mandatory** - Claude will block writing implementation code until tests exist
2. **Commit workflow changed** - `/commit` now runs self-check automatically
3. **Coverage threshold enforced** - 80% minimum coverage required

To bypass TDD enforcement (use sparingly):
- During development: Tests must exist before implementation writes
- During commit: Use `--skip-self-check "reason"` flag
- Skip reasons are logged in commit messages and flagged in PR reviews

---

## [2.1.0] - 2026-01-11

### Added

**New MCP Servers (4):**
- `convex` - Convex backend operations (query deployments, manage tables, execute functions)
- `linear` - Linear issue tracking integration (create, update, search issues)
- `github` - GitHub repository operations (PRs, issues, code search)
- `shadcn` - shadcn/ui component registry (browse, search, install components)

**New Agents (1):**
- `code-simplifier` - Code simplification and refactoring specialist

**New Documentation:**
- `docs/MCP-SETUP.md` - Comprehensive MCP authentication and setup guide

**New Plugin Reference:**
- `claude-mem` - External plugin reference for session memory and context persistence

### Changed
- Updated MCP server count from 2 to 7
- Updated agent count from 21 to 22

---

## [2.0.0] - 2026-01-11

### Added

**New Agents (3):**
- `prd-writer` - Generate Product Requirements Documents from user perspective
- `tdd-writer` - Generate Technical Design Documents for implementation
- `functional-test-writer` - Create comprehensive functional test cases

**New Commands (4):**
- `/spec:write` - Generate PRD and TDD specification documents
- `/test:functional` - Generate functional test cases with success criteria
- `/test:write` - Write unit, integration, or E2E tests
- `/self-check` - Pre-commit validation checks

**New Skills (3):**
- `spec-writing` - Templates and guidelines for PRD and TDD creation
- `test-writing` - Patterns for unit, integration, and E2E testing
- `self-check` - Pre-commit validation with success criteria verification

### Changed

- `/workflows:review` - Added `model: sonnet` for Sonnet 4.5 usage, added functional test validation
- `/workflows:work` - Added Convex integration patterns and functional test case checking
- `repo-research-analyst` - Enhanced with large codebase navigation patterns

### Summary

- 21 agents (+3), 20 commands (+4), 11 skills (+3), 2 MCP servers
- Complete development workflow implementation for 8 use cases:
  1. Spec Writing (PRD + TDD)
  2. Functional Test Cases
  3. Code Writing
  4. Test Writing & Execution
  5. Code Refactoring
  6. Codebase Understanding
  7. Self-Checks (Pre-commit)
  8. PR Reviews

---

## [1.0.0] - 2025-01-11 (Insyd-AI Fork)

### Forked

- Forked from [compound-engineering-plugin](https://github.com/EveryInc/every-marketplace) by Every Inc.

### Refocused

- Refocused plugin for JavaScript/TypeScript development workflows
- Target stack: Convex, Next.js, Astro, React, Vite
- Designed for 8 core use cases: spec writing, functional testcases, code writing, test execution, code refactoring, codebase understanding, self checks, PR reviews

### Removed

**Ruby/Rails agents:**
- `kieran-rails-reviewer` - Rails code review
- `dhh-rails-reviewer` - DHH/Rails philosophy reviewer
- `ankane-readme-writer` - Ruby gem README writer
- `lint` - Ruby/ERB linting

**Ruby/Rails skills:**
- `dhh-rails-style` - Ruby/Rails code in DHH style
- `andrew-kane-gem-writer` - Ruby gem writing patterns
- `dspy-ruby` - Ruby DSPy framework

**Python agents:**
- `kieran-python-reviewer` - Python code review

**iOS/Xcode commands:**
- `xcode-test` - iOS simulator testing

**Design/Figma agents:**
- `design-implementation-reviewer` - Figma-to-implementation verification
- `design-iterator` - Iterative design refinement
- `figma-design-sync` - Figma design synchronization

**Image generation skills:**
- `gemini-imagegen` - Gemini AI image generation

**Company-specific:**
- `every-style-editor` agent and skill - Every company's style guide

**Plugin-specific commands:**
- `report-bug` - Plugin bug reporting
- `feature-video` - PR video walkthroughs
- `changelog` - Plugin changelog generation
- `deploy-docs` - GitHub Pages deployment
- `release-docs` - Documentation site generation

**Other:**
- `coding-tutor` plugin (entire)
- Old documentation and planning folders

### Retained

- 18 agents (TypeScript review, architecture, security, performance, research, workflow)
- 16 commands (testing, planning, code resolution, workflows)
- 8 skills (architecture, docs, dev tools)
- 2 MCP servers (Playwright, Context7)

### Summary

- 18 agents, 16 commands, 8 skills, 2 MCP servers

---

## Previous Changelog (compound-engineering-plugin)

The following entries are from the original compound-engineering-plugin before forking.

---

## [2.23.2] - 2026-01-09

### Changed

- **`/reproduce-bug` command** - Enhanced with Playwright visual reproduction:
  - Added Phase 2 for visual bug reproduction using browser automation
  - Step-by-step guide for navigating to affected areas
  - Screenshot capture at each reproduction step
  - Console error checking
  - User flow reproduction with clicks, typing, and snapshots
  - Better documentation structure with 4 clear phases

### Summary

- 27 agents, 21 commands, 13 skills, 2 MCP servers

---

## [2.23.1] - 2026-01-08

### Changed

- **Agent model inheritance** - All 26 agents now use `model: inherit` so they match the user's configured model. Only `lint` keeps `model: haiku` for cost efficiency. (fixes #69)

### Summary

- 27 agents, 21 commands, 13 skills, 2 MCP servers

---

## [2.23.0] - 2026-01-08

### Added

- **`/agent-native-audit` command** - Comprehensive agent-native architecture review
  - Launches 8 parallel sub-agents, one per core principle
  - Principles: Action Parity, Tools as Primitives, Context Injection, Shared Workspace, CRUD Completeness, UI Integration, Capability Discovery, Prompt-Native Features
  - Each agent produces specific score (X/Y format with percentage)
  - Generates summary report with overall score and top 10 recommendations
  - Supports single principle audit via argument

### Summary

- 27 agents, 21 commands, 13 skills, 2 MCP servers

---

## [2.22.0] - 2026-01-05

### Added

- **`rclone` skill** - Upload files to S3, Cloudflare R2, Backblaze B2, and other cloud storage providers

### Changed

- **`/feature-video` command** - Enhanced with:
  - Better ffmpeg commands for video/GIF creation (proper scaling, framerate control)
  - rclone integration for cloud uploads
  - Screenshot copying to project folder
  - Improved upload options workflow

### Summary

- 27 agents, 20 commands, 13 skills, 2 MCP servers

---

## [2.21.0] - 2026-01-05

### Fixed

- Version history cleanup after merge conflict resolution

### Summary

This release consolidates all recent work:
- `/feature-video` command for recording PR demos
- `/deepen-plan` command for enhanced planning
- `create-agent-skills` skill rewrite (official spec compliance)
- `agent-native-architecture` skill major expansion
- `dhh-rails-style` skill consolidation (merged dhh-ruby-style)
- 27 agents, 20 commands, 12 skills, 2 MCP servers

---

## [2.20.0] - 2026-01-05

### Added

- **`/feature-video` command** - Record video walkthroughs of features using Playwright

### Changed

- **`create-agent-skills` skill** - Complete rewrite to match Anthropic's official skill specification

### Removed

- **`dhh-ruby-style` skill** - Merged into `dhh-rails-style` skill

---

## [2.19.0] - 2025-12-31

### Added

- **`/deepen-plan` command** - Power enhancement for plans. Takes an existing plan and runs parallel research sub-agents for each major section to add:
  - Best practices and industry patterns
  - Performance optimizations
  - UI/UX improvements (if applicable)
  - Quality enhancements and edge cases
  - Real-world implementation examples

  The result is a deeply grounded, production-ready plan with concrete implementation details.

### Changed

- **`/workflows:plan` command** - Added `/deepen-plan` as option 2 in post-generation menu. Added note: if running with ultrathink enabled, automatically run deepen-plan for maximum depth.

## [2.18.0] - 2025-12-25

### Added

- **`agent-native-architecture` skill** - Added **Dynamic Capability Discovery** pattern and **Architecture Review Checklist**:

  **New Patterns in mcp-tool-design.md:**
  - **Dynamic Capability Discovery** - For external APIs (HealthKit, HomeKit, GraphQL), build a discovery tool (`list_*`) that returns available capabilities at runtime, plus a generic access tool that takes strings (not enums). The API validates, not your code. This means agents can use new API capabilities without code changes.
  - **CRUD Completeness** - Every entity the agent can create must also be readable, updatable, and deletable. Incomplete CRUD = broken action parity.

  **New in SKILL.md:**
  - **Architecture Review Checklist** - Pushes reviewer findings earlier into the design phase. Covers tool design (dynamic vs static, CRUD completeness), action parity (capability map, edit/delete), UI integration (agent → UI communication), and context injection.
  - **Option 11: API Integration** - New intake option for connecting to external APIs like HealthKit, HomeKit, GraphQL
  - **New anti-patterns:** Static Tool Mapping (building individual tools for each API endpoint), Incomplete CRUD (create-only tools)
  - **Tool Design Criteria** section added to success criteria checklist

  **New in shared-workspace-architecture.md:**
  - **iCloud File Storage for Multi-Device Sync** - Use iCloud Documents for your shared workspace to get free, automatic multi-device sync without building a sync layer. Includes implementation pattern, conflict handling, entitlements, and when NOT to use it.

### Philosophy

This update codifies a key insight for **agent-native apps**: when integrating with external APIs where the agent should have the same access as the user, use **Dynamic Capability Discovery** instead of static tool mapping. Instead of building `read_steps`, `read_heart_rate`, `read_sleep`... build `list_health_types` + `read_health_data(dataType: string)`. The agent discovers what's available, the API validates the type.

Note: This pattern is specifically for agent-native apps following the "whatever the user can do, the agent can do" philosophy. For constrained agents with intentionally limited capabilities, static tool mapping may be appropriate.

---

## [2.17.0] - 2025-12-25

### Enhanced

- **`agent-native-architecture` skill** - Major expansion based on real-world learnings from building the Every Reader iOS app. Added 5 new reference documents and expanded existing ones:

  **New References:**
  - **dynamic-context-injection.md** - How to inject runtime app state into agent system prompts. Covers context injection patterns, what context to inject (resources, activity, capabilities, vocabulary), implementation patterns for Swift/iOS and TypeScript, and context freshness.
  - **action-parity-discipline.md** - Workflow for ensuring agents can do everything users can do. Includes capability mapping templates, parity audit process, PR checklists, tool design for parity, and context parity guidelines.
  - **shared-workspace-architecture.md** - Patterns for agents and users working in the same data space. Covers directory structure, file tools, UI integration (file watching, shared stores), agent-user collaboration patterns, and security considerations.
  - **agent-native-testing.md** - Testing patterns for agent-native apps. Includes "Can Agent Do It?" tests, the Surprise Test, automated parity testing, integration testing, and CI/CD integration.
  - **mobile-patterns.md** - Mobile-specific patterns for iOS/Android. Covers background execution (checkpoint/resume), permission handling, cost-aware design (model tiers, token budgets, network awareness), offline handling, and battery awareness.

  **Updated References:**
  - **architecture-patterns.md** - Added 3 new patterns: Unified Agent Architecture (one orchestrator, many agent types), Agent-to-UI Communication (shared data store, file watching, event bus), and Model Tier Selection (fast/balanced/powerful).

  **Updated Skill Root:**
  - **SKILL.md** - Expanded intake menu (now 10 options including context injection, action parity, shared workspace, testing, mobile patterns). Added 5 new agent-native anti-patterns (Context Starvation, Orphan Features, Sandbox Isolation, Silent Actions, Capability Hiding). Expanded success criteria with agent-native and mobile-specific checklists.

- **`agent-native-reviewer` agent** - Significantly enhanced with comprehensive review process covering all new patterns. Now checks for action parity, context parity, shared workspace, tool design (primitives vs workflows), dynamic context injection, and mobile-specific concerns. Includes detailed anti-patterns, output format template, quick checks ("Write to Location" test, Surprise test), and mobile-specific verification.

### Philosophy

These updates operationalize a key insight from building agent-native mobile apps: **"The agent should be able to do anything the user can do, through tools that mirror UI capabilities, with full context about the app state."** The failure case that prompted these changes: an agent asked "what reading feed?" when a user said "write something in my reading feed"—because it had no `publish_to_feed` tool and no context about what "feed" meant.

## [2.16.0] - 2025-12-21

### Enhanced

- **`dhh-rails-style` skill** - Massively expanded reference documentation incorporating patterns from Marc Köhlbrugge's Unofficial 37signals Coding Style Guide:
  - **controllers.md** - Added authorization patterns, rate limiting, Sec-Fetch-Site CSRF protection, request context concerns
  - **models.md** - Added validation philosophy, let it crash philosophy (bang methods), default values with lambdas, Rails 7.1+ patterns (normalizes, delegated types, store accessor), concern guidelines with touch chains
  - **frontend.md** - Added Turbo morphing best practices, Turbo frames patterns, 6 new Stimulus controllers (auto-submit, dialog, local-time, etc.), Stimulus best practices, view helpers, caching with personalization, broadcasting patterns
  - **architecture.md** - Added path-based multi-tenancy, database patterns (UUIDs, state as records, hard deletes, counter caches), background job patterns (transaction safety, error handling, batch processing), email patterns, security patterns (XSS, SSRF, CSP), Active Storage patterns
  - **gems.md** - Added expanded what-they-avoid section (service objects, form objects, decorators, CSS preprocessors, React/Vue), testing philosophy with Minitest/fixtures patterns

### Credits

- Reference patterns derived from [Marc Köhlbrugge's Unofficial 37signals Coding Style Guide](https://github.com/marckohlbrugge/unofficial-37signals-coding-style-guide)

## [2.15.2] - 2025-12-21

### Fixed

- **All skills** - Fixed spec compliance issues across 12 skills:
  - Reference files now use proper markdown links (`[file.md](./references/file.md)`) instead of backtick text
  - Descriptions now use third person ("This skill should be used when...") per skill-creator spec
  - Affected skills: agent-native-architecture, andrew-kane-gem-writer, compound-docs, create-agent-skills, dhh-rails-style, dspy-ruby, every-style-editor, file-todos, frontend-design, gemini-imagegen

### Added

- **CLAUDE.md** - Added Skill Compliance Checklist with validation commands for ensuring new skills meet spec requirements

## [2.15.1] - 2025-12-18

### Changed

- **`/workflows:review` command** - Section 7 now detects project type (Web, iOS, or Hybrid) and offers appropriate testing. Web projects get `/playwright-test`, iOS projects get `/xcode-test`, hybrid projects can run both.

## [2.15.0] - 2025-12-18

### Added

- **`/xcode-test` command** - Build and test iOS apps on simulator using XcodeBuildMCP. Automatically detects Xcode project, builds app, launches simulator, and runs test suite. Includes retries for flaky tests.

- **`/playwright-test` command** - Run Playwright browser tests on pages affected by current PR or branch. Detects changed files, maps to affected routes, generates/runs targeted tests, and reports results with screenshots.
