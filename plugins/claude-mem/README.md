# Claude-Mem Plugin

Memory and context persistence for Claude Code sessions.

## Installation

This plugin requires external installation:

```bash
/plugin marketplace add thedotmack/claude-mem
/plugin install claude-mem
```

Restart Claude Code after installation.

## Features

- Automatic session capture via lifecycle hooks
- AI-powered context compression
- Semantic search via Chroma vector database
- SQLite persistence for sessions and observations
- mem-search skill for natural language memory queries

## Requirements

- Node.js >=18.0.0
- Bun (auto-installed)
- uv Python package manager (auto-installed)

## Configuration

Settings stored in ~/.claude-mem/settings.json (auto-generated on first run).
