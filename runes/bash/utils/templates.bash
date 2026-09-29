#!/bin/bash

template::rustfmttoml() {
    cp -v "$SPELLS/runes/rustfmt.toml" .
}

template::latex-git-ignore() {
    cat <<EOF
*.toc
*.aux
*.log
*.pdf
*.html
*.bbl
*.blg
_minted-presentation/
*.nav
*.out
*.snm
*.vrb
EOF
}
