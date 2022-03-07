#!/usr/bin/env bash
#############################################################################
##
##  simple bash script to pull all my git repos
##
#############################################################################

# ---------------------------------------------------------------------------
#  create a list of git repos in all sub directories
# ---------------------------------------------------------------------------

REPOS=$(find . -name .git)

# ---------------------------------------------------------------------------
#  update all repos
# ---------------------------------------------------------------------------

for REPO in $REPOS; do
    # since we end up in the directory .git, we need to go up one level
    cd $REPO/..
    PWD=$(pwd)
    echo "Updating: $PWD ..."
    git pull
    # go back to where we came from
    cd - > /dev/null
    echo ""
done

echo "All done!"

### eof #####################################################################
