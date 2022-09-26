#!/bin/sh

speed=$(liquidctl --match h115i status --json | jq '[.[0].status[1,3].value] | max')

if [ "$speed" != "" ]; then
    echo "$speed RPM"
else
   echo ""
fi
