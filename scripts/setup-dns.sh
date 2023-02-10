 #!/bin/bash -l
THIS_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source $THIS_DIR/variables.sh

echo ''
echo '-----------------SETTING-UP-NGINX-INGRESS-----------------'

getUserInput "Do you want to setup the nginx-ingress dns A record?" ""
retval=$?
NGINX_INGRESS_DNS_SETUP=$retval

if [ "$NGINX_INGRESS_DNS_SETUP" == '1' ]
then
   services=($(kubectl get services -n ingress-nginx --no-headers --field-selector metadata.name=ingress-nginx-controller | awk '{print $1}'))
   ips=($(kubectl get services -n ingress-nginx --no-headers --field-selector metadata.name=ingress-nginx-controller | awk '{print $4}'))
   gcp_dns_project=black-scope-358204
   domain=$PX_DOMAIN
   workdomain="work.$domain"

   if ! [ -z "$domain" ] 
   then
      extip=$ips

      domain_exists=`gcloud dns --project="${gcp_dns_project}" record-sets list --name "${domain}" --zone="anton" --type="A" --format=yaml`
      if [ -z "$domain_exists" ] || [ "$domain_exists" == "" ]; then
         gcloud dns --project=$gcp_dns_project record-sets create $domain --zone=anton --type=A --rrdatas=$extip --ttl=10
      else
         gcloud dns --project=$gcp_dns_project record-sets update $domain --zone=anton --type=A --rrdatas=$extip --ttl=10
      fi

      work_domain_exists=`gcloud dns --project="${gcp_dns_project}" record-sets list --name "${workdomain}" --zone="anton" --type="A" --format=yaml`
      if [ -z "$work_domain_exists" ] || [ "$work_domain_exists" == "" ]; then
         gcloud dns --project=$gcp_dns_project record-sets create $workdomain --zone=anton --type=A --rrdatas=$extip --ttl=10
      else
         gcloud dns --project=$gcp_dns_project record-sets update $workdomain --zone=anton --type=A --rrdatas=$extip --ttl=10
      fi
   fi
fi
