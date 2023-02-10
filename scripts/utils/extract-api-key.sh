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
  -H "referer: https://work.$PX_DOMAIN/admin/api-keys" \
  -H 'sec-ch-ua: "Not_A Brand";v="99", "Google Chrome";v="109", "Chromium";v="109"' \
  -H 'sec-ch-ua-mobile: ?0' \
  -H 'sec-ch-ua-platform: "macOS"' \
  -H 'sec-fetch-dest: empty' \
  -H 'sec-fetch-mode: cors' \
  -H 'sec-fetch-site: same-origin' \
  -H 'user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/109.0.0.0 Safari/537.36' \
  -H 'withcredentials: true' \
  -H 'x-csrf: undefined' \
  --data-raw '{"operationName":"getAPIKeysForAdminPage","variables":{},"query":"query getAPIKeysForAdminPage {\n  apiKeys {\n    id\n    desc\n    createdAtMs\n    __typename\n  }\n}\n"}' \
  --compressed \
  -c $TMP_DIR/cookies11.txt \
  -D $TMP_DIR/headers11.txt \
  --output $TMP_DIR/output11.txt

logcat $TMP_DIR/headers11.txt
logcat $TMP_DIR/output11.txt

existing_api_key=$(cat $TMP_DIR/output11.txt | sed 's/"id"/\n"id"/g' | grep "\"id\"" | sed 's/,/\n,/g' | grep "\"id\"" | sed 's/"//g' | sed 's/id://g' | head -n 1)
log "existing_api_key = $existing_api_key"
CREATE_API_KEY=0
if [ -z "$existing_api_key" ] || [ "$existing_api_key" == "" ]; then
  CREATE_API_KEY=1
  log "Creating API KEY..."
else
  CREATE_API_KEY=0
fi


if [ "$CREATE_API_KEY" == "0" ]
then
  api_key_id=$existing_api_key
else
  ## Curl 12
  log 'Curl 12'
  curl -s "https://work.$PX_DOMAIN/api/graphql" \
    -H "authority: work.$PX_DOMAIN" \
    -H 'accept: */*' \
    -H 'accept-language: en-GB,en;q=0.9' \
    -H 'content-type: application/json' \
    -H "cookie: $csrf_token_key=$csrf_token_value; oauth2_authentication_csrf=$oauth2_authentication_csrf; ossidprovider=$ossidprovider; ory_kratos_session=$ory_kratos_session; oauth2_consent_csrf=$oauth2_consent_csrf; default-session5=$default_session5" \
    -H "origin: https://work.$PX_DOMAIN" \
    -H "referer: https://work.$PX_DOMAIN/admin/api-keys" \
    -H 'sec-ch-ua: "Not_A Brand";v="99", "Google Chrome";v="109", "Chromium";v="109"' \
    -H 'sec-ch-ua-mobile: ?0' \
    -H 'sec-ch-ua-platform: "macOS"' \
    -H 'sec-fetch-dest: empty' \
    -H 'sec-fetch-mode: cors' \
    -H 'sec-fetch-site: same-origin' \
    -H 'user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/109.0.0.0 Safari/537.36' \
    -H 'withcredentials: true' \
    -H 'x-csrf: undefined' \
    --data-raw '{"operationName":"CreateAPIKeyFromAdminPage","variables":{},"query":"mutation CreateAPIKeyFromAdminPage {\n  CreateAPIKey {\n    id\n    desc\n    createdAtMs\n    __typename\n  }\n}\n"}' \
    --compressed \
    --insecure \
    -c $TMP_DIR/cookies12.txt \
    -D $TMP_DIR/headers12.txt \
    --output $TMP_DIR/output12.txt

  logcat $TMP_DIR/headers12.txt
  logcat $TMP_DIR/output12.txt

  api_key_id=$(cat $TMP_DIR/output12.txt | sed 's/"id"/\n"id"/g' | sed 's/,/\n,/g' | grep "\"id\"" | sed 's/"//g' | sed 's/id://g')
fi
log "api_key_id = $api_key_id"

##Curl 13
log 'Curl 13'
curl -s "https://work.$PX_DOMAIN/api/graphql" \
  -H "authority: work.$PX_DOMAIN" \
  -H 'accept: */*' \
  -H 'accept-language: en-GB,en;q=0.9' \
  -H 'content-type: application/json' \
  -H "cookie: $csrf_token_key=$csrf_token_value; oauth2_authentication_csrf=$oauth2_authentication_csrf; ossidprovider=$ossidprovider; ory_kratos_session=$ory_kratos_session; oauth2_consent_csrf=$oauth2_consent_csrf; default-session5=$default_session5" \
  -H "origin: https://work.$PX_DOMAIN" \
  -H "referer: https://work.$PX_DOMAIN/admin/api-keys" \
  -H 'sec-ch-ua: "Not_A Brand";v="99", "Google Chrome";v="109", "Chromium";v="109"' \
  -H 'sec-ch-ua-mobile: ?0' \
  -H 'sec-ch-ua-platform: "macOS"' \
  -H 'sec-fetch-dest: empty' \
  -H 'sec-fetch-mode: cors' \
  -H 'sec-fetch-site: same-origin' \
  -H 'user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/109.0.0.0 Safari/537.36' \
  -H 'withcredentials: true' \
  -H 'x-csrf: undefined' \
  --data-raw $"{\"operationName\":\"getAPIKey\",\"variables\":{\"id\":\"$api_key_id\"},\"query\":\"query getAPIKey(\$id: ID\u0021) {\\n  apiKey(id: \$id) {\\n    id\\n    key\\n    __typename\\n  }\\n}\\n\"}" \
  --compressed \
  --insecure \
  -c $TMP_DIR/cookies13.txt \
  -D $TMP_DIR/headers13.txt \
  --output $TMP_DIR/output13.txt

logcat $TMP_DIR/headers13.txt
logcat $TMP_DIR/output13.txt

api_key=$(cat $TMP_DIR/output13.txt | sed 's/"key"/\n"key"/g' | sed 's/,/\n,/g' | grep "\"key\"" | sed 's/"//g' | sed 's/key://g')
log "api_key = $api_key"
echo $api_key


sleep 1
