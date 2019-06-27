#!/bin/bash

clear
source `dirname $0`/local-config.sh

# sfdx force:auth:web:login -a $TARGET_ORG_ALIAS
sfdx force:source:deploy -p ./force-app  -l RunLocalTests -u $TARGET_ORG_ALIAS -w 15
