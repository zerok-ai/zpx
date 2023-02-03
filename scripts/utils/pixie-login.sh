#!/bin/bash
THIS_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source $THIS_DIR/pixie-utils.sh $1 $2

# PX_DOMAIN=testpxsetup7.testdomain.com
PX_DOMAIN=$1

##Curl 1
log 'Curl 1'
STATE=1ae81750d4d34bb9b96a9fc0a6b4eff9
curl -s "https://work.$PX_DOMAIN/oauth/hydra/oauth2/auth?client_id=auth-code-client&redirect_uri=https%3A%2F%2Fwork.$PX_DOMAIN%2Fauth%2Fcallback&response_type=token&scope=vizier&state=$STATE&prompt=login" \
  -H "authority: work.$PX_DOMAIN" \
  -H 'accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9' \
  -H 'accept-language: en-GB,en;q=0.9' \
  -H "referer: https://work.$PX_DOMAIN/auth/login?local_mode=true" \
  -H 'sec-ch-ua: "Not_A Brand";v="99", "Google Chrome";v="109", "Chromium";v="109"' \
  -H 'sec-ch-ua-mobile: ?0' \
  -H 'sec-ch-ua-platform: "macOS"' \
  -H 'sec-fetch-dest: document' \
  -H 'sec-fetch-mode: navigate' \
  -H 'sec-fetch-site: same-origin' \
  -H 'sec-fetch-user: ?1' \
  -H 'upgrade-insecure-requests: 1' \
  -H 'user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/109.0.0.0 Safari/537.36' \
  --compressed \
  --insecure \
  -c $TMP_DIR/cookies1.txt \
  -D $TMP_DIR/headers1.txt \
  --output $TMP_DIR/output1.txt

logcat $TMP_DIR/headers1.txt
logcat $TMP_DIR/output1.txt

sed -i '' -e "s/login_challenge=/¿/" $TMP_DIR/output1.txt
IFS='¿'
read -a my_array <<< "$(cat $TMP_DIR/output1.txt)"
IFS='"'
read -a my_array <<< "${my_array[1]}"
login_challenge=${my_array[0]}
log "login_challenge = $login_challenge"
oauth2_authentication_csrf=$(extractCookie $TMP_DIR/headers1.txt oauth2_authentication_csrf)
log "oauth2_authentication_csrf = $oauth2_authentication_csrf"

##Curl 2
log 'Curl 2'
curl -s "https://work.$PX_DOMAIN/api/auth/oauth/login?login_challenge=$login_challenge" \
  -H "authority: work.$PX_DOMAIN" \
  -H 'accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9' \
  -H 'accept-language: en-GB,en;q=0.9' \
  -H "cookie: oauth2_authentication_csrf=$oauth2_authentication_csrf" \
  -H "referer: https://work.$PX_DOMAIN/auth/login?local_mode=true" \
  -H 'sec-ch-ua: "Not_A Brand";v="99", "Google Chrome";v="109", "Chromium";v="109"' \
  -H 'sec-ch-ua-mobile: ?0' \
  -H 'sec-ch-ua-platform: "macOS"' \
  -H 'sec-fetch-dest: document' \
  -H 'sec-fetch-mode: navigate' \
  -H 'sec-fetch-site: same-origin' \
  -H 'sec-fetch-user: ?1' \
  -H 'upgrade-insecure-requests: 1' \
  -H 'user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/109.0.0.0 Safari/537.36' \
  --compressed \
  --insecure \
  -c $TMP_DIR/cookies2.txt \
  -D $TMP_DIR/headers2.txt \
  --output $TMP_DIR/output2.txt

logcat $TMP_DIR/headers2.txt
logcat $TMP_DIR/output2.txt

sed -i '' -e "s/hydra_login_state%3D/¿/" $TMP_DIR/output2.txt
sed -i '' -e "s/%26login_challenge/¿/" $TMP_DIR/output2.txt
IFS='¿'
read -a my_array <<< "$(cat $TMP_DIR/output2.txt)"
hydra_login_state=${my_array[1]}
log "hydra_login_state = $hydra_login_state"
ossidprovider=$(extractCookie $TMP_DIR/headers2.txt ossidprovider)
log "ossidprovider = $ossidprovider"

