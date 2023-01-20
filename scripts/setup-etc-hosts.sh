 #!/bin/bash -l
THIS_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source $THIS_DIR/variables.sh

# echo ''
# echo '-----------------SETTING-UP-ETC-HOSTS-----------------'

# getUserInput "Do you want to add the nginx the /etc/hosts record?" ""
# retval=$?
# ETC_HOSTS_SETUP=$retval

# if [ "$ETC_HOSTS_SETUP" == '1' ]
# then
   services=($(kubectl get services -n ingress-nginx --no-headers --field-selector metadata.name=ingress-nginx-controller | awk '{print $1}'))
   ips=($(kubectl get services -n ingress-nginx --no-headers --field-selector metadata.name=ingress-nginx-controller | awk '{print $4}'))
   gcp_dns_project=black-scope-358204

   if ! [ -z "$PX_DOMAIN" ] 
   then
      for i in "${!services[@]}"; do
         # if [[ ${services[i]} == "ingress-nginx-controller" ]]; then
         extip=${ips[i]}
         
         echo "$extip  work.$PX_DOMAIN $PX_DOMAIN" >> /etc/hosts
      done
   fi
# fi