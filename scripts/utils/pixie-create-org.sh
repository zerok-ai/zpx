#!/bin/bash
THIS_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source $THIS_DIR/pixie-login.sh $1 $2

## Curl 9
log "Curl 9"
curl -s "https://work.$PX_DOMAIN/api/graphql" \
  -H "authority: work.$PX_DOMAIN" \
  -H 'accept: */*' \
  -H 'accept-language: en-GB,en;q=0.9' \
  -H 'content-type: application/json' \
  -H "cookie: oauth2_authentication_csrf=$oauth2_authentication_csrf; ossidprovider=$ossidprovider; $csrf_token_key=$csrf_token_value; ory_kratos_session=$ory_kratos_session; oauth2_consent_csrf=$oauth2_consent_csrf; default-session5=$default_session5" \
  -H "origin: https://work.$PX_DOMAIN" \
  -H "referer: https://work.$PX_DOMAIN/" \
  -H 'sec-ch-ua: "Not_A Brand";v="99", "Google Chrome";v="109", "Chromium";v="109"' \
  -H 'sec-ch-ua-mobile: ?0' \
  -H 'sec-ch-ua-platform: "macOS"' \
  -H 'sec-fetch-dest: empty' \
  -H 'sec-fetch-mode: cors' \
  -H 'sec-fetch-site: same-origin' \
  -H 'user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/109.0.0.0 Safari/537.36' \
  -H 'withcredentials: true' \
  -H 'x-csrf: undefined' \
  --data-raw '{"operationName":"getOrgInfo","variables":{},"query":"query getOrgInfo {\n  org {\n    id\n    name\n    domainName\n    idePaths {\n      IDEName\n      path\n      __typename\n    }\n    __typename\n  }\n}\n"}' \
  --compressed \
  -c $TMP_DIR/cookies9.txt \
  -D $TMP_DIR/headers9.txt \
  --output $TMP_DIR/output9.txt

org_id=$(cat $TMP_DIR/output9.txt | sed 's/"id"/\n"id"/g' | sed 's/,/\n,/g' | grep "\"id\"" | sed 's/"//g' | sed 's/id://g')
log "org_id = $org_id"
CREATE_ORG=0
if [ -z "$org_id" ] || [ "$org_id" == "" ] || [ "$org_id" == "00000000-0000-0000-0000-000000000000" ]; then
  CREATE_ORG=1
  log "Creating org as org id is not set"
else
  CREATE_ORG=0
fi
log "CREATE_ORG = $CREATE_ORG"

## Curl 10
log "Curl 10"
if [ "$CREATE_ORG" == "1" ]
then
  curl -s "https://work.$PX_DOMAIN/api/graphql" \
    -H "authority: work.$PX_DOMAIN" \
    -H 'accept: */*' \
    -H 'accept-language: en-GB,en;q=0.9' \
    -H 'content-type: application/json' \
    -H "cookie: oauth2_authentication_csrf=$oauth2_authentication_csrf; ossidprovider=$ossidprovider; $csrf_token_key=$csrf_token_value; ory_kratos_session=$ory_kratos_session; oauth2_consent_csrf=$oauth2_consent_csrf; default-session5=$default_session5" \
    -H "origin: https://work.$PX_DOMAIN" \
    -H "referer: https://work.$PX_DOMAIN/setup" \
    -H 'sec-ch-ua: "Not_A Brand";v="99", "Google Chrome";v="109", "Chromium";v="109"' \
    -H 'sec-ch-ua-mobile: ?0' \
    -H 'sec-ch-ua-platform: "macOS"' \
    -H 'sec-fetch-dest: empty' \
    -H 'sec-fetch-mode: cors' \
    -H 'sec-fetch-site: same-origin' \
    -H 'user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/109.0.0.0 Safari/537.36' \
    -H 'withcredentials: true' \
    -H 'x-csrf: undefined' \
    --data-raw $'{"operationName":"CreateOrgFromSetupOrgPage","variables":{"orgName":"abctest"},"query":"mutation CreateOrgFromSetupOrgPage($orgName: String\u0021) {\\n  CreateOrg(orgName: $orgName)\\n}\\n"}' \
    --compressed \
    -c $TMP_DIR/cookies10.txt \
    -D $TMP_DIR/headers10.txt \
    --output $TMP_DIR/output10.txt

    logcat $TMP_DIR/headers10.txt
    logcat $TMP_DIR/output10.txt
fi
