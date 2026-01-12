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

## Data Storage

All data is stored in `~/.claude-mem/` by default (configurable via `CLAUDE_MEM_DATA_DIR` setting):

| File/Directory | Description |
|----------------|-------------|
| `settings.json` | Configuration settings (auto-generated on first run) |
| `claude-mem.db` | SQLite database (FTS5) for sessions, observations, and summaries |
| `worker.port` | Current worker service port |
| `logs/` | Worker logs (`worker-out.log`, `worker-error.log`) |

The worker service runs on port 37777 with a web viewer UI at http://localhost:37777.

## Requirements

- Node.js >=18.0.0
- Bun (auto-installed)
- uv Python package manager (auto-installed)

## Configuration

Settings stored in ~/.claude-mem/settings.json (auto-generated on first run).
