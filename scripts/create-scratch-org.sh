#!/bin/bash
source `dirname $0`/config.sh

execute() {
  $@ || exit
}

if [ -z "$DEV_HUB_URL" ]; then
  echo "set default devhub user"
  execute sf config set target-dev-hub=$DEV_HUB_ALIAS

  echo "Deleting old scratch org"
  sf org delete scratch --no-prompt --target-org $SCRATCH_ORG_ALIAS
fi

echo "Creating scratch org"
execute sf org create scratch --alias $SCRATCH_ORG_ALIAS --set-default --definition-file ./config/project-scratch-def.json --duration-days 30

echo "Pushing changes to scratch org"
execute sf project deploy start

echo "Assigning permissions"
execute sf org assign permset --name Admin 

echo "Make sure Org user is english"
sf data update record --sobject User --where "Name='User User'" --values "Languagelocalekey=en_US"

echo "Create sample data"
execute sfdx force:apex:execute -f scripts/resetData.apex

echo "Running Apex Tests"
execute sf apex run test --test-level RunLocalTests --wait 30 --code-coverage --result-format human

echo "Running SFX Scanner with Security rules"
sf scanner run --format csv --outfile CodeAnalyzerGeneral.csv --target ./ --category Security
sf scanner run --engine pmd-appexchange --format csv --outfile CodeAnalyzerPmdAppExchange.csv --target ./
sf scanner run dfa --format csv --outfile CodeAnalyzerDFA.csv --target ./ --projectdir ./ --category Security

