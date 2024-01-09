#!/bin/bash
## Variables
THIS_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source $THIS_DIR/variables.sh

echo ''
echo ''
echo '-----------------SETTING-UP-CONFIGURATIONS-----------------'
ZPIXIE_BRANCH_LOCAL=$(getUserTextInput "ZPIXIE_BRANCH is set to $ZPIXIE_BRANCH." "Want to change it")
if [ "$ZPIXIE_BRANCH_LOCAL" != "" ]
then
    ZPIXIE_BRANCH=$ZPIXIE_BRANCH_LOCAL
fi
echo ""
VIZIER_TAG_LOCAL=$(getUserTextInput "VIZIER_TAG is set to $VIZIER_TAG." "Want to change it")
if [ "$VIZIER_TAG_LOCAL" != "" ]
then
    VIZIER_TAG=$VIZIER_TAG_LOCAL
fi

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