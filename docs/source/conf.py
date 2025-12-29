# Sphinx configuration for ReadTheDocs template using MyST (Markdown)
import os
import sys

project = 'ReadTheDocs puch'
author = 'odelayIO'
release = '0.1'

extensions = [
    'myst_parser',
    'sphinx_rtd_theme',
]

# Recognize Markdown files
source_suffix = {
    '.rst': 'restructuredtext',
    '.md': 'markdown',
}

master_doc = 'index'

# Paths
templates_path = ['_templates']
exclude_patterns = ['_build']

html_theme = 'sphinx_rtd_theme'
html_static_path = ['_static']

# Theme options for Read the Docs theme
html_theme_options = {
    'collapse_navigation': False,
    'sticky_navigation': True,
    'navigation_depth': 4,
}

# Site-wide logo and title
# Place a `logo.svg` or other image file in `docs/source/_static`
html_logo = '_static/puch-logo-1-transparent.png'
html_title = f"{project} Documentation"
html_short_title = project

# Optional MyST settings
myst_enable_extensions = [
    'deflist',
    'html_admonition',
    'html_image',
]


