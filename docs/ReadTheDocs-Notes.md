# ReadTheDocs Sphinx + Markdown template

<img src="https://app.readthedocs.org/projects/puch/badge/?version=latest" alt="Documentation Status">

Quick start

1. Create a virtualenv and activate it (optional but recommended):

```bash
python -m venv .venv
source .venv/bin/activate
```

2. Install requirements:

```bash
pip install -r requirements.txt
```

3. Build the docs locally:

```bash
make -C docs clean
make -C docs html
```

4. Open `docs/_build/html/index.html` in a browser.

Notes for Read the Docs

- This repository includes `.readthedocs.yml` which tells RTD to install `requirements.txt` and build using the Sphinx config at `docs/source/conf.py`.
- The documentation uses the ReadTheDocs theme; `requirements.txt` includes `sphinx-rtd-theme` so the theme will be installed automatically.
- Add your project-specific content to the Markdown pages in `docs/source/`.
