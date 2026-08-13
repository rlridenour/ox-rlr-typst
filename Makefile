EMACS ?= emacs
BATCH = $(EMACS) -Q --batch -L .

.PHONY: test compile regenerate clean

## Run the golden-file tests in test/.
test:
	$(BATCH) -l test/ox-rlr-typst-tests.el -f ert-run-tests-batch-and-exit

## Byte-compile, treating the package as the only load path entry.
compile:
	$(BATCH) -f batch-byte-compile ox-rlr-typst.el

## Rewrite test/expected/ from the current output; review the diff!
regenerate:
	$(BATCH) -l test/ox-rlr-typst-tests.el -f ox-rlr-typst-tests-regenerate

clean:
	rm -f *.elc
