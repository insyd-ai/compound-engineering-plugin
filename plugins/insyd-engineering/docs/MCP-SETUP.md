# MCP Server Setup Guide

This plugin includes 7 MCP (Model Context Protocol) servers for enhanced development workflows.

## Included MCP Servers

| Server | Type | Purpose |
|--------|------|---------|
| `pw` (Playwright) | stdio | Browser automation and testing |
| `context7` | http | Framework documentation (100+ libraries) |
| `convex` | stdio | Convex backend operations |
| `linear` | stdio | Linear issue tracking |
| `github` | http | GitHub repository operations |
| `shadcn` | stdio | shadcn/ui component registry |

## Authentication Setup

### GitHub MCP

Requires a GitHub Personal Access Token (PAT):

1. Create PAT at: https://github.com/settings/tokens
2. Required scopes: `repo`, `read:org`
3. Set environment variable:
   ```bash
   export GITHUB_PAT="ghp_your_token_here"
   ```

### Linear MCP

Uses OAuth authentication:

1. After plugin installation, run `/mcp` in Claude Code
2. Select "linear" from the list
3. Click "Authenticate" and complete OAuth flow
4. Grant requested permissions


## Verification

After setup, verify all MCPs are connected:

```bash
claude mcp list
```

Or use `/mcp` in Claude Code to see connection status.

## Troubleshooting

### Linear OAuth Issues

```bash
# Clear cached authentication
rm -rf ~/.mcp-auth
# Then retry authentication via /mcp
```

### GitHub Connection Issues

Verify your PAT is set:
```bash
echo $GITHUB_PAT
```

### General Issues

1. Restart Claude Code
2. Run `claude mcp list` to check status
3. Try disabling and re-enabling the server via `/mcp`
