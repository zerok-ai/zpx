#!/bin/bash
THIS_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source $THIS_DIR/variables.sh
TMP_DIR=$UTILS_DIR/.tmp


helpFunction()
{
   echo ""
   echo -e '\tUsage: $0 [options]
         \tOptions are listed below:
         \t-d \t\t\tuse a different domain
         \t-c \t\t\tcommand [cluster|apikey|domain|token]
         \t-l \t\t\tdebug logs'

   exit 1 # Exit script after printing help
}

DOMAIN=$PX_DOMAIN
DEBUG_LOGS=0
COMMAND=""
MAX_ATTEMPTS=5

while [ $# -ne 0 ]; do
    case "$1" in
        -l)
            DEBUG_LOGS=1;
            shift;
            ;;
        -d)
             DOMAIN=$2
             shift; shift;
             ;;
        -c)
             COMMAND=$2
             shift; shift;
             ;;
        -h)
             helpFunction
             exit 2
             ;;
        -*)
             echo "Unknown option: $1" >&2
             helpFunction
             exit 2
             ;;
        *)
             break
             ;;
    esac
done

if [ -z "$DOMAIN" ]
then
    DOMAIN=$PX_DOMAIN
fi

if [ -z "$COMMAND" ]
then
    echo "Command is required"
    helpFunction
    exit 1
fi

if [ "$COMMAND" == "apikey" ]
then
    i=0
    until [[ $i -gt $MAX_ATTEMPTS  ]]
    do
        rm -rf $TMP_DIR
        # echo "APIKEY-$i"
        APIKEY=$($UTILS_DIR/extract-api-key.sh $DOMAIN $DEBUG_LOGS)
        if ! [ -z "$APIKEY" ]
        then
            echo $APIKEY
            break;
        fi
        ((i++))
    done
    rm -rf $TMP_DIR
elif [ "$COMMAND" == "token" ]
then
    i=0
    until [[ $i -gt $MAX_ATTEMPTS  ]]
    do
        rm -rf $TMP_DIR
        # echo "APIKEY-$i"
        TOKEN=$($UTILS_DIR/extract-auth-token.sh $DOMAIN $DEBUG_LOGS)
        if ! [ -z "$TOKEN" ]
        then
            echo $TOKEN
            break;
        fi
        ((i++))
    done
    rm -rf $TMP_DIR
elif [ "$COMMAND" == "cluster" ]
then
    i=0
    until [[ $i -gt $MAX_ATTEMPTS  ]]
    do
        rm -rf $TMP_DIR
        # echo "COMMAND-$i"
        CLUSTERID=$($UTILS_DIR/extract-cluster-id.sh $DOMAIN $DEBUG_LOGS)
        if ! [ -z "$CLUSTERID" ]
        then
            echo $CLUSTERID
            break;
        fi
        ((i++))
    done
    rm -rf $TMP_DIR
elif [ "$COMMAND" == "domain" ]
then
    echo $DOMAIN
else
    echo "Invalid command passed"
    helpFunction
    exit 1
fi

