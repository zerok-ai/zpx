#!/bin/bash
## Variables
THIS_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source $THIS_DIR/variables.sh

## Setup pixie repo
rm -rf $PIXIE_DIR
# git clone --branch feature/vizier-dev-tryout https://github.com/avingoyal/pixie.git $PIXIE_DIR
git clone --branch feature/zk-query https://github.com/zerok-ai/zpixie.git $PIXIE_DIR

## DOMAIN setup
$SCRIPTS_DIR/setup-domain.sh

## Px Dev Scripts
$SCRIPTS_DIR/setup-px-dev-scripts.sh

## Vizier Dev Setup
$OPERATOR_SCRIPTS_DIR/setup-vizier.sh