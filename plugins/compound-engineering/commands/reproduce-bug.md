---
name: reproduce-bug
description: Reproduce and investigate a bug using logs, console inspection, and browser screenshots
argument-hint: "[GitHub issue number]"
---

# Reproduce Bug Command

Look at github issue #$ARGUMENTS and read the issue description and comments.

## Phase 1: Codebase Investigation

Analyze the codebase to understand where the bug might be occurring:

1. **Read the issue carefully** - Understand the expected vs actual behavior
2. **Search the codebase** - Use Grep and Glob to find relevant files
3. **Trace the code path** - Follow the execution flow from entry point to where the bug occurs
4. **Check recent commits** - Use git history to see if recent changes might have introduced the bug

Think about the places it could go wrong looking at the codebase. Look for logging output we can look for.

## Phase 2: Visual Reproduction with Playwright

If the bug is UI-related or involves user flows, use Playwright to visually reproduce it:

### Step 1: Verify Server is Running

```
mcp__plugin_compound-engineering_pw__browser_navigate({ url: "http://localhost:3000" })
mcp__plugin_compound-engineering_pw__browser_snapshot({})
```

If server not running, inform user to start their dev server (e.g., `bun run dev`, `bun dev`, or similar).

### Step 2: Navigate to Affected Area

Based on the issue description, navigate to the relevant page:

```
mcp__plugin_compound-engineering_pw__browser_navigate({ url: "http://localhost:3000/[affected_route]" })
mcp__plugin_compound-engineering_pw__browser_snapshot({})
```

### Step 3: Capture Screenshots

Take screenshots at each step of reproducing the bug:

```
mcp__plugin_compound-engineering_pw__browser_take_screenshot({ filename: "bug-[issue]-step-1.png" })
```

### Step 4: Follow User Flow

Reproduce the exact steps from the issue:

1. **Read the issue's reproduction steps**
2. **Execute each step using Playwright:**
   - `browser_click` for clicking elements
   - `browser_type` for filling forms
   - `browser_snapshot` to see the current state
   - `browser_take_screenshot` to capture evidence

3. **Check for console errors:**
   ```
   mcp__plugin_compound-engineering_pw__browser_console_messages({ level: "error" })
   ```

4. **Check network requests for API errors:**
   ```
   mcp__plugin_compound-engineering_pw__browser_network_requests({})
   ```

### Step 5: Capture Bug State

When you reproduce the bug:

1. Take a screenshot of the bug state
2. Capture console errors
3. Document the exact steps that triggered it

```
mcp__plugin_compound-engineering_pw__browser_take_screenshot({ filename: "bug-[issue]-reproduced.png" })
```

## Phase 3: Document Findings

**Reference Collection:**

- [ ] Document all research findings with specific file paths (e.g., `src/components/Example.tsx:42`)
- [ ] Include screenshots showing the bug reproduction
- [ ] List console errors if any
- [ ] List failed network requests if any
- [ ] Document the exact reproduction steps

## Phase 4: Report Back

Add a comment to the issue with:

1. **Findings** - What you discovered about the cause
2. **Reproduction Steps** - Exact steps to reproduce (verified)
3. **Screenshots** - Visual evidence of the bug (upload captured screenshots)
4. **Relevant Code** - File paths and line numbers
5. **Suggested Fix** - If you have one
