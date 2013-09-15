TEXINPUTS := .:
BIBINPUTS := .:
BSTINPUTS := .:

PDFLATEX = xelatex

all: publications.pdf

%.pdf: %.tex $(wildcard *.bib)
	$(PDFLATEX) $*
	-bibtex $*
	-for f in *.aux; do bibtex $${f#.aux} ; done
	if [ -e $*.toc ] ; then $(PDFLATEX) $* ; fi
	if [ -e $*.bbl ] ; then $(PDFLATEX) $* ; fi
	if egrep Rerun $*.log ; then $(PDFLATEX) $* ; fi
	if egrep Rerun $*.log ; then $(PDFLATEX) $* ; fi
	if egrep Rerun $*.log ; then $(PDFLATEX) $* ; fi
	$(RM) *.aux *.log *.bbl *.blg *.toc *.dvi *.out

clean:
	$(RM) *.aux *.blg *.toc *.dvi *.out _region_.tex *.log
	$(RM) publications.pdf

all.bib: strings.bib rmm-*.bib
	cat strings.bib rmm-*.bib >| all.bib
