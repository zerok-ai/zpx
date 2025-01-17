#!/bin/bash
THIS_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
PATCHES_DIR=$THIS_DIR
SCRIPTS_DIR="$(dirname "$PATCHES_DIR")"
source $SCRIPTS_DIR/variables.sh

echo ''
echo '-----------------HTTPS-PATCH-----------------'

getUserInput "Do you want to proceed ahead with the vizier patch?" ""
retval=$?
PATCH_VIZIER=$retval

if [ "$PATCH_VIZIER" == '1' ]
then

        PATCH_PREFIX="\/**ZEROK-STARTS**\/"
        PATCH_SUFFIX="\/**ZEROK-ENDS**\/"

        cd $PIXIE_DIR
        
        echo "Applying HTTPS response limit patch"
        FILE='src/stirling/source_connectors/socket_tracer/protocols/http/parse.cc'
        git checkout $FILE
        perl -pi -e "s/DEFINE_uint32\(http_body_limit_bytes, 1024/DEFINE_uint32\(http_body_limit_bytes, 100*1024/" $FILE
        
        FILE='src/stirling/core/data_table.h'
        git checkout $FILE
        perl -pi -e "s/val.resize\(max_string_bytes\);/\/\/val.resize\(max_string_bytes\);/" $FILE
        perl -pi -e "s/val.append\(kTruncatedMsg\);/\/\/val.append\(kTruncatedMsg\);/" $FILE
        perl -pi -e "s/val.shrink_to_fit\(\);/\/\/val.shrink_to_fit\(\);/" $FILE
        
        echo "Applying MYSQL results in response patch"
        FILE='src/stirling/source_connectors/socket_tracer/protocols/mysql/handler.cc'
        git checkout $FILE
        perl -pi -e "s/absl::StrAppend\(&entry->resp.msg, \"Resultset rows = \", results.size\(\)\);/\n\tstd::string resultsString = \"\";\n\tfor \(auto & element : results\) {\n\t\tresultsString = resultsString + element.msg + \" | \";\n\t}\n\n\tabsl::StrAppend\(&entry->resp.msg, \"Resultset rows = \", resultsString\);/" $FILE
        
        cd $ZPX_DIR

fi

