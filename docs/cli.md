# serve CLI reference

The CLI is the manual-drive surface. Everything here is also available to your
agent over MCP — see [MCP tools](mcp.md) — and most days you'll use that
instead.

A bare `serve` with no arguments runs the MCP server over stdio. Every command
below is an explicit override of that default.

## Authorizing a device

```bash
serve login                 # opens your browser at the activation page
serve login --no-browser    # prints a URL + XXXX-XXXX code instead (e.g. over SSH)
serve logout                # clears credentials from ~/.serve.toml
```

`serve login` runs an OAuth 2.0 device flow. Your CLI posts a device public
key, you confirm the code, and the relay will only accept registrations from a
key bound to your account.

## Serving from your machine

```bash
serve 3000                     # tunnel localhost:3000
serve 3000 --json              # machine-readable output
serve 3000 --name myapp        # request a specific subdomain (Pro)
serve 3000 --protect --ttl 3d  # password-protect the link (1h–30d, Pro)
serve 3000 --open              # open a browser with an owner bypass grant
```

## Publishing to serve's servers

Published links keep working with your machine off.

```bash
serve remote ./dist              # publish a build folder
serve remote ./dist --replace    # republish over an existing link (Pro)
serve remote stop <label>        # unpublish and delete the stored bytes
```

## Managing links and your account

```bash
serve whoami                      # plan, budget, and every active URL
serve links                       # list owned links (live / stale / remote)
serve release <label>             # free a link you're not using
serve protect <label> --ttl 24h   # turn on password protection (Pro)
serve unprotect <label>           # clear protection
serve renew <label>               # rotate protection credentials
serve revoke <label>              # revoke viewer credentials immediately
serve doctor                      # self-diagnostics: account, relay, UDP 443
```

## Configuration

Resolution order is flags, then environment variables, then the config file,
then the hosted defaults.

| Flag | Environment variable | `~/.serve.toml` |
|---|---|---|
| `--account-url` | `SERVE_ACCOUNT_URL` | `account_url:` |
| `--api-token` | `SERVE_API_TOKEN` | `api_token:` |
| `--identity` | `SERVE_IDENTITY` | `identity:` |

`serve login` writes `~/.serve.toml` for you, so you rarely touch it by hand:

```yaml
api_token: sv1_...
relay: https://account-api.servelink.cc
account_url: https://account-api.servelink.cc
```

On first run the client also creates an Ed25519 identity key at
`~/.serve/identity` (PKCS#8 PEM, owner-only permissions). That key binds this
device to your account and signs every register request and QUIC bind
handshake. A different key can never take over your subdomain or evict a live
tunnel.

The `--relay` and `--auth-token` flags are an internal development affordance
and are deliberately undocumented. The hosted relay is the only supported
mode.

## When something doesn't work

See [Troubleshooting](troubleshooting.md). `serve doctor` covers the common
causes on its own, including whether your network lets QUIC out over UDP 443.
