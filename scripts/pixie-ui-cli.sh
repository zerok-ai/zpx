#!/bin/bash
THIS_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source $THIS_DIR/variables.sh
TMP_DIR=$UTILS_DIR/.tmp


helpFunction()
{
   echo ""
   echo 'Usage: $0 [options]
         Options are listed below:
         -c \t\t\t\t\t//command [cluster|apikey|domain]
         -l \t\t\t\t\t//debug logs'

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
        # -d)
        #      FETCH_DOMAIN=1
        #      shift; 
        #      ;;
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




if [ -z "$COMMAND" ]
then
    echo "Command is required"
    helpFunction
    exit 1
fi

# if [ "$FETCH_DOMAIN" == "1" ]
# then
#     echo $PX_DOMAIN
# fi

if [ "$COMMAND" == "apikey" ]
then
    i=0
    until [[ $i -gt $MAX_ATTEMPTS  ]]
    do
        rm -rf $TMP_DIR
        # echo "APIKEY-$i"
        APIKEY=$($UTILS_DIR/extract-auth-token-v2.sh $DOMAIN $DEBUG_LOGS)
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
    echo $PX_DOMAIN
else
    echo "Invalid command passed"
    helpFunction
    exit 1
fi

