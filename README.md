# Home Server Documentation

Documentation of a Debian-based home server: network, backups, VPN, Nextcloud, Home Assistant, Jellyfin and more. Built with [Sphinx](https://www.sphinx-doc.org/) and MyST Markdown.

> **Status: work in progress.**
> The documentation is being converted from a private version: real values are being replaced by `@@NAME@@` markers section by section, an inconsistencies are being fixed.
> Sections 1 - 4 now can be built and deployed.

The raw documentation is [`source/documentation.md`](source/documentation.md). It can be read directly on GitHub, but site-specific values appear as `@@NAME@@` markers (for example `@@SSH_PORT@@`) and a few features (`literalinclude` scripts, drop-downs, cross-references) only render in the built HTML.

## Repository layout

```text
source/
├── documentation.md     # the documentation (MyST Markdown)
├── configuration/       # scripts, systemd units and configs included by the documentation
└── conf.py              # Sphinx configuration
server.conf.example      # template with the values substituted for the @@NAME@@ markers
Makefile                 # build targets
requirements.txt         # Python dependencies
```

## Build

Requirements: Python 3 and `make`.

```bash
# Set repository path and/or add it in your .bashrc if needed
export HS_ROOT=$HOME/homeserver-configuration

# Run the initialization script
./initial_setup.sh

# Provide your own values for the @@NAME@@ markers
cp server.conf.example source/server.conf
$EDITOR server.conf

# Run the build script.
# 1. Replaces all @@NAME@@ with the corresponding values from $HS_ROOT/source/server.conf
# 2. Generates the HTML into build/html
./build.sh

# Serves it locally (by default in port 4444)
./deploy.sh
```

## Notes

- `server.conf` holds real values for one specific server and should not be committed.
