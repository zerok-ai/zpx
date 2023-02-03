#!/bin/bash
THIS_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source $THIS_DIR/pixie-create-org.sh $1 $2

## Curl 11
log "Curl 11"
curl -s "https://work.$PX_DOMAIN/api/graphql" \
  -H "authority: work.$PX_DOMAIN" \
  -H 'accept: */*' \
  -H 'accept-language: en-GB,en;q=0.9' \
  -H 'content-type: application/json' \
  -H "cookie: oauth2_authentication_csrf=$oauth2_authentication_csrf; ossidprovider=$ossidprovider; $csrf_token_key=$csrf_token_value; ory_kratos_session=$ory_kratos_session; oauth2_consent_csrf=$oauth2_consent_csrf; default-session5=$default_session5" \
  -H "origin: https://work.$PX_DOMAIN" \
  -H "referer: https://work.$PX_DOMAIN/admin/clusters" \
  -H 'sec-ch-ua: "Not_A Brand";v="99", "Google Chrome";v="109", "Chromium";v="109"' \
  -H 'sec-ch-ua-mobile: ?0' \
  -H 'sec-ch-ua-platform: "macOS"' \
  -H 'sec-fetch-dest: empty' \
  -H 'sec-fetch-mode: cors' \
  -H 'sec-fetch-site: same-origin' \
  -H 'user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/109.0.0.0 Safari/537.36' \
  -H 'withcredentials: true' \
  -H 'x-csrf: undefined' \
  --data-raw '{"operationName":"listClusterForAdminPage","variables":{},"query":"query listClusterForAdminPage {\n  clusters {\n    id\n    clusterName\n    prettyClusterName\n    vizierVersion\n    status\n    lastHeartbeatMs\n    numNodes\n    numInstrumentedNodes\n    __typename\n  }\n}\n"}' \
  --compressed \
  -c $TMP_DIR/cookies11.txt \
  -D $TMP_DIR/headers11.txt \
  --output $TMP_DIR/output11.txt

logcat $TMP_DIR/headers11.txt
logcat $TMP_DIR/output11.txt

cluster_id=$(cat $TMP_DIR/output11.txt | sed 's/"id"/\n"id"/g' | grep "\"id\"" | sed 's/,/\n,/g' | grep "\"id\"" | sed 's/"//g' | sed 's/id://g' | head -n 1)
echo $cluster_id


sleep 1
# rm -rf $TMP_DIR
