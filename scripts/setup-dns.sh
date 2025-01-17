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
   clusterDomain=$CLUSTER_DOMAIN
   domain=$PX_DOMAIN
   workdomain="work.$domain"
   kratosdomain="kratos.$domain"
   apidomain="api.$clusterDomain"
   dashboarddomain="dashboard.$clusterDomain"

   if ! [ -z "$domain" ] 
   then
      extip=$ips

      domain_exists=`gcloud dns --project="${gcp_dns_project}" record-sets list --name "${domain}" --zone="${DNS_ZONE}" --type="A" --format=yaml`
      if [ -z "$domain_exists" ] || [ "$domain_exists" == "" ]; then
         gcloud dns --project=$gcp_dns_project record-sets create $domain --zone=$DNS_ZONE --type=A --rrdatas=$extip --ttl=10
      else
         gcloud dns --project=$gcp_dns_project record-sets update $domain --zone=$DNS_ZONE --type=A --rrdatas=$extip --ttl=10
      fi

      cluster_domain_exists=`gcloud dns --project="${gcp_dns_project}" record-sets list --name "${clusterDomain}" --zone="${DNS_ZONE}" --type="A" --format=yaml`
      if [ -z "$cluster_domain_exists" ] || [ "$cluster_domain_exists" == "" ]; then
         gcloud dns --project=$gcp_dns_project record-sets create $clusterDomain --zone=$DNS_ZONE --type=A --rrdatas=$extip --ttl=10
      else
         gcloud dns --project=$gcp_dns_project record-sets update $clusterDomain --zone=$DNS_ZONE --type=A --rrdatas=$extip --ttl=10
      fi

      work_domain_exists=`gcloud dns --project="${gcp_dns_project}" record-sets list --name "${workdomain}" --zone="${DNS_ZONE}" --type="A" --format=yaml`
      if [ -z "$work_domain_exists" ] || [ "$work_domain_exists" == "" ]; then
         gcloud dns --project=$gcp_dns_project record-sets create $workdomain --zone=$DNS_ZONE --type=A --rrdatas=$extip --ttl=10
      else
         gcloud dns --project=$gcp_dns_project record-sets update $workdomain --zone=$DNS_ZONE --type=A --rrdatas=$extip --ttl=10
      fi

      kratos_domain_exists=`gcloud dns --project="${gcp_dns_project}" record-sets list --name "${kratosdomain}" --zone="${DNS_ZONE}" --type="A" --format=yaml`
      if [ -z "$kratos_domain_exists" ] || [ "$kratos_domain_exists" == "" ]; then
         gcloud dns --project=$gcp_dns_project record-sets create $kratosdomain --zone=$DNS_ZONE --type=A --rrdatas=$extip --ttl=10
      else
         gcloud dns --project=$gcp_dns_project record-sets update $kratosdomain --zone=$DNS_ZONE --type=A --rrdatas=$extip --ttl=10
      fi

      dashboard_domain_exists=`gcloud dns --project="${gcp_dns_project}" record-sets list --name "${dashboarddomain}" --zone="${DNS_ZONE}" --type="A" --format=yaml`
      if [ -z "$dashboard_domain_exists" ] || [ "$dashboard_domain_exists" == "" ]; then
         gcloud dns --project=$gcp_dns_project record-sets create $dashboarddomain --zone=$DNS_ZONE --type=A --rrdatas=$extip --ttl=10
      else
         gcloud dns --project=$gcp_dns_project record-sets update $dashboarddomain --zone=$DNS_ZONE --type=A --rrdatas=$extip --ttl=10
      fi

      api_domain_exists=`gcloud dns --project="${gcp_dns_project}" record-sets list --name "${apidomain}" --zone="${DNS_ZONE}" --type="A" --format=yaml`
      if [ -z "$api_domain_exists" ] || [ "$api_domain_exists" == "" ]; then
         gcloud dns --project=$gcp_dns_project record-sets create $apidomain --zone=$DNS_ZONE --type=A --rrdatas=$extip --ttl=10
      else
         gcloud dns --project=$gcp_dns_project record-sets update $apidomain --zone=$DNS_ZONE --type=A --rrdatas=$extip --ttl=10
      fi
   fi
fi
