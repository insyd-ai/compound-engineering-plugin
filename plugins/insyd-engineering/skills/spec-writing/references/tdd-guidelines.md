# TDD Writing Guidelines

## Core Principle

**Provide developers with everything needed to implement a feature correctly, securely, and efficiently.**

## Section Guidelines

### Architecture

**System Design Diagram**:
- Show all major components
- Include data flow direction
- Mark external dependencies
- Use consistent styling (mermaid)

**Component Table**:
- One row per component
- Clear responsibility description
- Technology choices with rationale
- Owner/team assignment

**Data Flow**:
- Numbered steps from user action to response
- Include all system interactions
- Note where errors can occur

### API Specifications

**Endpoint Documentation**:
- HTTP method and path
- Purpose in one sentence
- Authentication requirements
- Authorization requirements (roles)
- Request format with types
- Response format with types
- All error responses

**Error Handling**:
- Use consistent error codes
- Include HTTP status codes
- Provide error message format
- Document retry behavior if applicable

**Versioning**:
- Document API version strategy
- Note breaking change handling

### Database Schema

**Table Definitions**:
- All columns with types
- Constraints (PK, FK, UNIQUE, CHECK)
- Default values
- Purpose of each column

**Relationships**:
- ER diagram for visual reference
- Cardinality (1:1, 1:N, M:N)
- Cascade behavior

**Indexes**:
- Index name and columns
- Index type (BTREE, HASH, GIN)
- Purpose (performance, uniqueness)

**Migrations**:
- Reversibility noted
- Risk level assessed
- Order dependencies

### Dependencies

**External Dependencies**:
- Exact version or version range
- Purpose and justification
- License compatibility
- Risk assessment (maintenance, security)

**Internal Dependencies**:
- Service and its API
- Required vs optional
- Fallback behavior
- Impact if unavailable

### Security Implementation

Document all four categories:

#### 1. Abuse Prevention (Bad Actors)
Threats from intentionally malicious users:
- Authentication attacks
- Brute force attempts
- Spam and abuse
- DDoS attacks
- Bot attacks

#### 2. Protection for Unaware Users
Protect users who don't know better or are compromised:
- XSS prevention
- SQL injection prevention
- CSRF protection
- Input validation
- Output encoding

#### 3. Resource Management
Prevent good actors from using more than they should:
- Rate limiting per resource type
- Quota management
- Connection limits
- Upload size limits

#### 4. Authorization Controls
Control what good actors at different permission levels can do:
- Role definitions
- Permission matrix
- Resource ownership
- Audit logging

### Performance

**Scalability**:
- Horizontal vs vertical scaling approach
- Stateless design requirements
- Database scaling strategy

**Caching**:
- What to cache
- Where to cache (CDN, Redis, application)
- TTL values
- Invalidation strategy

**Optimization**:
- Identified bottlenecks
- Optimization approaches
- Performance targets with measurements

### Implementation Details

**Algorithms**:
- Purpose and problem solved
- Time and space complexity
- Why this approach vs alternatives
- Edge cases

**Design Patterns**:
- Pattern name
- Where applied
- Why chosen
- Trade-offs

**Code Organization**:
- Directory structure
- Module responsibilities
- Naming conventions

## Quality Checklist

Before finalizing:

- [ ] Architecture diagram is complete and accurate
- [ ] All API endpoints documented with all fields
- [ ] Database schema includes constraints and indexes
- [ ] All dependencies listed with versions
- [ ] Security covers all four categories
- [ ] Performance targets are measurable
- [ ] Implementation guidance is actionable
- [ ] Migration and rollback plans exist

## Common Mistakes

### Mistake 1: Missing Error Cases
**Bad**: Only documenting 200 OK response
**Good**: Document all possible error responses (400, 401, 403, 404, 500)

### Mistake 2: Vague Security
**Bad**: "Implement proper security"
**Good**: Specific mitigations for each threat category

### Mistake 3: No Performance Targets
**Bad**: "Should be fast"
**Good**: "p99 response time < 200ms, measured with [tool]"

### Mistake 4: Missing Constraints
**Bad**: Table definition with only column names
**Good**: Full constraints, indexes, and relationships

### Mistake 5: Undocumented Dependencies
**Bad**: "Uses Redis"
**Good**: "Redis 7.x for session storage, 24h TTL, cluster mode"

## Review Process

1. **Self-Review**: Verify completeness against checklist
2. **Security Review**: Have security team review security section
3. **Architecture Review**: Senior engineer reviews design
4. **Team Review**: Implementation team understands all details
