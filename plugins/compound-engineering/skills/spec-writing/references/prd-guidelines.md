# PRD Writing Guidelines

## Core Principle

**Anyone non-technical should understand what the product does and how users interact with it.**

## Language Guidelines

### Do Use
- Plain, everyday language
- Active voice ("Users can upload files")
- Specific examples and scenarios
- User-centric terms ("Users see", "Users can")

### Don't Use
- Technical jargon (API, database, backend, endpoint)
- Passive voice ("Files are uploaded")
- Vague descriptions ("The system handles it")
- Implementation details ("Using REST API...")

## Section Guidelines

### Project Overview

**Problem Statement**:
- Focus on user pain points, not technical limitations
- Explain why this matters to users
- Use real-world examples

**Goals**:
- Write as user outcomes, not system capabilities
- Each goal should be measurable from user perspective
- Limit to 3-5 clear goals

**Scope**:
- Be explicit about what's included AND excluded
- Helps prevent scope creep
- Avoids stakeholder confusion

### User Flows

**Diagrams**:
- Use mermaid for consistency
- Focus on user actions and decisions
- Show happy path and key alternative paths
- Keep diagrams readable (max 10-15 nodes)

**Journey Maps**:
- Include user emotions at each stage
- Identify pain points and opportunities
- Map system responses to user actions

### Functional Requirements

**User Stories Format**:
```
As a [user type],
I want to [action],
so that [benefit].
```

**Acceptance Criteria**:
- Use Given/When/Then format
- Be specific and testable
- Include success and failure cases

**Capabilities**:
- Write as "Users can [verb] [noun]"
- Group related capabilities
- Prioritize (Must have, Should have, Nice to have)

### Non-Functional Requirements

Focus on user experience, not system metrics:

| Technical Metric | User-Facing Translation |
|-----------------|------------------------|
| 200ms API response | Page loads in under 2 seconds |
| 99.9% uptime | Service available when users need it |
| 10k concurrent users | Works during peak hours |

### Limitations and Future Scope

**Limitations**:
- Be honest about what's not included
- Explain why (time, resources, dependencies)
- Set expectations for stakeholders

**Future Scope**:
- Document ideas for future versions
- Helps prioritization discussions
- Prevents "why didn't we think of this" later

## Quality Checklist

Before finalizing:

- [ ] Read through as if you're a non-technical stakeholder
- [ ] Remove or explain any technical terms
- [ ] All diagrams have legends if needed
- [ ] Every requirement is testable by a user
- [ ] Success metrics are user-centric
- [ ] Limitations are clearly stated

## Common Mistakes

### Mistake 1: Technical Language
**Bad**: "The API returns a 401 when authentication fails"
**Good**: "Users see an error message asking them to log in again"

### Mistake 2: Vague Requirements
**Bad**: "The system should be fast"
**Good**: "Pages load within 2 seconds on standard connections"

### Mistake 3: Missing Context
**Bad**: "Users can delete items"
**Good**: "Users can delete their own items from the dashboard. Deleted items move to trash for 30 days before permanent deletion."

### Mistake 4: Implementation Details
**Bad**: "Store user data in PostgreSQL with proper indexing"
**Good**: "User data is saved and available across sessions"

## Review Process

1. **Self-Review**: Read as a non-technical person
2. **Peer Review**: Have a non-engineer review
3. **Stakeholder Review**: Get business approval
4. **Technical Review**: Verify feasibility (separate from PRD)
