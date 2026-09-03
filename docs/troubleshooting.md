# Troubleshooting

Start with `serve doctor`. It checks your account, the relay, and whether your
network lets QUIC out over UDP 443, which is the single most common blocker.

## Account and login

**`unauthorized` / `401`**
Your `api_token` is missing, expired, or revoked. Run `serve login` again, or
check the device list in the dashboard. `serve whoami` will tell you which of
"not logged in", "token revoked", and "service unreachable" you're hitting.

**"No relay configured"**
A logged-in install always has one. Run `serve login` to write the relay
binding, or set `SERVE_RELAY`.

## The link is up but doesn't work

**The URL returns 502**
The relay can't reach your local server. Confirm it's actually listening on the
port you passed — `curl http://localhost:3000` should work locally first.

**The URL returns 404**
Nothing is bound to that subdomain. Either it never connected, or it dropped
and hasn't re-registered. Restart `serve`.

**The page loads but content stays on `Loading…`**
If this happens in production preview, it's an application defect and no tunnel
or HMR change will fix it. See [Preview modes](preview-modes.md).

## WebSockets

**It opens, then closes immediately, over and over (dev mode)**
Your dev framework rejected the preserved public Origin. Add your exact serve
hostname to its dev-origin allowlist — `allowedDevOrigins` for Next.js — and
restart. See [Mode B](preview-modes.md#mode-b--development-preview-with-hmr-opt-in).

**It gets a 502 before it ever opens**
Localhost refused the connection outright. Check the application's origin
policy and the port you passed. The full table of pre-101 status codes is in
[Preview modes](preview-modes.md#reading-a-websocket-failure).

## Network and transport

**A QUIC dial fails on the TLS handshake or ALPN**
The client connects over UDP 443 with ALPN `serve-tunnel/2`. A handshake
failure usually means something on your network interferes with UDP 443, or
your client and the relay are on different transport versions. There is no
fallback path by design, so upgrade both together.

**A QUIC dial times out**
UDP 443 is likely filtered by a network or host firewall, or your ISP blocks
outbound UDP. This is the most common corporate-network problem. `serve doctor`
confirms it.

## Limits

**A new tunnel fails with `tunnel_limit`**
You can run 3 simultaneous live tunnels on Free and 10 on Pro. The links
themselves are unlimited and are never recycled to make room, so a new tunnel
at the cap is simply refused rather than displacing anything. Stop one you
don't need, or `serve release <label>` a stale link.

**A request fails with `transfer_limit` or a `503`**
You've reached your monthly transfer allowance (2 GB on Free, 25 GB on Pro),
or the service hit its global transfer ceiling. Both reset at the start of the
UTC month, and the error carries the exact reset time. Nothing is deleted when
you hit a limit — links stay yours.
