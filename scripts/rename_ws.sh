#!/bin/bash

WS=`i3-msg -t get_workspaces | jq -r '.[] | select(.focused==true).name'`
echo $WS
i3-input -F 'rename workspace to "'"${WS:0:1}"':%s"' -P 'New name: '
