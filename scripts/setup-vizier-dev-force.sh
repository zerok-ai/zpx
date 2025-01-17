#!/bin/bash
## Variables
THIS_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source $THIS_DIR/variables.sh

$SCRIPTS_DIR/validate-env-variables.sh

echo ''
echo ''
echo '-----------------SETTING-UP-ZPIXIE-REPO-----------------'

getUserInput "Do you want to proceed ahead with zpixie repo checkout?" ""
retval=$?
ZPIXIE_REPO_CHECKOUT=$retval

if [ "$ZPIXIE_REPO_CHECKOUT" == '1' ]
then
    ## Setup pixie repo
    rm -rf $PIXIE_DIR
    # git clone --branch feature/vizier-dev-tryout https://github.com/avingoyal/pixie.git $PIXIE_DIR
    git clone --branch $ZPIXIE_BRANCH git@github.com:zerok-ai/zpixie.git $PIXIE_DIR
    # cd $PIXIE_DIR
    # git submodule update --init --recursive --remote
    # cd $ZPX_DIR
fi

## DOMAIN setup
$SCRIPTS_DIR/setup-domain.sh

## Px Dev Scripts
$SCRIPTS_DIR/setup-px-dev-scripts.sh

## Vizier Dev Setup
$OPERATOR_SCRIPTS_DIR/setup-vizier.sh