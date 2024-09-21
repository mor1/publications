_default:
	@just --list

latexmk := "latexmk -xelatex"

# aggressively remove build droppings
@distclean:
    {{latexmk}} -C
    rm -rf auto

# remove build droppings
@clean:
    {{latexmk}} -c
    rm -f *.run.xml *.xdv *.bbl

# publish PDFs to GitHub
@publish:
	git stash

	git checkout gh-pages
	git checkout master pdf
	git add pdf/*.pdf
	git commit -m "pdf: sync to master" pdf/ || true
	git push

	git checkout master
	git stash pop -q || true

# format and sort all bibtex files
@sort tgt:
    bib2bib -r -s date {{tgt}} > {{tgt}}.sorted
    [ ! -z "{{tgt}}.sorted" ] && mv {{tgt}}.sorted {{tgt}}

# build publications list
@build:
    {{latexmk}} publications
