#!/bin/bash
THIS_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
TMP_DIR=$THIS_DIR/.tmp


helpFunction()
{
   echo ""
   echo 'Usage: $0 [options]
         Options are listed below:
         -d \t\t\t\t\t//domain
         -c \t\t\t\t\t//command [cluster|apikey]
         -l \t\t\t\t\t//debug logs'

   exit 1 # Exit script after printing help
}

DOMAIN=""
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
    echo "Domain is required"
    helpFunction
    exit 1
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
        APIKEY=$($THIS_DIR/extract-api-key.sh $DOMAIN $DEBUG_LOGS)
        if ! [ -z "$APIKEY" ]
        then
            echo $APIKEY
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
        CLUSTERID=$($THIS_DIR/extract-cluster-id.sh $DOMAIN $DEBUG_LOGS)
        if ! [ -z "$CLUSTERID" ]
        then
            echo $CLUSTERID
            break;
        fi
        ((i++))
    done
    rm -rf $TMP_DIR
else
    echo "Invalid command passed"
    helpFunction
    exit 1
fi