##Curl 3
log 'Curl 3'
curl -s "https://work.$PX_DOMAIN/oauth/kratos/self-service/login/browser?refresh=true&return_to=%2Fapi%2Fauth%2Foauth%2Flogin%3Fhydra_login_state%3D$hydra_login_state%26login_challenge%3D$login_challenge" \
  -H "authority: work.$PX_DOMAIN" \
  -H 'accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9' \
  -H 'accept-language: en-GB,en;q=0.9' \
  -H "cookie: oauth2_authentication_csrf=$oauth2_authentication_csrf; ossidprovider=$ossidprovider" \
  -H "referer: https://work.$PX_DOMAIN/auth/login?local_mode=true" \
  -H 'sec-ch-ua: "Not_A Brand";v="99", "Google Chrome";v="109", "Chromium";v="109"' \
  -H 'sec-ch-ua-mobile: ?0' \
  -H 'sec-ch-ua-platform: "macOS"' \
  -H 'sec-fetch-dest: document' \
  -H 'sec-fetch-mode: navigate' \
  -H 'sec-fetch-site: same-origin' \
  -H 'sec-fetch-user: ?1' \
  -H 'upgrade-insecure-requests: 1' \
  -H 'user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/109.0.0.0 Safari/537.36' \
  --compressed \
  --insecure \
  -c $TMP_DIR/cookies3.txt \
  -D $TMP_DIR/headers3.txt \
  --output $TMP_DIR/output3.txt

logcat $TMP_DIR/headers3.txt
logcat $TMP_DIR/output3.txt

sed -i '' -e "s/flow=/¿/" $TMP_DIR/output3.txt
IFS='¿'
read -a my_array <<< "$(cat $TMP_DIR/output3.txt)"
IFS='"'
read -a my_array <<< "${my_array[1]}"
flow=${my_array[0]}
log "flow = $flow"

CSRF_COOKIE=$(cat $TMP_DIR/headers3.txt | grep 'csrf_token' | sed 's/set-cookie: //g' | sed 's/;/\n/g' | grep 'csrf_token')
csrf_token_key=$(echo $CSRF_COOKIE | awk -F'=' '{print $1}')
csrf_token_value=$(echo $CSRF_COOKIE | sed "s/$csrf_token_key=//g")
log "csrf_token_key = $csrf_token_key"
log "csrf_token_value = $csrf_token_value"

## Curl 4
log 'Curl 4'
curl -s "https://work.$PX_DOMAIN/oauth/kratos/self-service/login/flows?id=$flow" \
  -H "authority: work.$PX_DOMAIN" \
  -H 'accept: application/json, text/plain, */*' \
  -H 'accept-language: en-GB,en;q=0.9' \
  -H "cookie: oauth2_authentication_csrf=$oauth2_authentication_csrf; ossidprovider=$ossidprovider; $csrf_token_key=$csrf_token_value" \
  -H "referer: https://work.$PX_DOMAIN/auth/password-login?flow=$flow" \
  -H 'sec-ch-ua: "Not_A Brand";v="99", "Google Chrome";v="109", "Chromium";v="109"' \
  -H 'sec-ch-ua-mobile: ?0' \
  -H 'sec-ch-ua-platform: "macOS"' \
  -H 'sec-fetch-dest: empty' \
  -H 'sec-fetch-mode: cors' \
  -H 'sec-fetch-site: same-origin' \
  -H 'user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/109.0.0.0 Safari/537.36' \
  --compressed \
  --insecure \
  -c $TMP_DIR/cookies4.txt \
  -D $TMP_DIR/headers4.txt \
  --output $TMP_DIR/output4.txt

logcat $TMP_DIR/headers4.txt
logcat $TMP_DIR/output4.txt

