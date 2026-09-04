# serve

**You already ask your AI to make things. Now ask it to share them.**

[![smithery badge](https://smithery.ai/badge/hello-s6b0/serve)](https://smithery.ai/servers/hello-s6b0/serve)

```
you:      "serve me this"
Claude:   → https://lively-bison-4821.servelink.cc
```

That's the product. You say a sentence, and the thing you just made has a
real URL — one you can text to a friend, drop into a Slack thread, or put on
a slide. It works the same whether you built a Next.js app or asked for a
sales deck, because serve doesn't care what the thing is. It only cares that
you want someone else to see it.

**serve is a hosted service.** Create an account, log in once, and your links
live at `*.servelink.cc`.

> **About this repository.** This is the public listing and configuration home
> for serve: the MCP registry manifest, the Claude Code plugin manifest, and the
> user documentation. serve is a commercial hosted service and its
> implementation repository is private. Everything you need to *use* serve is
> here or on npm — there is no build step, and nothing here needs compiling.

---

## A link can live in two places

Every serve link is either **live from your machine** or **kept alive on
ours**.

- **Live from your machine.** The link points at whatever is running on your
  computer right now. Change a heading and the person holding the link sees
  the new heading. Close your laptop and the link goes quiet. (Under the hood
  this is a tunnel; your agent opens it for you.)
- **Kept alive on ours.** We hold a copy on serve's servers. Your laptop can
  be shut, asleep, or in a bag at the airport, and the link still opens.

You don't choose up front, and you're never stuck with the choice. "Serve
this so my teammate can watch while I work on it" gives you the first one.
"Keep it up so they can read it tomorrow" gives you the second. Same link,
same URL, one sentence apart.

That switch is the part people don't expect. Everywhere else, "let someone
see what's on my laptop" and "put this on the internet" are two different
products with two different setups, and moving between them is a project.
Here they're two ways of phrasing the same request.

## You never operate it — your agent does

serve's real interface isn't the terminal. It's MCP, the protocol AI agents
already speak, which means making a link isn't a task you go and do. It's
something you mention. Your agent creates the link, tells you the URL, puts
a password on it if you ask, and takes it down when you're finished. There's
a CLI too, and it's a good one, but it's there for the times you'd rather
drive manually.

This is also why serve isn't only for developers. If you can get Claude to
build you a dashboard, you can get Claude to hand you the link to it. The
skill it takes to share the thing is the one you already used to make it.

## Quick start

```bash
npm i -g @servelink/serve     # npm is the primary channel
serve login                   # opens your browser to confirm
```

Then tell your agent it exists. Anything that speaks MCP will do — Claude Code,
Claude Desktop, Cursor, opencode:

```json
{
  "mcpServers": {
    "serve": {
      "command": "npx",
      "args": ["-y", "@servelink/serve"]
    }
  }
}
```

That's the whole setup. From here it's conversation: ask for a link, get a link.

If you installed globally with `npm i -g`, `"command": "serve"` with no `args`
works too and starts marginally faster.

Prefer Homebrew?

```bash
brew install servelink-swyftlabs/tap/serve
```

One account works across as many machines as you like.

## Claude Code plugin

This repository is also a Claude Code plugin marketplace, so you can skip the
JSON:

```bash
claude plugin marketplace add servelink-swyftlabs/serve-mcp
claude plugin install serve@servelink
```

Or point Claude Code at a local clone while you try it:

```bash
claude --plugin-dir ./serve-mcp
```

The plugin ships the MCP server configuration in [`.mcp.json`](.mcp.json) and
nothing else — no hooks, no agents, no code that runs on your machine beyond the
`serve` client itself.

## Things you can just ask for

None of these are commands. They're the kind of thing people actually say, and
the agent works out the rest.

> "Serve me this so I can check it on my phone."

> "Put the deck somewhere my client can open it, and password-protect it."

> "This link is going in an email, so make sure it still works next week."

> "Take down everything I've got open."

> "What am I sharing right now?"

From those, the agent decides whether the link should run from your machine or
from ours, claims the subdomain, sets protection, and tells you what it did. If
you've asked for something your plan doesn't cover, it says so rather than
half-doing it.

## What you get

- **Links you own for good.** A link is yours from the moment you make it —
  never recycled, never evicted, never expired to free up room. Reconnect a
  week later and it's the same URL, so a tab someone left open still works.
- **Names you can read out loud.** Every link gets something like
  `lively-bison-4821` instead of a hash. On Pro you can ask for a specific one
  and get `goldenfish.servelink.cc`.
- **A password whenever you want one** (Pro), on any link, lasting an hour or a
  month. Revoke it and the people already looking are out immediately.
- **Real applications, not just static files.** Streaming responses,
  server-sent events, WebSockets, big downloads, and the fifteen-odd parallel
  requests a modern page fires the moment it loads.
- **It works from wherever you are.** Your machine dials outward, so home NAT,
  office firewalls, and hotel WiFi are all fine. No inbound port, no router
  settings, nothing to ask IT for.
- **A free tier with actual numbers in it** — 2 GB of transfer a month and 3
  live links at once — rather than a meter that surprises you later.

Underneath, it's QUIC end to end with per-stream flow control and real
backpressure, and WebSocket upgrades that only report success once your local
server has genuinely accepted the connection.

## Free vs Pro

Two words worth pinning down, because the plans are built on them. A **link**
is a URL you own. A **tunnel** is a link that's live right now. You can own any
number of links on either plan; what the plans limit is how many run at once
and how much traffic they carry.

| | Free | Pro |
|---|---|---|
| Price | $0 | $9.99/month |
| Links you own | Unlimited | Unlimited |
| Live at the same time | 3 | 10 |
| Largest single publish | 100 MB | 1 GB |
| Total stored | 1 GB | 50 GB |
| Transfer per month | 2 GB | 25 GB |
| Views on a published link | Unlimited\* | Unlimited\* |
| Password protection | — | Any link, any duration |
| Pick your own subdomain | — | Yes |
| Analytics | Opens | Opens, bytes, referrer, country |
| Publishes per hour / day | 30 / 100 | 300 / 1,000 |

\* No per-link view cap and no per-viewer bandwidth quota. If traffic across
the whole service ever threatens the monthly infrastructure budget, serve may
pause new requests until it resets. Reaching a limit never deletes anything —
your links and everything in them stay yours.

## How serve compares

Tunnel tools move bytes, and a few of them gate or meter those bytes. None of
them put a conversation in front.

| | serve | ngrok free | Cloudflare Tunnel | Tailscale |
|---|---|---|---|---|
| Public HTTPS URL for anyone | **Yes** | Yes | Yes | Funnel only¹ |
| Your agent drives it (MCP) | **Yes** | No | No | No |
| Hosts as well as tunnels | **Yes** | No | No | No |
| Stable subdomain, free | **Yes** | Paid | — | — |
| Streaming responses, free | **Yes** | Paid | — | — |
| Free tier with stated caps | **Yes** | Metered | Limited | — |
| Behind NAT, no open port | **Yes** | Yes | Yes | Yes |

¹ Tailscale gives you a private mesh — your own devices reaching one another.
Handing a URL to somebody outside it needs Funnel, a separate feature.

The rows undersell it, though. Everywhere else, "let someone see my laptop" and
"host this properly" are two different products you'd choose between. Here
they're one link and a setting, and the setting is a sentence.

## Security, and one thing you should know

- **Your device is bound to your account.** `serve login` runs an OAuth 2.0
  device flow, and the relay only accepts links from a key that's already
  yours.
- **Every request is signed.** Your machine holds an Ed25519 key at
  `~/.serve/identity` (mode 0600) that signs each registration and bind. A
  subdomain belongs to that key, so nobody else can claim it or knock a live
  tunnel offline — knowing your URL isn't enough.
- **Revocation is fast.** Revoke a device in the dashboard and new binds stop
  immediately; live tunnels drop as the revocation reaches the relay.
- **The relay terminates TLS.** This is the one we'd rather you heard from us:
  because serve's relay presents the certificate for `*.servelink.cc`, it can
  see tunneled traffic in plaintext. Don't tunnel production secrets or
  anything you'd rather we weren't technically able to see. Published (hosted)
  links are files you handed us on purpose, so the same applies to them by
  definition.
- **QUIC-only, UDP 443, no fallback.** If your network blocks outbound UDP,
  serve fails clearly instead of degrading. `serve doctor` tells you in one
  command.

## Documentation

- [Getting started](docs/getting-started.md) — the walkthrough, from install to
  your first link
- [CLI reference](docs/cli.md) — every command, its flags, and config precedence
- [MCP tools](docs/mcp.md) — all seventeen, and what their results carry
- [Preview modes](docs/preview-modes.md) — production vs HMR, and how to read a
  WebSocket failure
- [Troubleshooting](docs/troubleshooting.md) — or just run `serve doctor`

```
Viewer → HTTPS → relay (QUIC edge, UDP 443)
                    │
                    ▼
           relay coordinator (hosted)
                    ▲
                    │ QUIC streams (ALPN serve-tunnel/2)
                    │
          your machine → localhost:PORT
```

Your client registers with the hosted control plane and then dials **out** over
UDP 443, which is why nothing needs an inbound port. Viewer requests and
WebSockets map onto dedicated QUIC streams with end-to-end backpressure.
Transport v2 is QUIC-only — no WebSocket fallback and no HTTP/2 downgrade — so a
version mismatch fails loudly instead of quietly retrying.

## What's in this repository

```
README.md              what you're reading
server.json            MCP registry manifest (cc.servelink/serve)
.claude-plugin/        Claude Code plugin + marketplace manifests
.mcp.json              MCP server configuration the plugin installs
docs/                  user documentation
LICENSE                proprietary notice
```

No product source. The `serve` client is distributed as a signed binary through
npm and Homebrew; the relay, account API and worker are hosted components.

## Links

- Website — [servelink.cc](https://servelink.cc)
- npm — [`@servelink/serve`](https://www.npmjs.com/package/@servelink/serve)
- Homebrew — `servelink-swyftlabs/tap/serve`
- Support — [serve@servelink.cc](mailto:serve@servelink.cc)

## License

Proprietary — all rights reserved. See [LICENSE](LICENSE). The documentation and
manifests in this repository are published so that serve can be listed,
installed and understood; that publication is not a grant of rights over the
serve software or service.





