#!/usr/bin/env sh
command -v git > /dev/null || {
    echo "Git needs to be installed"
    exit 1
}

command -v fzf > /dev/null || {
    echo "fzf needs to be installed (`brew install fzf`)"
    exit 1
}

command -v yq > /dev/null || {
    echo "yq needs to be installed (`brew install yq`)"
    exit 1
}

command -v jsonschema > /dev/null || {
    echo "yq needs to be installed (`pip install git+git://github.com/Julian/jsonschema@main`)"
    exit 1
}

FILES=$(git ls-files | grep deployment/project.yml | fzf --height=10 -m --bind ctrl-a:select-all,ctrl-d:deselect-all,ctrl-t:toggle-all)
for FILE in $FILES
do
    echo "▒ $FILE ▒" | sed 's/./▒/g'
    echo "▒ $FILE ▒"
    echo "▒ $FILE ▒" | sed 's/./▒/g'
    echo ""

    cat "$FILE" | yq | jsonschema ../mpl-modules/src/main/resources/nl/vandebron/jenkins/projects/project.schema.json -i /dev/stdin -o pretty
done
