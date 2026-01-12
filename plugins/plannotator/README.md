# Plannotator Plugin

Interactive plan review tool for AI coding agents with visual annotation and team collaboration.

## Installation

This plugin requires a pre-install step:

### Step 1: Install plannotator command

**macOS / Linux / WSL:**
```bash
curl -fsSL https://plannotator.ai/install.sh | bash
```

**Windows PowerShell:**
```powershell
irm https://plannotator.ai/install.ps1 | iex
```

### Step 2: Install the plugin

```bash
/plugin marketplace add backnotprop/plannotator
/plugin install plannotator@plannotator
```

**IMPORTANT:** Restart Claude Code after plugin installation.

## Features

- **Visual Markup Tools** - Annotate images with pen, arrow, and circle tools
- **Plan Management** - Delete, insert, replace, or comment on agent plans
- **Approval Workflow** - Approve plans to proceed or request changes with structured feedback
- **Note Integration** - Auto-save approved plans to Obsidian and Bear Notes
- **Team Sharing** - Share annotated plans with team members

## How It Works

When an AI agent completes a plan, Plannotator opens a browser interface where you can:
1. Visually review the plan
2. Add annotations and comments
3. Modify plan steps (delete, insert, replace)
4. Approve to proceed with implementation
5. Or send back feedback for the agent to revise

## Links

- [Website](https://plannotator.ai)
- [GitHub Repository](https://github.com/backnotprop/plannotator)
