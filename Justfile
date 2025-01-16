_default:
    @just --list

bibtox := "uv run --directory ~/u/src/python/bibtox bibtox -"
latex := "latexmk -pdflua"
target := "publications"
droppings := "*-blx.bib *.bbl *.run.xml *.xdv *.fls _region_.tex *.out *.aux *-SAVE-ERRORwork"

# remove droppings
@clean:
    {{latex}} -c {{target}}
    rm -f {{droppings}}

# remove outputs
@distclean: clean
    {{latex}} -C {{target}}
    # rm -rf auto

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
sort tgt:
    # cat strings.bib {{tgt}} | bib2bib --no-comment -r -s date > {{tgt}}.sorted
    cat strings.bib {{tgt}} | {{bibtox}} --sort > {{tgt}}.sorted
    [ ! -z "{{tgt}}.sorted" ] && mv {{tgt}}.sorted {{tgt}}

# format and sort all bibtex files
@sort-all:
    for f in rmm-*.bib; do just sort $f ; done

# build publications list
@pdf:
    {{latex}} {{target}}
