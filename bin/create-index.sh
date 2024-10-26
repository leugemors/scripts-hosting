#! /usr/bin/env bash
#############################################################################
##
##  Create a nice index for all my notes, for use with vimwiki.
##
#############################################################################

set -eu

pushd ~/Notes

{
    # Function to handle every Markdown file in the directories
    import_dir() {
        chapter=$1
        notes=$(ls "${chapter}")
        echo -e "\n## ${chapter^}\n" # First letter is a capital
        for note in ${notes}; do
            echo "- [${note%.*}](${chapter}/${note%.*})" # Remove extention
        done
    }

    dirs=$(ls -d ./*/)

    # Header
    echo -e "# Index\n"
    echo -e "This automatically created index is mainly for use with VimWiki."

    # Do the work
    for dir in ${dirs}; do
        import_dir "${dir%/*}" # Remove ending slash
    done

    # Footer
    echo -e "\n## Help :-)\n"
    echo -e "- [markdown](markdown) - markdown cheatsheet\n"

} | tee index.md

popd

### eof #####################################################################
