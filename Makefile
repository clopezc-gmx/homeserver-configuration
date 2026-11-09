SPHINXBUILD ?= sphinx-build
SOURCEDIR    = build/tmp
BUILDDIR     = build

.PHONY: html clean serve linkcheck index stage

# Copy source/ to build/tmp and substitute the @@KEY@@ markers.
stage:
	@bash ./build.sh

index: stage
	@echo "# Main Page" > $(SOURCEDIR)/index.md
	@echo "" >> $(SOURCEDIR)/index.md
	@echo '```{toctree}' >> $(SOURCEDIR)/index.md
	@echo ':maxdepth: 2' >> $(SOURCEDIR)/index.md
	@echo "" >> $(SOURCEDIR)/index.md
	@for f in $(SOURCEDIR)/*.md; do \
		[ "$$(basename "$$f")" = "index.md" ] || \
		echo "$${f#$(SOURCEDIR)/}" | sed 's/\.md$$//' >> $(SOURCEDIR)/index.md; \
	done
	@echo '```' >> $(SOURCEDIR)/index.md

html: index
	$(SPHINXBUILD) -b html $(SOURCEDIR) $(BUILDDIR)/html

clean:
	rm -rf $(BUILDDIR)

serve: html
	python3 -m http.server 4444 --bind 127.0.0.1 --directory $(BUILDDIR)/html

linkcheck: index
	$(SPHINXBUILD) -b linkcheck $(SOURCEDIR) $(BUILDDIR)/linkcheck
