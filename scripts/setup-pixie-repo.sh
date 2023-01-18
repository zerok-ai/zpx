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

	git clone https://github.com/pixie-io/pixie.git $PIXIE_DIR
	cd $PIXIE_DIR
	export LATEST_CLOUD_RELEASE=$(git tag | grep 'release/cloud'  | sort -r | head -n 1 | awk -F/ '{print $NF}')
	git checkout "release/cloud/prod/${LATEST_CLOUD_RELEASE}"
	perl -pi -e "s|newTag: latest|newTag: \"${LATEST_CLOUD_RELEASE}\"|g" k8s/cloud/public/kustomization.yaml

	if [ "$SAME_CLUSTER_SETUP" == '0' ]
	then
		sed -i '' -e '94,107 s/^/#/' ./scripts/create_cloud_secrets.sh
	fi

	cd $SCRIPTS_DIR
fi