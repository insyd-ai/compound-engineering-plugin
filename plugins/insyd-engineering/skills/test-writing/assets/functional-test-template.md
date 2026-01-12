# Functional Test Cases: [Feature Name]

**Version**: 1.0
**Date**: [Date]
**Author**: [Author]
**PRD Reference**: [Link to PRD if available]

---

## Feature Summary

[Brief description of the feature being tested]

## Prerequisites

- [ ] [Required state or setup before testing]
- [ ] [User roles or permissions needed]
- [ ] [Data or environment requirements]

## Test Coverage Summary

| Category | Count | Priority |
|----------|-------|----------|
| Happy Path | 0 | P1 |
| Error Handling | 0 | P1 |
| Edge Cases | 0 | P2 |
| Boundary Conditions | 0 | P2 |
| Context-Specific | 0 | P3 |

---

## Success Criteria

### Primary Success Criteria

- [ ] [SC-001] [Primary success criterion]
- [ ] [SC-002] [Primary success criterion]
- [ ] [SC-003] [Primary success criterion]

### Secondary Success Criteria

- [ ] [SC-004] [Secondary success criterion]
- [ ] [SC-005] [Secondary success criterion]

---

## Test Cases

### Happy Path Tests

#### TC-001: [Descriptive Test Name]

**Priority**: P1
**Category**: Happy Path
**Success Criteria**: SC-001

**Context**: When user is on [specific page/state] with [specific conditions]

**Given**:
- User is authenticated as [role]
- User is on [specific page]
- [Relevant data state]

**When**:
- User [performs specific action]

**Then**:
- [Expected outcome 1]
- [Expected outcome 2]

**Verification**:
- [ ] [Specific check 1]
- [ ] [Specific check 2]

---

### Error Handling Tests

#### TC-002: [Error Scenario Name]

**Priority**: P1
**Category**: Error Handling

**Context**: When user [trigger condition]

**Given**:
- [Setup conditions]

**When**:
- User [action that triggers error]

**Then**:
- Error message "[Exact expected message]" is displayed
- User can [recovery action]
- Data is [not corrupted/preserved]

**Verification**:
- [ ] Error message is clear and actionable
- [ ] User can recover from error

---

### Edge Case Tests

#### TC-003: [Edge Case Name]

**Priority**: P2
**Category**: Edge Case

**Context**: When [unusual but valid condition]

**Given**:
- [Unusual precondition]

**When**:
- User [action]

**Then**:
- System handles gracefully
- [Expected behavior]

**Why this matters**: [Potential impact if not handled]

---

### Boundary Condition Tests

#### TC-004: [Boundary Test Name]

**Priority**: P2
**Category**: Boundary

**Boundaries to Test**:

| Boundary | Value | Expected Result |
|----------|-------|-----------------|
| Minimum | [value] | [result] |
| Maximum | [value] | [result] |
| Just below min | [value] | [result] |
| Just above max | [value] | [result] |

---

## Behavioral Specifications

### When user does X, Y should happen

| User Action | Expected Behavior | Context |
|-------------|-------------------|---------|
| [Action 1] | [Behavior 1] | [Page/State] |
| [Action 2] | [Behavior 2] | [Page/State] |
| [Action 3] | [Behavior 3] | [Page/State] |

---

## Context-Aware Scenarios

### Scenario Matrix

| Context Variable | Options | Impact on Behavior |
|-----------------|---------|-------------------|
| User State | Logged in / Guest | [How behavior differs] |
| Device | Desktop / Mobile | [How behavior differs] |
| Data State | Empty / Populated | [How behavior differs] |
| Network | Online / Offline | [How behavior differs] |

---

## Error States Summary

| Error Trigger | Error Message | Recovery Path |
|--------------|---------------|---------------|
| [Trigger 1] | "[Message]" | [How to recover] |
| [Trigger 2] | "[Message]" | [How to recover] |

---

## Test Execution Log

| Test ID | Date | Tester | Result | Notes |
|---------|------|--------|--------|-------|
| TC-001 | | | Pass/Fail | |
| TC-002 | | | Pass/Fail | |

---

## Revision History

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.0 | [Date] | [Author] | Initial draft |
