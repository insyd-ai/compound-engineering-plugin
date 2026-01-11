---
name: spec:write
description: Generate PRD and TDD specification documents for a project or feature
argument-hint: "[project-name, feature description, or requirements file]"
---

# Specification Writing Command

Generate comprehensive Product Requirements Document (PRD) and Technical Design Document (TDD) for a project or feature.

## Introduction

This command creates two separate specification documents:
1. **PRD**: Non-technical, user-focused documentation
2. **TDD**: Developer-focused implementation details

## Input

<project_input> #$ARGUMENTS </project_input>

If no input provided, ask for:
- Project or feature name
- Brief description of what needs to be built
- Any existing requirements or context

## Execution Workflow

### Phase 1: Project Understanding

<thinking>
Gather all context needed to write comprehensive specifications.
</thinking>

<tasks>

1. **Read Available Context**
   - If a file path provided, read the requirements file
   - If a GitHub issue provided, fetch issue details
   - Review any referenced documents

2. **Ask Clarifying Questions**

   Ask these questions before proceeding:

   - What problem does this solve for users?
   - Who are the primary users?
   - What are the key user interactions?
   - Are there existing patterns to follow in the codebase?
   - What are known constraints or limitations?
   - What is the target stack? (Convex, Next.js, etc.)

3. **Get Approval to Proceed**
   - Summarize understanding
   - Confirm before generating specs

</tasks>

### Phase 2: Research

<parallel_research>

Launch research agents in parallel to gather context:

1. **Task repo-research-analyst**: "Analyze the repository structure, existing patterns, and conventions for [project/feature name]"

2. **Task framework-docs-researcher**: "Research best practices and patterns for implementing [feature type] in [stack: Convex, Next.js, React]"

3. **Task best-practices-researcher**: "Research industry best practices for [feature type] including security, performance, and UX considerations"

</parallel_research>

### Phase 3: PRD Generation

<prd_generation>

Use the spec-writing skill and prd-writer agent:

```
skill: spec-writing
```

1. **Task prd-writer**: Generate PRD with:
   - Project Overview (problem, goals, scope)
   - User Flow Diagrams (mermaid flowcharts)
   - User Stories and Functional Requirements
   - Non-Functional Requirements (user-facing)
   - Known Limitations and Future Scope

2. **Output Location**: `docs/specs/prd/<project-name>.md`

3. **Ensure Output Directory Exists**:
   ```bash
   mkdir -p docs/specs/prd
   ```

4. **Write PRD File**:
   - Use prd-template.md as base structure
   - Fill all sections with project-specific content
   - Include mermaid diagrams for user flows
   - Write in plain, non-technical language

</prd_generation>

### Phase 4: TDD Generation

<tdd_generation>

Use the spec-writing skill and tdd-writer agent:

1. **Task tdd-writer**: Generate TDD with:
   - Architecture (system design, components, data flow)
   - API Specifications (endpoints, request/response, errors)
   - Database Schema (tables, relationships, indexes)
   - Dependencies (external/internal with exposure analysis)
   - Security Implementation:
     - Abuse prevention (auth, spam/DDoS/bot protection)
     - Protection for unaware users (input validation)
     - Resource management (rate limiting)
     - Authorization controls
   - Performance (scalability, caching, optimization)
   - Implementation Details (algorithms, patterns)

2. **Output Location**: `docs/specs/tdd/<project-name>.md`

3. **Ensure Output Directory Exists**:
   ```bash
   mkdir -p docs/specs/tdd
   ```

4. **Write TDD File**:
   - Use tdd-template.md as base structure
   - Fill all sections with technical details
   - Include mermaid diagrams for architecture
   - Reference the PRD for requirements context

</tdd_generation>

### Phase 5: Review and Next Steps

<review>

1. **Present Both Documents**:
   - Summary of PRD contents
   - Summary of TDD contents
   - File locations

2. **Cross-Reference Check**:
   - Verify TDD addresses all PRD requirements
   - Ensure security covers all user interactions
   - Confirm performance meets non-functional requirements

3. **Next Steps Menu**:

   What would you like to do next?

   1. **Generate functional test cases** - Run `/test:functional <project-name>`
   2. **Review and refine PRD** - Focus on user requirements
   3. **Review and refine TDD** - Focus on technical details
   4. **Start implementation** - Run `/workflows:work docs/specs/tdd/<project-name>.md`
   5. **Other** - Custom action

</review>

## Output Structure

```
docs/
├── specs/
│   ├── prd/
│   │   └── <project-name>.md   # Non-technical requirements
│   └── tdd/
│       └── <project-name>.md   # Technical design
```

## Quality Checklist

Before completing:

### PRD Quality
- [ ] Zero technical jargon
- [ ] All user flows have mermaid diagrams
- [ ] Requirements written as user capabilities
- [ ] Non-functional requirements are user-facing
- [ ] Readable by non-technical stakeholders

### TDD Quality
- [ ] Architecture diagram included
- [ ] All APIs documented with formats
- [ ] Database schema with constraints
- [ ] Security covers all four categories
- [ ] Performance strategy defined
- [ ] Implementation guidance provided

## Key Principles

### Separation of Concerns

- **PRD** is for stakeholders, product managers, designers
- **TDD** is for developers, architects, security engineers
- Each document should stand alone for its audience

### User-First PRD

- Focus on what users can DO, not how system works
- Use examples and scenarios
- Include visual flow diagrams
- Write in plain language

### Comprehensive TDD

- Cover all technical aspects
- Include security for all four threat categories
- Provide enough detail for implementation
- Reference PRD requirements explicitly

## Common Patterns

### For Convex Backend

- Use Convex schema format for database documentation
- Document queries, mutations, and actions
- Include real-time subscription patterns
- Note Convex-specific security considerations

### For Next.js Frontend

- Document component structure
- Include routing patterns
- Note SSR/SSG considerations
- Document state management approach

### For API Integrations

- Document all external API calls
- Include rate limits and fallbacks
- Note authentication requirements
- Document error handling
