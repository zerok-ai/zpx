#!/bin/bash
THIS_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source $THIS_DIR/variables.sh

echo ''
echo '-----------------PIXIE-REPO-SETUP-----------------'
getUserInput "Do you want to setup the pixie-repo " ""
retval=$?
FORCE=$retval

if [ -d "$PIXIE_DIR" ] && [ "$FORCE" == '0' ]
then
    echo "Pixie repo already exists"
else
	if [ "$FORCE" == '0' ]
	then
		echo "Setting up pixie repo"
	else
		echo "Re-setting up pixie repo as --pixie-force option is passed"
		rm -rf $PIXIE_DIR
	fi

	# git clone --branch feature/vizier-dev-tryout https://github.com/avingoyal/pixie.git $PIXIE_DIR
	#git clone --branch main git@github.com:zerok-ai/zpixie.git $PIXIE_DIR
	cd $PIXIE_DIR

	export LATEST_CLOUD_RELEASE=$(git tag | grep 'release/cloud/prod'  | sort -r | head -n 1 | awk -F/ '{print $NF}')
	echo "LATEST_CLOUD_RELEASE=$LATEST_CLOUD_RELEASE"
	git checkout "release/cloud/prod/${LATEST_CLOUD_RELEASE}"
	perl -pi -e "s|newTag: latest|newTag: \"${LATEST_CLOUD_RELEASE}\"|g" k8s/cloud/public/kustomization.yaml

	if [ "$USE_MKCERT_CA" == '0' ]
	then
		perl -pi -e 's/^/#/ if $. > 93 and $. < 108' ./scripts/create_cloud_secrets.sh
		# sed -i '' -e '94,107 s/^/#/' ./scripts/create_cloud_secrets.sh
		
	fi

	cd $SCRIPTS_DIR
fi
