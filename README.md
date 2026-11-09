# Home Server Documentation

Documentation of a Debian-based home server: network, backups, VPN, Nextcloud, Home Assistant, Jellyfin and more. Built with [Sphinx](https://www.sphinx-doc.org/) and MyST Markdown.

> **Status: work in progress.** The documentation is being converted from a private version: real values are being replaced by `@@NAME@@` markers section by section, an inconsistencies are being fixed.

The raw documentation is [`source/documentation.md`](source/documentation.md). It can be read directly on GitHub, but site-specific values appear as `@@NAME@@` markers (for example `@@SSH_PORT@@`) and a few features (`literalinclude` scripts, dropdowns, cross-references) only render in the built HTML.

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
#1. Run the initialization script
./initial_setup.sh

# 2. Provide your own values for the @@NAME@@ markers
cp server.conf.example source/server.conf
$EDITOR server.conf

# 3. Run the build script. Generates the HTML into build/html
./build.sh

# 4. Serve it locally 
./deploy.sh
```

`make html` reads `server.conf` and replaces every `@@NAME@@` marker with its value in a staged copy of `source/`; the files in the repository are never modified. The build fails if a marker has no value.

Other targets: `make clean` removes `build/`, and `make linkcheck` checks external links.

## Notes

- `server.conf` holds real values for one specific server. It is listed in `.gitignore`.
