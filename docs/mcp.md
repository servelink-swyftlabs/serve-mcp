# MCP tools

MCP is serve's primary interface. A bare `serve` runs an MCP server over stdio,
so agents create and manage links natively — no shelling out, no parsing CLI
output. (`serve mcp` is the explicit form.)

## Registering it

```json
{
  "mcpServers": {
    "serve": {
      "command": "serve"
    }
  }
}
```

Works with Claude Code, Cursor, opencode, and anything else that speaks MCP. A
logged-in install needs no arguments: the server resolves its relay the same
way the CLI does (flags, then environment, then `~/.serve.toml`, then the
hosted default).

## The tools

Seventeen tools, all returning structured JSON.

**Creating links**

- `serve(port, name?, protect?, ttl?, residency?, replace?)` — create a link
  from a running dev-server port. Called without `name`, it reuses an unbound
  link you already own. `name=` claims a Pro named subdomain. `residency="remote"`
  publishes the bytes to serve's servers instead of tunneling. `protect=true`
  turns on Pro password protection, with `ttl` between `1h` and `30d`
  (defaulting to `24h`). `replace=true` resolves a residency conflict. Returns
  the public URL once the link is live.
- `serve_file(path, …)` — the same tool for a file or directory. Takes every
  argument `serve` does.
- `stop_remote(label)` — unpublish a remote link and delete its bytes.

**Inspecting**

- `list_tunnels` — what's live right now.
- `tunnel_status(port or label)` — the state of one link.
- `links` — everything the account owns.
- `account_status` — plan, and usage across links, live tunnels, storage,
  transfer, and publish rate.

**Tearing down**

- `stop_tunnel(port or label)`, `stop_all_tunnels` — close live tunnels.
- `release_link(label)` — give up a link you no longer want.

**Protecting**

- `protect_link`, `unprotect_link`, `update_ttl` — turn protection on and off,
  and change how long it lasts.
- `renew_link` — rotate the credentials.
- `revoke_link` — cut off existing viewers immediately.
- `create_viewer_grant` — hand one viewer access without sharing a password.

**Diagnosing**

- `doctor` — self-diagnostics, same checks as the CLI.

## Why the results look the way they do

Every tool result embeds a `usage` snapshot and machine-branchable error codes.
That's deliberate: an agent should always be able to answer "what do I own,
what's running, and what am I still allowed to do" without a second round trip
or any string parsing. When a call is refused, the code tells the agent whether
to wait, release something, or tell you to upgrade.
