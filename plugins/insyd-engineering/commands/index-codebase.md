---
name: index-codebase
description: Analyze and index the codebase, generating documentation deliverables
argument-hint: "[--quick | --full]"
---

# Index Codebase Command

Analyze the current codebase and generate comprehensive documentation deliverables to help developers understand and navigate the code.

## Output Location

All documents are saved to: `docs/codebase/`

## Deliverables

| File | Description |
|------|-------------|
| `CODEBASE_MAP.md` | High-level navigation guide |
| `ARCHITECTURE.md` | System design and patterns |
| `API_INDEX.md` | All API endpoints documented |
| `DEPENDENCY_GRAPH.md` | Dependency relationships |

## Arguments

<args> #$ARGUMENTS </args>

| Option | Description |
|--------|-------------|
| `--quick` | Basic structure only (fast) |
| `--full` | Complete analysis with all details |
| (default) | Standard analysis |

## Workflow

### Phase 1: Setup

Create output directory if it doesn't exist:

```bash
mkdir -p docs/codebase
```

### Phase 2: Launch Codebase Indexer

Use the codebase-indexer agent to analyze the codebase:

```
Task codebase-indexer

Analyze this codebase and generate the four documentation deliverables:
1. CODEBASE_MAP.md - Directory structure, entry points, navigation
2. ARCHITECTURE.md - System design, components, data flow
3. API_INDEX.md - All API endpoints with details
4. DEPENDENCY_GRAPH.md - Package dependencies, internal modules

Save all files to docs/codebase/
```

### Phase 3: Analysis Scope

#### Quick Mode (`--quick`)

Generates basic structure only:
- Directory tree
- Entry points
- Key files list
- Package.json dependencies

**Estimated time**: 1-2 minutes

#### Standard Mode (default)

Full structure plus:
- Component relationships
- API endpoint discovery
- Import/export analysis
- Architecture diagrams

**Estimated time**: 3-5 minutes

#### Full Mode (`--full`)

Everything in standard plus:
- Detailed dependency graph
- Security vulnerability check
- Outdated package detection
- Circular dependency analysis
- Code metrics

**Estimated time**: 5-10 minutes

### Phase 4: Generate Documents

The codebase-indexer agent will create:

1. **CODEBASE_MAP.md**
   - Directory structure with descriptions
   - Key directories table
   - Entry points
   - Quick navigation by feature and layer

2. **ARCHITECTURE.md**
   - System design diagram (mermaid)
   - Component responsibilities
   - Data flow diagram
   - Design patterns used

3. **API_INDEX.md**
   - Endpoints summary table
   - Detailed endpoint documentation
   - Request/response schemas
   - Error codes

4. **DEPENDENCY_GRAPH.md**
   - External dependencies table
   - Internal module graph (mermaid)
   - Circular dependencies (if any)
   - Dependency health metrics

### Phase 5: Report

After completion:

```
✅ Codebase indexed successfully

**Generated Documents:**
- docs/codebase/CODEBASE_MAP.md
- docs/codebase/ARCHITECTURE.md
- docs/codebase/API_INDEX.md
- docs/codebase/DEPENDENCY_GRAPH.md

**Summary:**
- Directories analyzed: X
- Files scanned: Y
- API endpoints found: Z
- Dependencies mapped: W

**View documents:**
- Open docs/codebase/ in your editor
- Or read specific files with /read docs/codebase/CODEBASE_MAP.md
```

## Use Cases

### Onboarding

New team members can quickly understand:
- Where to find things (CODEBASE_MAP)
- How the system works (ARCHITECTURE)
- What APIs are available (API_INDEX)
- What dependencies exist (DEPENDENCY_GRAPH)

### Code Review

Reviewers can reference:
- Expected file locations
- Architectural patterns to follow
- Existing API conventions

### Refactoring

Before major changes:
- Understand current structure
- Identify affected areas
- Check for circular dependencies

### Documentation

Keep docs up to date:
- Run `/index-codebase` after major changes
- Compare with previous versions
- Update team documentation

## Integration Points

| Component | Integration |
|-----------|-------------|
| `codebase-indexer` agent | Performs the actual analysis |
| `docs/codebase/` | Output directory |
| `/workflows:review` | Can reference generated docs |
