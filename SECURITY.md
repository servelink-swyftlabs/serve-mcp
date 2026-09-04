# Security

## Reporting a vulnerability

Email **serve@servelink.cc** with enough detail to reproduce the issue: what you
did, what you observed, and what you expected instead.

Please don't open a public issue for a suspected vulnerability, and please don't
test against links or accounts that aren't yours. There is no bug bounty.

## Reporting abuse, which is a different mailbox

Content published through a serve link — a phishing page, malware, anything the
[Acceptable Use Policy](https://servelink.cc/legal/acceptable-use-policy)
prohibits — goes to **abuse@servelink.cc**. That mailbox handles takedown
requests and enforcement appeals; `serve@servelink.cc` handles security, support,
privacy and legal notices.

## Scope

serve is a hosted service with a closed-source client. In scope: the relay and
account API on `servelink.cc`, the hosted MCP connector at `mcp.servelink.cc`,
the console, and the published client — `@servelink/serve` on npm and the formula
in [servelink-swyftlabs/homebrew-tap](https://github.com/servelink-swyftlabs/homebrew-tap).

This repository carries manifests, skills and documentation only; the
implementation repository is private.

## Versions

Fixes ship forward in the next client release rather than as patches to older
ones, so the latest release is the supported one. Releases are published at
[servelink-swyftlabs/serve-dist](https://github.com/servelink-swyftlabs/serve-dist),
each with a `checksums.txt` you can verify a download against.

## One thing to know before reporting it

The relay terminates TLS, so it can see tunnelled traffic in plaintext. That is
disclosed in the [Privacy Policy](https://servelink.cc/legal/privacy-policy) and
the [Terms of Service](https://servelink.cc/legal/terms-of-service) rather than
being a finding — don't tunnel anything you would rather we were not technically
able to see.
