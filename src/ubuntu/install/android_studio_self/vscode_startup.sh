#!/usr/bin/env bash
sudo /app/code-server/bin/code-server \
                --install-extension /root/.local/share/dw.vsix \
                --extensions-dir /root/extensions

sudo /app/code-server/bin/code-server \
                --bind-addr 0.0.0.0:8443 \
                --user-data-dir /root/data \
                --extensions-dir /root/extensions \
                --disable-telemetry \
                --auth "none" \
                "${DEFAULT_WORKSPACE:-/config/workspace/code}"
