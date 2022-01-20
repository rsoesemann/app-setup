#!/bin/bash

echo "> QWeb tests"
URL="$(sfdx force:org:open -r --json | jq -r '.result.url')"
robot --outputdir qweb --variable AUTH_URL:$URL ./qweb/functional-tests.robot 

echo "> Apex tests"
execute sfdx force:apex:test:run -l RunLocalTests --synchronous

echo "> Salesforce CLI Scanner"
execute sfdx scanner:run --target "force-app" --pmdconfig "ruleset.xml"

echo "> Jest tests"
if [ -f "package.json" ]; then
  echo "Running jest tests"
  execute npm install 
  execute npm run test:unit
fi