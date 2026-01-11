---
name: spec-writing
description: This skill should be used when creating product requirements documents (PRD) and technical design documents (TDD). It provides templates, guidelines, and workflows for comprehensive specification writing that separates non-technical user-focused documentation from technical implementation details.
---

# Spec Writing Skill

## Overview

This skill provides structured approaches for creating two distinct specification documents:

1. **PRD (Product Requirements Document)**: Non-technical, user-focused documentation
2. **TDD (Technical Design Document)**: Developer-focused implementation details

## When to Use

This skill should be activated when:
- Starting a new feature or project that needs documentation
- Translating user requirements into formal specifications
- Creating documentation for stakeholder review
- Preparing technical specifications for development teams

## Output Locations

Specifications are saved to the project's `docs/` directory:

```
docs/
├── specs/
│   ├── prd/           # Product Requirements Documents
│   │   └── <project-name>.md
│   └── tdd/           # Technical Design Documents
│       └── <project-name>.md
```

## Templates

### PRD Template

Use the template at [prd-template.md](./assets/prd-template.md) for creating PRDs.

Key sections:
- Project Overview (problem, goals, scope)
- User Flows (mermaid diagrams, journey maps)
- Functional Requirements (user stories, capabilities)
- Non-Functional Requirements (performance, accessibility, usability)
- Known Limitations and Future Scope

### TDD Template

Use the template at [tdd-template.md](./assets/tdd-template.md) for creating TDDs.

Key sections:
- Architecture (system design, components, data flow)
- API Specifications (endpoints, request/response, errors)
- Database Schema (tables, relationships, indexes)
- Dependencies (external/internal with exposure analysis)
- Security Implementation (4 categories)
- Performance (scalability, caching, optimization)
- Implementation Details (algorithms, patterns)

## Guidelines

For detailed writing guidelines:
- PRD Guidelines: [prd-guidelines.md](./references/prd-guidelines.md)
- TDD Guidelines: [tdd-guidelines.md](./references/tdd-guidelines.md)

## Workflow

### Step 1: Gather Requirements

Before writing specifications:
1. Collect all available context (user stories, feature requests, conversations)
2. Identify stakeholders and their needs
3. Clarify ambiguous requirements with questions

### Step 2: Create PRD First

The PRD should be created first because:
1. It establishes user needs without technical constraints
2. Non-technical stakeholders can review and approve
3. It serves as input for the TDD

### Step 3: Create TDD from PRD

The TDD translates PRD requirements into technical specifications:
1. Reference the PRD for each technical decision
2. Ensure every PRD requirement has a technical approach
3. Add implementation details developers need

### Step 4: Cross-Reference

After both documents are complete:
1. Verify TDD addresses all PRD requirements
2. Ensure security covers all user interactions
3. Confirm performance meets non-functional requirements

## Integration with Other Commands

| Command | Integration |
|---------|-------------|
| `/spec:write` | Primary command that uses this skill |
| `/test:functional` | Creates test cases from PRD requirements |
| `/workflows:work` | Uses TDD for implementation guidance |
| `/workflows:review` | Validates code against TDD specifications |

## Quality Checklist

Before finalizing specifications:

### PRD Checklist
- [ ] Zero technical jargon
- [ ] All user flows have diagrams
- [ ] Requirements written as user capabilities
- [ ] Non-functional requirements are user-facing
- [ ] Readable by non-technical stakeholders

### TDD Checklist
- [ ] Architecture diagram included
- [ ] All APIs documented with formats
- [ ] Database schema with constraints
- [ ] Security covers all four categories
- [ ] Performance strategy defined
- [ ] Implementation guidance provided
