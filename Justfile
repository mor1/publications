_default:
    @just --list

latexmk := "latexmk -pdflua"

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

# format and sort a bibtex file
@sort tgt:
    cat strings.bib {{tgt}} | bib2bib --no-comment -r -s date > {{tgt}}.sorted
    [ ! -z "{{tgt}}.sorted" ] && mv {{tgt}}.sorted {{tgt}}

# format and sort all bibtex files
@sort-all:
    for f in rmm-*.bib; do just sort $f ; done

# build publications list
@pdf:
    {{latexmk}} publications
