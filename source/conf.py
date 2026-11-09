project = "Family Server Configuration"
author = "Carlos Lopez"

extensions = [
    "myst_parser",
    "sphinxcontrib.mermaid",
    "sphinx_copybutton",
    "sphinx_design",
]

myst_fence_as_directive = [
    "mermaid",
]

source_suffix = {
    ".rst": "restructuredtext",
    ".md": "markdown",
}

master_doc = "index"

html_theme = "sphinx_rtd_theme"
html_static_path = ["_static"]

html_css_files = [
    "custom.css",
]

exclude_patterns = [
    "_build",
    "Thumbs.db",
]
