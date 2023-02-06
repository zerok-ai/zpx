#!/bin/bash
THIS_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source $THIS_DIR/variables.sh

echo ''
echo '-----------------SETTING-UP-DOMAIN-REPLACEMENTS-----------------'

getUserInput "Do you want to proceed ahead with the domain replacements?" ""
retval=$?
DOMAIN_REPLACEMENTS_SETUP=$retval

if [ "$DOMAIN_REPLACEMENTS_SETUP" == '1' ]
then

        if ! [ -z ${PX_DOMAIN} ]
        then
                echo 'Replacing domains'

                cd $PIXIE_DIR
                git checkout ./k8s/cloud/public/proxy_envoy.yaml
                git checkout ./k8s/cloud/public/domain_config.yaml
                git checkout ./scripts/create_cloud_secrets.sh
                git checkout ./tools/docker/user_dev_image/Dockerfile
                cd $ZPX_DIR

                if [ "$SAME_CLUSTER_SETUP" == '0' ]
                then
                        perl -pi -e 's/^/#/ if $. > 93 and $. < 108' $PIXIE_DIR/scripts/create_cloud_secrets.sh
                        # sed -i '' -e '94,107 s/^/#/' $PIXIE_DIR/scripts/create_cloud_secrets.sh
                else
                        echo "kubectl create secret tls -n \"ingress-nginx\" \\" >> $PIXIE_DIR/scripts/create_cloud_secrets.sh
                        echo "  cloud-proxy-tls-certs \\" >> $PIXIE_DIR/scripts/create_cloud_secrets.sh
                        echo "  --cert=\"\${PROXY_CERT_FILE}\" \\" >> $PIXIE_DIR/scripts/create_cloud_secrets.sh
                        echo "  --key=\"\${PROXY_KEY_FILE}\"" >> $PIXIE_DIR/scripts/create_cloud_secrets.sh
                fi

                perl -pi -e "s/work.dev.withpixie.dev/work.$PX_DOMAIN/" $PIXIE_DIR/k8s/cloud/public/proxy_envoy.yaml
                perl -pi -e "s/\Q*.dev.withpixie.dev/*.$PX_DOMAIN/g" $PIXIE_DIR/k8s/cloud/public/proxy_envoy.yaml
                perl -pi -e "s/dev.withpixie.dev/$PX_DOMAIN/" $PIXIE_DIR/k8s/cloud/public/proxy_envoy.yaml
                # sed -i '' -e "s/work.dev.withpixie.dev/work.$PX_DOMAIN/" $PIXIE_DIR/k8s/cloud/public/proxy_envoy.yaml
                # sed -i '' -e "s/*.dev.withpixie.dev/*.$PX_DOMAIN/" $PIXIE_DIR/k8s/cloud/public/proxy_envoy.yaml
                # sed -i '' -e "s/dev.withpixie.dev/$PX_DOMAIN/" $PIXIE_DIR/k8s/cloud/public/proxy_envoy.yaml

                perl -pi -e "s/work.dev.withpixie.dev/work.$PX_DOMAIN/" $PIXIE_DIR/k8s/cloud/public/domain_config.yaml
                perl -pi -e "s/\Q*.dev.withpixie.dev/*.$PX_DOMAIN/g" $PIXIE_DIR/k8s/cloud/public/domain_config.yaml
                perl -pi -e "s/dev.withpixie.dev/$PX_DOMAIN/" $PIXIE_DIR/k8s/cloud/public/domain_config.yaml
                # sed -i '' -e "s/work.dev.withpixie.dev/work.$PX_DOMAIN/" $PIXIE_DIR/k8s/cloud/public/domain_config.yaml
                # sed -i '' -e "s/*.dev.withpixie.dev/*.$PX_DOMAIN/" $PIXIE_DIR/k8s/cloud/public/domain_config.yaml
                # sed -i '' -e "s/dev.withpixie.dev/$PX_DOMAIN/" $PIXIE_DIR/k8s/cloud/public/domain_config.yaml

                perl -pi -e "s/work.dev.withpixie.dev/work.$PX_DOMAIN/" $PIXIE_DIR/scripts/create_cloud_secrets.sh
                perl -pi -e "s/\Q*.dev.withpixie.dev/*.$PX_DOMAIN/g" $PIXIE_DIR/scripts/create_cloud_secrets.sh
                perl -pi -e "s/dev.withpixie.dev/$PX_DOMAIN/" $PIXIE_DIR/scripts/create_cloud_secrets.sh
                # sed -i '' -e "s/work.dev.withpixie.dev/work.$PX_DOMAIN/" $PIXIE_DIR/scripts/create_cloud_secrets.sh
                # sed -i '' -e "s/*.dev.withpixie.dev/*.$PX_DOMAIN/" $PIXIE_DIR/scripts/create_cloud_secrets.sh
                # sed -i '' -e "s/dev.withpixie.dev/$PX_DOMAIN/" $PIXIE_DIR/scripts/create_cloud_secrets.sh

                perl -pi -e 's/\"4444\"/\"\"/' $PIXIE_DIR/k8s/cloud/public/domain_config.yaml
                # sed -i '' -e "s/\"4444\"/\"\"/" $PIXIE_DIR/k8s/cloud/public/domain_config.yaml

                rm $SCRIPTS_DIR/modified/cloud_ingress_*.yaml
                rm $SCRIPTS_DIR/modified/certificate_*.yaml
                envsubst < $SCRIPTS_DIR/originals/certificate_cloud_proxy_tls_certs.yaml >> $SCRIPTS_DIR/modified/certificate_cloud_proxy_tls_certs.yaml
                envsubst < $SCRIPTS_DIR/originals/certificate_cloud_proxy_tls_certs_nginx.yaml >> $SCRIPTS_DIR/modified/certificate_cloud_proxy_tls_certs_nginx.yaml
                export SSL_PASSTHROUGH_HTTPS=true
                export SSL_PASSTHROUGH_GRPCS_OTHERS=true
                export SSL_PASSTHROUGH_GRPCS_VIZIER=true
                export SSL_PASSTHROUGH_GRPCS_AUTH=true
                envsubst < $SCRIPTS_DIR/originals/cloud_ingress_template.yaml >> $SCRIPTS_DIR/modified/cloud_ingress_predeploy.yaml
                export SSL_PASSTHROUGH_HTTPS=false
                export SSL_PASSTHROUGH_GRPCS_OTHERS=true
                export SSL_PASSTHROUGH_GRPCS_VIZIER=true
                export SSL_PASSTHROUGH_GRPCS_AUTH=true
                envsubst < $SCRIPTS_DIR/originals/cloud_ingress_template.yaml >> $SCRIPTS_DIR/modified/cloud_ingress_deploy.yaml

                perl -pi -e 's/\${URL}\) -eq 200/--insecure \${URL}\) -eq 200/' $PIXIE_DIR/k8s/cloud/base/ory_auth/kratos/kratos_deployment.yaml
                perl -pi -e 's/\"\${ADMIN_URL}\/admin\/identities\"/--insecure \"\${ADMIN_URL}\/admin\/identities\"/' $PIXIE_DIR/k8s/cloud/base/ory_auth/kratos/kratos_deployment.yaml
                # sed -i '' -e "s/\${URL}) -eq 200/--insecure \${URL}) -eq 200/" $PIXIE_DIR/k8s/cloud/base/ory_auth/kratos/kratos_deployment.yaml
                # sed -i '' -e "s/\"\${ADMIN_URL}\/admin\/identities/--insecure \"\${ADMIN_URL}\/admin\/identities/" $PIXIE_DIR/k8s/cloud/base/ory_auth/kratos/kratos_deployment.yaml

                if [ "$PIXIE_DEV_MODE" == '1' ]
                then
                        perl -pi -e 's/^/#/ if $. > 28 and $. < 39' $PIXIE_DIR/tools/docker/user_dev_image/Dockerfile
                        perl -pi -e 'print "RUN addgroup --gid \${DOCKER_ID} docker-host\nRUN usermod -a -G sudo \${USER_NAME}\nRUN usermod -a -G docker-host \${USER_NAME}\n" if $.==39' $PIXIE_DIR/tools/docker/user_dev_image/Dockerfile
                fi

        fi
fi

