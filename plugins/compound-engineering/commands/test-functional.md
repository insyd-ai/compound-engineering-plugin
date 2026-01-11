---
name: test:functional
description: Generate functional test cases with success criteria and behavioral specifications
argument-hint: "[feature-name, spec file path, or PRD reference]"
---

# Functional Test Cases Command

Generate comprehensive functional test cases with success criteria, behavioral specifications, and context-aware scenarios.

## Introduction

This command creates detailed test cases that define:
- Success criteria for each functionality
- Behavioral specifications ("When user does X, Y should happen")
- Context-aware scenarios ("When user is on XYZ page and performs ABC action, then...")
- Edge cases and error states
- Clear, testable conditions

## Input

<feature_input> #$ARGUMENTS </feature_input>

If no input provided, ask for:
- Feature or component name
- Link to PRD or spec document (if available)
- Brief description of the functionality

## Execution Workflow

### Phase 1: Feature Understanding

<thinking>
Gather all context about the feature to be tested.
</thinking>

<tasks>

1. **Read Available Specifications**

   Check for existing documentation:
   ```bash
   # Look for PRD
   ls docs/specs/prd/

   # Look for TDD
   ls docs/specs/tdd/

   # Look for existing test cases
   ls docs/test-cases/
   ```

2. **Read Related Code** (if feature exists)

   If the feature is already implemented:
   - Read relevant source files
   - Identify user interactions
   - Map data flows

3. **Identify Test Scope**

   Determine what needs to be tested:
   - Primary user flows
   - Error handling
   - Edge cases
   - Authorization requirements

</tasks>

### Phase 2: Test Case Generation

<test_generation>

Use the functional-test-writer agent:

1. **Task functional-test-writer**: Generate test cases with:

   **Success Criteria**:
   - Define primary success criteria (SC-001, SC-002, etc.)
   - Define secondary success criteria
   - Make each criterion specific and testable

   **Behavioral Specifications**:
   - Map all user actions to expected behaviors
   - Include context (page, state, conditions)
   - Format: "When user does X, Y should happen"

   **Context-Aware Scenarios**:
   - Consider different user states (logged in, guest, admin)
   - Consider different pages/locations
   - Consider different data states (empty, populated, max)
   - Consider different devices (desktop, mobile)

   **Edge Cases**:
   - Empty states
   - Maximum limits
   - Minimum limits
   - Special characters
   - Concurrent actions
   - Session edge cases

   **Error States**:
   - Validation errors
   - Authentication errors
   - Network errors
   - Server errors
   - Business logic errors
   - Include recovery paths for each

2. **Output Location**: `docs/test-cases/<feature-name>.md`

3. **Ensure Output Directory Exists**:
   ```bash
   mkdir -p docs/test-cases
   ```

</test_generation>

### Phase 3: Cross-Reference with PRD

<cross_reference>

If a PRD exists for this feature:

1. Read the PRD from `docs/specs/prd/`
2. For each functional requirement in PRD:
   - Verify at least one test case covers it
   - Add test cases for any uncovered requirements
3. For each user story in PRD:
   - Verify acceptance criteria are testable
   - Create test cases matching acceptance criteria

</cross_reference>

### Phase 4: Review and Finalize

<review>

1. **Present Test Case Summary**:

   ```markdown
   ## Test Cases Generated: [Feature Name]

   **Total Test Cases**: X

   | Category | Count | Priority |
   |----------|-------|----------|
   | Happy Path | X | P1 |
   | Error Handling | X | P1 |
   | Edge Cases | X | P2 |
   | Boundary | X | P2 |
   | Context-Specific | X | P3 |

   **Success Criteria Defined**: X

   **File Location**: docs/test-cases/<feature-name>.md
   ```

2. **Validate Completeness**:
   - [ ] All success criteria have test cases
   - [ ] Happy paths covered
   - [ ] Error states have recovery paths
   - [ ] Edge cases identified
   - [ ] Context variations considered

3. **Next Steps Menu**:

   What would you like to do next?

   1. **Start implementation** - Use test cases as specification
   2. **Add more test cases** - Expand coverage
   3. **Generate automated tests** - Run `/test:write <feature-name>`
   4. **Review with team** - Share for feedback
   5. **Other** - Custom action

</review>

## Output Format

The generated test cases follow this structure:

```markdown
# Functional Test Cases: [Feature Name]

## Success Criteria
- [SC-001] [Criterion description]
- [SC-002] [Criterion description]

## Test Cases

### TC-001: [Test Name]
**Priority**: P1
**Category**: Happy Path
**Context**: When user is on [page] with [conditions]

**Given**: [Preconditions]
**When**: [User action]
**Then**: [Expected outcome]

**Verification**:
- [ ] [Check 1]
- [ ] [Check 2]

## Behavioral Specifications

| User Action | Expected Behavior | Context |
|-------------|-------------------|---------|
| [Action] | [Behavior] | [Context] |

## Edge Cases
...

## Error States
...
```

## Quality Checklist

Before completing:

- [ ] Every success criterion has at least one test case
- [ ] All test cases use Given/When/Then format
- [ ] Context is specific (page, user state, data state)
- [ ] Expected outcomes are specific and verifiable
- [ ] Edge cases cover empty, max, min, special characters
- [ ] Error states include clear recovery paths
- [ ] Test cases are prioritized (P1/P2/P3)
- [ ] No ambiguous language ("should work correctly")

## Key Principles

### Be Specific with Context

**Bad**: "User submits form"
**Good**: "When user is on the registration page with valid email and password entered, user clicks Submit button"

### Be Specific with Outcomes

**Bad**: "Form is submitted successfully"
**Good**: "User is redirected to dashboard, welcome toast appears for 3 seconds, user email is visible in profile"

### Cover All Paths

1. **Happy Path**: Primary use case works
2. **Validation**: Invalid inputs rejected with clear messages
3. **Boundaries**: Min/max values handled
4. **Edge Cases**: Unusual but valid scenarios
5. **Errors**: System fails gracefully

### Prioritize Appropriately

- **P1 (Critical)**: Core functionality, security, data integrity
- **P2 (Important)**: Important UX, secondary features
- **P3 (Nice-to-have)**: Rare edge cases

## Integration

Test cases integrate with:

- `/self-check`: Validates code against success criteria
- `/workflows:review`: Checks implementation meets test cases
- `/test:write`: Generates automated tests from cases
