VERSION = 1.0.0

jsoncount: jsoncount_version.ml jsoncount.ml
	ocamlfind ocamlopt -o jsoncount -annot \
		-package unix,yojson -linkpkg \
		jsoncount_version.ml jsoncount.ml

jsoncount_version.ml: Makefile
	echo 'let version = "$(VERSION)"' > jsoncount_version.ml

ifndef PREFIX
PREFIX = $(HOME)
endif

ifndef BINDIR
BINDIR = $(PREFIX)/bin
endif

.PHONY: install uninstall
install:
	@if [ -f $(BINDIR)/jsoncount ]; \
	  then echo "Error: run '$(MAKE) uninstall' first."; \
	  else \
	    echo "Installing jsoncount into $(BINDIR)"; \
	    cp jsoncount $(BINDIR); \
	fi

uninstall:
	rm $(BINDIR)/jsoncount

.PHONY: clean
clean:
	rm -f *.cm[iox] *.o *.annot *~ jsoncount jsoncount_version.ml
