#!/bin/bash

THIS_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
mkdir $THIS_DIR/.tmp
export TMP_DIR=$THIS_DIR/.tmp

# PX_DOMAIN=testpxsetup7.testdomain.com
export PX_DOMAIN=$1
ADD_DEBUG_LOGS=0
ADD_DEBUG_LOGS_ARG=$2

if [ -z "$ADD_DEBUG_LOGS_ARG" ] || [ "$ADD_DEBUG_LOGS_ARG" == "0" ]; then
  ADD_DEBUG_LOGS=0
else
  ADD_DEBUG_LOGS=1
fi

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
export -f extractCookie

validateResponseStatus(){
  FILE=$1
  HTTP_LINE=$(cat $FILE | head -n 1)
  IFS=' '
	read -r name value value2 <<< "$HTTP_LINE"
  # echo $name
  # echo $value
  # echo $value2
  # STATUS=$(cat $FILE | head -n 1 | sed 's/HTTP\/2\ //g' | sed 's/\ //g')
  # echo "$STATUS|"
  if [[ "$value" == "000" ]]
  then
    return 0
  elif [[ $value > 400 ]]
  then
    return 0
  else
    return 1
  fi 
}

log(){
  MESSAGE=$1
  if [ "$ADD_DEBUG_LOGS" == "1" ]
  then
    echo "$MESSAGE"
  fi
}
export -f log

logcat(){
  FILE=$1
  if [ "$ADD_DEBUG_LOGS" == "1" ]
  then
    cat $FILE
  fi
}
export -f logcat

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
export -f url_encode