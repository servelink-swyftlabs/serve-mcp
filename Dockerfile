# Runs serve as an MCP server over stdio, with no account and no configuration.
#
# This exists for registries and scanners that verify a server by starting it in
# a container and issuing MCP introspection calls. `tools/list` answers without
# credentials; the tools themselves need `serve login`, which is a browser flow
# and deliberately not something an image can do.
#
# serve is a Go binary distributed through npm platform packages, so npm picks
# the right one for the build platform. The version is pinned to match
# `server.json`; bump both together on release.
#
#   docker build -t serve-mcp .
#   docker run --rm -i serve-mcp
FROM node:22-bookworm-slim

RUN npm install -g @servelink/serve@0.8.3 \
    && npm cache clean --force

# Nothing here needs root, and the config the CLI writes belongs to the user.
USER node
ENV HOME=/home/node

ENTRYPOINT ["serve", "mcp"]
