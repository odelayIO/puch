# Minimal Makefile for Sphinx docs
SPHINXBUILD   = sphinx-build
SOURCEDIR     = source
BUILDDIR      = _build

.PHONY: html
html:
	$(SPHINXBUILD) -b html $(SOURCEDIR) $(BUILDDIR)/html
	@echo "Build finished. The HTML pages are in $(BUILDDIR)/html."

.PHONY: clean
clean:
	@echo "Removing build directory $(BUILDDIR) and temporary files..."
	@rm -rf $(BUILDDIR) .doctrees
	@echo "Clean finished."
