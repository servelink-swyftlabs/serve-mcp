# Preview modes

When you're tunneling a dev server, there are two ways to run the thing behind
the link, and they are not interchangeable. Pick per task.

## Mode A — production preview (the default, and what review needs)

Use this for anything a human is going to judge: charts, hydration-sensitive
UI, stakeholder demos, and any claim that the link represents a release build.
serve is a tunnel, so a production server speaks release-like over the link
exactly as it would in CI.

```bash
npm run build
npm run start -- --port <port>
serve <port> --json
```

Hot module reload is not needed here. And a page that returns HTTP 200 is not
yet a pass — confirm the visual smoke holds: nothing stuck on a loading
placeholder, expected output mounted, no hydration errors in the console.

If charts stay in a loading state in production mode, the defect is in the
application. A tunnel change won't fix it.

## Mode B — development preview with HMR (opt in)

Use this only when you genuinely need live source updates to reach the public
link.

```bash
npm run dev -- --port <port>
serve <port> --json
```

serve preserves the browser's `Origin` and never rewrites it, so an
origin-protected dev framework has to be told to trust your public hostname.
For Next.js, add the exact hostname and restart:

```ts
// next.config.ts
const nextConfig: NextConfig = {
  allowedDevOrigins: ["lively-bison-4821.servelink.cc"],
};
```

Three things trip people up here:

- `allowedDevOrigins` wants a **hostname**, not a URL with a scheme.
- It has to match your actual public serve address exactly.
- There is no flag, environment variable, or config setting that bypasses the
  framework's origin check, by design. If the framework rejects the origin,
  configure the framework.

Other frameworks have their own equivalent dev-origin policy.

## Reading a WebSocket failure

serve upgrades a viewer's WebSocket only after your local server accepts it, so
a browser is never told "connected" before localhost agrees. That makes the
status code a viewer sees *before* any 101 a precise signal about which
boundary failed.

| Before any 101 | What it means |
| --- | --- |
| `401` | The link is protected and the cookie or capability token is missing or invalid |
| `403` | The relay rejected the viewer's Origin |
| `404` | No live tunnel for that hostname |
| `502` | **Your local server refused the WebSocket** — a rejection or bad negotiation |
| `503` | The relay is busy, or an account or global transfer limit was reached |
| `504` | The local WebSocket open timed out |
| `101`, stable | Both handshakes accepted; you're through |

A `502` before any `101` is almost always the local application refusing the
connection — check its allowed-origin and dev-resource policy rather than
serve. A `101` immediately followed by a close is a regression signal worth
reporting.
