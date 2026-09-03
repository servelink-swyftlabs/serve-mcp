# Getting started with serve

This page walks you from nothing to a live public URL in under five minutes.
Create an account, install the CLI, and tell your agent it exists — everything
here works on the free tier.

---

## 1. Install

The quickest path is npm (no Go toolchain needed):

```bash
npm i -g @servelink/serve
# or, without a global install:
npx @servelink/serve
```

Alternates:

```bash
brew install servelink-swyftlabs/tap/serve
```

Check the installed version matches the release tag:

```bash
serve --version
```

## 2. Log in

```bash
serve login
```

This opens your browser at the dashboard activation page with the code
pre-filled. A URL and `XXXX-XXXX` code are printed as a fallback — use them
manually when the browser doesn't open (SSH, headless) or when you pass
`--no-browser`. Once confirmed, the CLI has a token and is ready.

## 3. Use it from an AI coding agent (MCP)

A bare `serve` starts the MCP server (this is the default entrypoint and the
primary interface). Register it in Claude Code, Cursor, opencode, etc.:

```json
{
  "mcpServers": {
    "serve": {
      "command": "serve"
    }
  }
}
```

The agent can then **"serve me this"** — a file, a directory, or an
already-running dev server — and hand back a public HTTPS URL like
`https://lively-bison-4821.servelink.cc` (one of your account's links).
Anyone with that URL can reach your local server.

## 4. Expose a local port (terminal)

From a terminal you can expose a local server directly. Point serve at a
local server:

```bash
serve login          # once, if you haven't already
serve 7000           # exposes http://localhost:7000 and prints the public URL
```

Stop it with `Ctrl-C`.

## 5. Publish instead, so the link outlives your session

A tunnel goes quiet when you close your laptop. If the link needs to keep
working, publish the files to serve's servers instead:

```bash
serve remote ./dist          # publish a build folder
serve remote stop <label>    # unpublish and delete the stored bytes
```

Your agent can do the same thing mid-conversation — ask it to keep the link up
rather than serve it live, and it publishes instead of tunneling. Both kinds of
link are the same kind of URL and belong to the same account.

---

## What the Free tier gives you

- **Unlimited published links** (pretty names like `lively-bison-4821`, minted on
  demand) with up to **3 simultaneous live tunnels**. At the cap a new tunnel is
  denied with a clear `tunnel_limit` — nothing is recycled or replaced to make
  room.
- Published deployments up to **100 MB** each, **1 GB** of total storage, and
  **2 GB of live-tunnel transfer per UTC month**.
- Publish up to **30 times an hour / 100 times a day**; each published link gets
  basic analytics (open count).
- The URLs are **public to anyone who has them** — there is no viewer
  authentication, expiry, or allowlist on Free. Names are not secrets.

## What Pro gives you

- Up to **10 simultaneous live tunnels** and **25 GB of live-tunnel transfer per
  UTC month**.
- Published deployments up to **1 GB** each and **50 GB** of total storage;
  publish up to **300 times an hour / 1,000 times a day**.
- **Password protection** on every owned link, with custom TTLs.
- **Named subdomains**: claim your own label via MCP `name=goldenfish`,
  auto-suffixed if the name is taken.
- Full link analytics: opens, bytes delivered, referrer host, and country.
- Link management: `serve links` lists what you own (live/stale),
  `serve release <label>` frees a stale link, and `serve whoami` shows your
  budget.

## Limitations you should know

- **Your network must allow outbound UDP 443.** serve is QUIC-only with no
  fallback. If a corporate network blocks outbound UDP, the service won't work
  — run `serve doctor` to check.
- **Live tunnels are capped, links are not.** An account owns an unlimited number of links; only simultaneous live tunnels are capped (Free 3, Pro 10). At the cap a new tunnel is denied with `tunnel_limit` — links are never recycled or replaced to make room, and a Free account can never lose a published link.
- **The relay sees traffic in plaintext after TLS termination.** Don't tunnel
  production credentials or secrets.
- **Clients older than the current release cannot connect at all.** The
  transport was upgraded, not deprecated in place; run `serve --version` and
  upgrade if needed.

## Support & abuse

- Problems: email `serve@servelink.cc` with the output of `serve doctor` and
  `serve --version`.
- Report abuse of the service (phishing, malware distribution) to
  `abuse@servelink.cc`.

Next steps: the [CLI reference](cli.md), the [MCP tools](mcp.md), the two
[preview modes](preview-modes.md) for dev servers, and
[troubleshooting](troubleshooting.md).
