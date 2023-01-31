#!/bin/bash

THIS_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
mkdir $THIS_DIR/.tmp
TMP_DIR=$THIS_DIR/.tmp

##Utils
extractCookie(){
  FILE=$1
  COOKIE_NAME=$2
  COOKIES=$(cat $FILE | grep 'set-cookie' | grep "$COOKIE_NAME")
	IFS=' '
	read -a my_array <<< "$COOKIES"
	TMP=${my_array[1]}
	TMP=${TMP#"$COOKIE_NAME="}
	TMP=${TMP%";"}
  echo "$TMP"
}

function url_encode() {
    echo "$@" \
    | sed \
        -e 's/%/%25/g' \
        -e 's/ /%20/g' \
        -e 's/!/%21/g' \
        -e 's/"/%22/g' \
        -e "s/'/%27/g" \
        -e 's/#/%23/g' \
        -e 's/(/%28/g' \
        -e 's/)/%29/g' \
        -e 's/+/%2B/g' \
        -e 's/,/%2C/g' \
        -e 's/-/%2D/g' \
        -e 's/=/%3D/g' \
        -e 's/:/%3A/g' \
        -e 's/;/%3B/g' \
        -e 's/?/%3F/g' \
        -e 's/@/%40/g' \
        -e 's/\$/%24/g' \
        -e 's/\&/%26/g' \
        -e 's/\*/%2A/g' \
        -e 's/\./%2E/g' \
        -e 's/\//%2F/g' \
        -e 's/\[/%5B/g' \
        -e 's/\\/%5C/g' \
        -e 's/\]/%5D/g' \
        -e 's/\^/%5E/g' \
        -e 's/_/%5F/g' \
        -e 's/`/%60/g' \
        -e 's/{/%7B/g' \
        -e 's/|/%7C/g' \
        -e 's/}/%7D/g' \
        -e 's/~/%7E/g'
}

# # Only invoke url_encode if the script is being executed
# # (rather than sourced).
# if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
#     url_encode $@
# fi


##Curl 1
STATE=1ae81750d4d34bb9b96a9fc0a6b4eff9
curl -s "https://work.abc.testdomain.com/oauth/hydra/oauth2/auth?client_id=auth-code-client&redirect_uri=https%3A%2F%2Fwork.abc.testdomain.com%2Fauth%2Fcallback&response_type=token&scope=vizier&state=$STATE&prompt=login" \
  -H 'authority: work.abc.testdomain.com' \
  -H 'accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9' \
  -H 'accept-language: en-GB,en;q=0.9' \
  -H 'referer: https://work.abc.testdomain.com/auth/login?local_mode=true' \
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

sed -i '' -e "s/login_challenge=/¿/" $TMP_DIR/output1.txt
IFS='¿'
read -a my_array <<< "$(cat $TMP_DIR/output1.txt)"
IFS='"'
read -a my_array <<< "${my_array[1]}"
login_challenge=${my_array[0]}

oauth2_authentication_csrf=$(extractCookie $TMP_DIR/headers1.txt oauth2_authentication_csrf)


##Curl 2
curl -s "https://work.abc.testdomain.com/api/auth/oauth/login?login_challenge=$login_challenge" \
  -H 'authority: work.abc.testdomain.com' \
  -H 'accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9' \
  -H 'accept-language: en-GB,en;q=0.9' \
  -H "cookie: oauth2_authentication_csrf=$oauth2_authentication_csrf" \
  -H 'referer: https://work.abc.testdomain.com/auth/login?local_mode=true' \
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

sed -i '' -e "s/hydra_login_state%3D/¿/" $TMP_DIR/output2.txt
sed -i '' -e "s/%26login_challenge/¿/" $TMP_DIR/output2.txt
IFS='¿'
read -a my_array <<< "$(cat $TMP_DIR/output2.txt)"
hydra_login_state=${my_array[1]}

ossidprovider=$(extractCookie $TMP_DIR/headers2.txt ossidprovider)

##Curl 3
curl -s "https://work.abc.testdomain.com/oauth/kratos/self-service/login/browser?refresh=true&return_to=%2Fapi%2Fauth%2Foauth%2Flogin%3Fhydra_login_state%3D$hydra_login_state%26login_challenge%3D$login_challenge" \
  -H 'authority: work.abc.testdomain.com' \
  -H 'accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9' \
  -H 'accept-language: en-GB,en;q=0.9' \
  -H "cookie: oauth2_authentication_csrf=$oauth2_authentication_csrf; ossidprovider=$ossidprovider" \
  -H 'referer: https://work.abc.testdomain.com/auth/login?local_mode=true' \
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

sed -i '' -e "s/flow=/¿/" $TMP_DIR/output3.txt
IFS='¿'
read -a my_array <<< "$(cat $TMP_DIR/output3.txt)"
IFS='"'
read -a my_array <<< "${my_array[1]}"
flow=${my_array[0]}

csrf_token_dc395c08d3e90de40ef4c0d97c76075e6c9c0500d9dc68488cfc94dfdfa5e5a8=$(extractCookie $TMP_DIR/headers3.txt csrf_token_dc395c08d3e90de40ef4c0d97c76075e6c9c0500d9dc68488cfc94dfdfa5e5a8)
# echo "csrf_token_dc395c08d3e90de40ef4c0d97c76075e6c9c0500d9dc68488cfc94dfdfa5e5a8==========$csrf_token_dc395c08d3e90de40ef4c0d97c76075e6c9c0500d9dc68488cfc94dfdfa5e5a8"

## Curl 4
curl -s "https://work.abc.testdomain.com/oauth/kratos/self-service/login/flows?id=$flow" \
  -H 'authority: work.abc.testdomain.com' \
  -H 'accept: application/json, text/plain, */*' \
  -H 'accept-language: en-GB,en;q=0.9' \
  -H "cookie: oauth2_authentication_csrf=$oauth2_authentication_csrf; ossidprovider=$ossidprovider; csrf_token_dc395c08d3e90de40ef4c0d97c76075e6c9c0500d9dc68488cfc94dfdfa5e5a8=$csrf_token_dc395c08d3e90de40ef4c0d97c76075e6c9c0500d9dc68488cfc94dfdfa5e5a8" \
  -H "referer: https://work.abc.testdomain.com/auth/password-login?flow=$flow" \
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

# cat $TMP_DIR/headers4.txt
# cat $TMP_DIR/output4.txt
# echo ''
# echo ''
# cat $TMP_DIR/output4.txt | sed 's/"name"/\n"name"/g' | grep '"csrf_token"' 
# echo ''
# echo ''
# cat $TMP_DIR/output4.txt | sed 's/"name"/\n"name"/g' | grep '"csrf_token"' | awk -F ',' '{print $3}'
TMP=$(cat $TMP_DIR/output4.txt | sed 's/"name"/\n"name"/g' | grep '"csrf_token"' | sed 's/"value"/\n"value"/g' | grep '"value"' | awk -F ',' '{print $1}')
TMP=${TMP#'"value":"'}
TMP=${TMP%'"'}
csrf_token=$TMP
csrf_token_encoded=$(url_encode $csrf_token)
# echo $csrf_token_encoded

## Curl 5
curl -s "https://work.abc.testdomain.com/oauth/kratos/self-service/login?flow=$flow" \
  -H 'authority: work.abc.testdomain.com' \
  -H 'accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9' \
  -H 'accept-language: en-GB,en;q=0.9' \
  -H 'cache-control: max-age=0' \
  -H 'content-type: application/x-www-form-urlencoded' \
  -H "cookie: oauth2_authentication_csrf=$oauth2_authentication_csrf; ossidprovider=$ossidprovider; csrf_token_dc395c08d3e90de40ef4c0d97c76075e6c9c0500d9dc68488cfc94dfdfa5e5a8=$csrf_token_dc395c08d3e90de40ef4c0d97c76075e6c9c0500d9dc68488cfc94dfdfa5e5a8" \
  -H 'origin: https://work.abc.testdomain.com' \
  -H "referer: https://work.abc.testdomain.com/auth/password-login?flow=$flow" \
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

# cat $TMP_DIR/headers5.txt
csrf_token_dc395c08d3e90de40ef4c0d97c76075e6c9c0500d9dc68488cfc94dfdfa5e5a8=$(extractCookie $TMP_DIR/headers5.txt csrf_token_dc395c08d3e90de40ef4c0d97c76075e6c9c0500d9dc68488cfc94dfdfa5e5a8)
ory_kratos_session=$(extractCookie $TMP_DIR/headers5.txt ory_kratos_session)
# echo $ory_kratos_session

## Curl 6
curl -s "https://work.abc.testdomain.com/api/auth/oauth/login?hydra_login_state=$hydra_login_state&login_challenge=$login_challenge" \
  -H 'authority: work.abc.testdomain.com' \
  -H 'accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9' \
  -H 'accept-language: en-GB,en;q=0.9' \
  -H 'cache-control: max-age=0' \
  -H "cookie: oauth2_authentication_csrf=$oauth2_authentication_csrf; ossidprovider=$ossidprovider; csrf_token_dc395c08d3e90de40ef4c0d97c76075e6c9c0500d9dc68488cfc94dfdfa5e5a8=$csrf_token_dc395c08d3e90de40ef4c0d97c76075e6c9c0500d9dc68488cfc94dfdfa5e5a8; ory_kratos_session=$ory_kratos_session" \
  -H "referer: https://work.abc.testdomain.com/auth/password-login?flow=$flow" \
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
oauth2_consent_csrf=$(extractCookie $TMP_DIR/headers6.txt oauth2_consent_csrf)


## Curl 7
curl -s "https://work.abc.testdomain.com/oauth/hydra/oauth2/auth?client_id=auth-code-client&consent_verifier=$consent_verifier&prompt=login&redirect_uri=https%3A%2F%2Fwork.abc.testdomain.com%2Fauth%2Fcallback&response_type=token&scope=vizier&state=$STATE" \
  -H 'authority: work.abc.testdomain.com' \
  -H 'accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9' \
  -H 'accept-language: en-GB,en;q=0.9' \
  -H 'cache-control: max-age=0' \
  -H "cookie: oauth2_authentication_csrf=$oauth2_authentication_csrf; ossidprovider=$ossidprovider; csrf_token_dc395c08d3e90de40ef4c0d97c76075e6c9c0500d9dc68488cfc94dfdfa5e5a8=$csrf_token_dc395c08d3e90de40ef4c0d97c76075e6c9c0500d9dc68488cfc94dfdfa5e5a8; ory_kratos_session=$ory_kratos_session; oauth2_consent_csrf=$oauth2_consent_csrf" \
  -H "referer: https://work.abc.testdomain.com/auth/password-login?flow=$flow" \
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

TMP=$(cat $TMP_DIR/headers7.txt | grep "access_token=" | sed 's/access_token=/\naccess_token=/g' | sed 's/&expires_in=/\n&expires_in=/g' | grep 'access_token=')
TMP=${TMP#"access_token="}
access_token=$TMP

rm -rf $TMP_DIR
echo $access_token

## Curl 8
# echo 'curl 8'
# curl -s 'https://work.abc.testdomain.com/api/auth/login' \
#   -H 'authority: work.abc.testdomain.com' \
#   -H 'accept: application/json, text/plain, */*' \
#   -H 'accept-language: en-GB,en;q=0.9' \
#   -H 'content-type: application/json' \
#   -H "cookie: oauth2_authentication_csrf=$oauth2_authentication_csrf; ossidprovider=$ossidprovider; csrf_token_dc395c08d3e90de40ef4c0d97c76075e6c9c0500d9dc68488cfc94dfdfa5e5a8=$csrf_token_dc395c08d3e90de40ef4c0d97c76075e6c9c0500d9dc68488cfc94dfdfa5e5a8; ory_kratos_session=$ory_kratos_session; oauth2_consent_csrf=$oauth2_consent_csrf" \
#   -H 'origin: https://work.abc.testdomain.com' \
#   -H 'referer: https://work.abc.testdomain.com/auth/callback' \
#   -H 'sec-ch-ua: "Not_A Brand";v="99", "Google Chrome";v="109", "Chromium";v="109"' \
#   -H 'sec-ch-ua-mobile: ?0' \
#   -H 'sec-ch-ua-platform: "macOS"' \
#   -H 'sec-fetch-dest: empty' \
#   -H 'sec-fetch-mode: cors' \
#   -H 'sec-fetch-site: same-origin' \
#   -H 'user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/109.0.0.0 Safari/537.36' \
#   --data-raw "{\"accessToken\":\"$access_token\"}" \
#   --compressed \
#   --insecure \
#   -c $TMP_DIR/cookies8.txt \
#   -D $TMP_DIR/headers8.txt \
#   --output $TMP_DIR/output8.txt

# cat $TMP_DIR/output8.txt
# echo '-----'

# TMP=$(cat $TMP_DIR/output8.txt | sed 's/"token"/\n"token"/g' | grep '"token"' | sed 's/,/\n/g' | grep '"token"' | sed 's/"//g' | sed 's/token://g')
# AUTH_TOKEN=$TMP
# echo "$AUTH_TOKEN"