# cat $TMP_DIR/headers4.txt
# cat $TMP_DIR/output4.txt
# log ''
# log ''
# cat $TMP_DIR/output4.txt | sed 's/"name"/\n"name"/g' | grep '"csrf_token"' 
# log ''
# log ''
# cat $TMP_DIR/output4.txt | sed 's/"name"/\n"name"/g' | grep '"csrf_token"' | awk -F ',' '{print $3}'
TMP=$(cat $TMP_DIR/output4.txt | sed 's/"name"/\n"name"/g' | grep '"csrf_token"' | sed 's/"value"/\n"value"/g' | grep '"value"' | awk -F ',' '{print $1}')
TMP=${TMP#'"value":"'}
TMP=${TMP%'"'}
csrf_token=$TMP
log "csrf_token = $csrf_token"
csrf_token_encoded=$(url_encode $csrf_token)
log "csrf_token_encoded = $csrf_token_encoded"
# log $csrf_token_encoded

## Curl 5
log 'Curl 5'
curl -s "https://work.$PX_DOMAIN/oauth/kratos/self-service/login?flow=$flow" \
  -H "authority: work.$PX_DOMAIN" \
  -H 'accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9' \
  -H 'accept-language: en-GB,en;q=0.9' \
  -H 'cache-control: max-age=0' \
  -H 'content-type: application/x-www-form-urlencoded' \
  -H "cookie: oauth2_authentication_csrf=$oauth2_authentication_csrf; ossidprovider=$ossidprovider; $csrf_token_key=$csrf_token_value" \
  -H "origin: https://work.$PX_DOMAIN" \
  -H "referer: https://work.$PX_DOMAIN/auth/password-login?flow=$flow" \
  -H 'sec-ch-ua: "Not_A Brand";v="99", "Google Chrome";v="109", "Chromium";v="109"' \
  -H 'sec-ch-ua-mobile: ?0' \
  -H 'sec-ch-ua-platform: "macOS"' \
  -H 'sec-fetch-dest: document' \
  -H 'sec-fetch-mode: navigate' \
  -H 'sec-fetch-site: same-origin' \
  -H 'sec-fetch-user: ?1' \
  -H 'upgrade-insecure-requests: 1' \
  -H 'user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/109.0.0.0 Safari/537.36' \
  --data-raw "csrf_token=$csrf_token_encoded&identifier=admin%40default.com&password=admin&method=password" \
  --compressed \
  --insecure \
  -c $TMP_DIR/cookies5.txt \
  -D $TMP_DIR/headers5.txt \
  --output $TMP_DIR/output5.txt

logcat $TMP_DIR/headers5.txt
logcat $TMP_DIR/output5.txt

# cat $TMP_DIR/headers5.txt
CSRF_COOKIE=$(cat $TMP_DIR/headers5.txt | grep 'csrf_token' | sed 's/set-cookie: //g' | sed 's/;/\n/g' | grep 'csrf_token')
csrf_token_key=$(echo $CSRF_COOKIE | awk -F'=' '{print $1}')
csrf_token_value=$(echo $CSRF_COOKIE | sed "s/$csrf_token_key=//g")

# $csrf_token_key=$(extractCookie $TMP_DIR/headers5.txt $csrf_token_key)
log "csrf_token_key = $csrf_token_key"
log "csrf_token_value = $csrf_token_value"
ory_kratos_session=$(extractCookie $TMP_DIR/headers5.txt ory_kratos_session)
log "ory_kratos_session = $ory_kratos_session"
# log $ory_kratos_session

## Curl 6
log 'Curl 6'
curl -s "https://work.$PX_DOMAIN/api/auth/oauth/login?hydra_login_state=$hydra_login_state&login_challenge=$login_challenge" \
  -H "authority: work.$PX_DOMAIN" \
  -H 'accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9' \
  -H 'accept-language: en-GB,en;q=0.9' \
  -H 'cache-control: max-age=0' \
  -H "cookie: oauth2_authentication_csrf=$oauth2_authentication_csrf; ossidprovider=$ossidprovider; $csrf_token_key=$csrf_token_value; ory_kratos_session=$ory_kratos_session" \
  -H "referer: https://work.$PX_DOMAIN/auth/password-login?flow=$flow" \
  -H 'sec-ch-ua: "Not_A Brand";v="99", "Google Chrome";v="109", "Chromium";v="109"' \
  -H 'sec-ch-ua-mobile: ?0' \
  -H 'sec-ch-ua-platform: "macOS"' \
  -H 'sec-fetch-dest: document' \
  -H 'sec-fetch-mode: navigate' \
  -H 'sec-fetch-site: same-origin' \
  -H 'sec-fetch-user: ?1' \
  -H 'upgrade-insecure-requests: 1' \
  -H 'user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/109.0.0.0 Safari/537.36' \
  --compressed \
  --insecure \
  -c $TMP_DIR/cookies6.txt \
  -D $TMP_DIR/headers6.txt \
  --output $TMP_DIR/output6.txt

sed -i '' -e "s/consent_verifier=/¿/" $TMP_DIR/output6.txt
IFS='¿'
read -a my_array <<< "$(cat $TMP_DIR/output6.txt)"
IFS='&'
read -a my_array <<< "${my_array[1]}"
consent_verifier=${my_array[0]}
log "consent_verifier = $consent_verifier"
oauth2_consent_csrf=$(extractCookie $TMP_DIR/headers6.txt oauth2_consent_csrf)
log "oauth2_consent_csrf = $oauth2_consent_csrf"

## Curl 7
log 'Curl 7'
curl -s "https://work.$PX_DOMAIN/oauth/hydra/oauth2/auth?client_id=auth-code-client&consent_verifier=$consent_verifier&prompt=login&redirect_uri=https%3A%2F%2Fwork.$PX_DOMAIN%2Fauth%2Fcallback&response_type=token&scope=vizier&state=$STATE" \
  -H "authority: work.$PX_DOMAIN" \
  -H 'accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9' \
  -H 'accept-language: en-GB,en;q=0.9' \
  -H 'cache-control: max-age=0' \
  -H "cookie: oauth2_authentication_csrf=$oauth2_authentication_csrf; ossidprovider=$ossidprovider; $csrf_token_key=$csrf_token_value; ory_kratos_session=$ory_kratos_session; oauth2_consent_csrf=$oauth2_consent_csrf" \
  -H "referer: https://work.$PX_DOMAIN/auth/password-login?flow=$flow" \
  -H 'sec-ch-ua: "Not_A Brand";v="99", "Google Chrome";v="109", "Chromium";v="109"' \
  -H 'sec-ch-ua-mobile: ?0' \
  -H 'sec-ch-ua-platform: "macOS"' \
  -H 'sec-fetch-dest: document' \
  -H 'sec-fetch-mode: navigate' \
  -H 'sec-fetch-site: same-origin' \
  -H 'sec-fetch-user: ?1' \
  -H 'upgrade-insecure-requests: 1' \
  -H 'user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/109.0.0.0 Safari/537.36' \
  --compressed \
  --insecure \
  -c $TMP_DIR/cookies7.txt \
  -D $TMP_DIR/headers7.txt \
  --output $TMP_DIR/output7.txt

logcat $TMP_DIR/headers7.txt

TMP=$(cat $TMP_DIR/headers7.txt | grep "access_token=" | sed 's/access_token=/\naccess_token=/g' | sed 's/&expires_in=/\n&expires_in=/g' | grep 'access_token=')
TMP=${TMP#"access_token="}
access_token=$TMP
log "access_token = $access_token"

## Curl 8
log 'curl 8'
curl -s "https://work.$PX_DOMAIN/api/auth/login" \
  -H "authority: work.$PX_DOMAIN" \
  -H 'accept: application/json, text/plain, */*' \
  -H 'accept-language: en-GB,en;q=0.9' \
  -H 'content-type: application/json' \
  -H "cookie: oauth2_authentication_csrf=$oauth2_authentication_csrf; ossidprovider=$ossidprovider; $csrf_token_key=$csrf_token_value; ory_kratos_session=$ory_kratos_session; oauth2_consent_csrf=$oauth2_consent_csrf" \
  -H "origin: https://work.$PX_DOMAIN" \
  -H "referer: https://work.$PX_DOMAIN/auth/callback" \
  -H 'sec-ch-ua: "Not_A Brand";v="99", "Google Chrome";v="109", "Chromium";v="109"' \
  -H 'sec-ch-ua-mobile: ?0' \
  -H 'sec-ch-ua-platform: "macOS"' \
  -H 'sec-fetch-dest: empty' \
  -H 'sec-fetch-mode: cors' \
  -H 'sec-fetch-site: same-origin' \
  -H 'user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/109.0.0.0 Safari/537.36' \
  --data-raw "{\"accessToken\":\"$access_token\"}" \
  --compressed \
  --insecure \
  -c $TMP_DIR/cookies8.txt \
  -D $TMP_DIR/headers8.txt \
  --output $TMP_DIR/output8.txt

default_session5=$(extractCookie $TMP_DIR/headers8.txt default-session5)
log "default_session5 = $default_session5"

export login_challenge=$login_challenge
export oauth2_authentication_csrf=$oauth2_authentication_csrf
export hydra_login_state=$hydra_login_state
export ossidprovider=$ossidprovider
export flow=$flow
export csrf_token_key=$csrf_token_key
export csrf_token_value=$csrf_token_value
export csrf_token=$csrf_token
export csrf_token_encoded=$csrf_token_encoded
export csrf_token_key=$csrf_token_key
export csrf_token_value=$csrf_token_value
export ory_kratos_session=$ory_kratos_session
export consent_verifier=$consent_verifier
export oauth2_consent_csrf=$oauth2_consent_csrf
export access_token=$access_token
export default_session5=$default_session5
