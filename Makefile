#
# Copyright (c) 2012--2015 Richard Mortier <mort@cantab.net>
#
# Permission to use, copy, modify, and distribute this software for any purpose
# with or without fee is hereby granted, provided that the above copyright
# notice and this permission notice appear in all copies.
#
# THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH
# REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY
# AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT,
# INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM
# LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR
# OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR
# PERFORMANCE OF THIS SOFTWARE.
#

TEXINPUTS := .:/Users/mort/src/tex:
BIBINPUTS := .:/Users/mort/me/publications:
BSTINPUTS := .:/Users/mort/me/publications:/Users/mort/src/tex:
.EXPORT_ALL_VARIABLES: BIBINPUTS

LATEXMK = latexmk -xelatex

all: publications.pdf

%.pdf: %.tex $(wildcard *.bib)
	$(LATEXMK) $*

clean:
	$(LATEXMK) -c
	$(RM) *.run.xml *.xdv

distclean:
	$(LATEXMK) -C
	$(RM) *.bbl all.bib
	$(RM) -r auto

all.bib: $(wildcard *.bib)
	cat strings.bib rmm-*.bib >| all.bib

publish:
	git stash

	git checkout gh-pages
	git checkout master pdf
	git add pdf/*.pdf
	git commit -m "pdf: sync to master" pdf/ || true
	git push

	git checkout master
	git stash pop -q || true
