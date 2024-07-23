#!/bin/bash
# Copyright (C) MuleSoft, Inc. All rights reserved. http://www.mulesoft.com
#
# The software in this package is published under the terms of the
# Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International Public License,
# a copy of which has been included with this distribution in the LICENSE.txt file.
#
# Usage: upload-monitor.sh -u <USER> -p <PASS> -o <ORG> -s <SLACK_URL>
set -Eeuo pipefail

scriptdir="$(cd "$(dirname "$0")" && pwd)"
cd $scriptdir

AP_BASE_URI="https://anypoint.mulesoft.com"

while getopts u:p:o:s: option
do
case "${option}"
in
u) AP_USERNAME=${OPTARG};;
p) AP_PASSWORD=${OPTARG};;
o) AP_ORG_ID=${OPTARG};;
s) SLACK_WEBHOOK_URL=${OPTARG};;
esac
done

echo "getting token"
export TOKEN=$(curl --silent -d "username=$AP_USERNAME&password=$AP_PASSWORD" ${AP_BASE_URI}/accounts/login | jq -r .access_token)

echo "Getting targets"

export TARGET_ID=$(curl --silent  -H "Authorization: Bearer $TOKEN" -X GET ${AP_BASE_URI}/apitesting/xapi/v1/organizations/${AP_ORG_ID}/targets | jq -r '.[1].id'
)
echo $TARGET_ID
export SUITES=$(curl -X GET -H "Authorization: Bearer $TOKEN" ${AP_BASE_URI}/apitesting/xapi/v1/organizations/${AP_ORG_ID}/versions?includeDeprecated=false)
bat login --username=$AP_USERNAME --password=$AP_PASSWORD
builds=$(find . -type d | grep -E 'target/test-classes/funmon$' | sort)
for build in $builds; do
	wt=$(dirname $build)                              || exit 10
	echo "Building $wt:"                              || exit 11
	for d in ./$wt/funmon/config/*.dwl ; do 
		(
		cd "./$wt/funmon" &&
		d=${d##*/}
		export ASSET_ENV="${d%.*}"
		echo $ASSET_ENV
		if [ "$ASSET_ENV" == "common" ]  || [ "$ASSET_ENV" == "default" ]; then
			echo 'in continue'
              continue;
        fi	
#		export ASSET_ID="$(jq -r '.assetId' < exchange.json)-$ASSET_ENV"
#		export ASSET_VERSION=$(jq -r '.version' < exchange.json)
##		echo $SUITES 
#		export ASSET_SUITES=$(echo $SUITES | jq -r '.[] | select( .assetId == "'"$ASSET_ID"'" ).version')
#		echo $ASSET_SUITES

		sed -i '.bak' "s,%SLACK_WEBHOOK_URL%,$SLACK_WEBHOOK_URL,g" bat.yaml
#		rm -f blob
#		zip -A blob "$d"exchange.json "$d"main.dwl "$d"bat.yaml
#		export NEW_VERSION=$(curl -H "Authorization: Bearer $TOKEN" --form "file=@blob;type=application/zip" ${AP_BASE_URI}/apitesting/xapi/v1/organizations/${AP_ORG_ID}/suites/assets/${AP_ORG_ID}:${ASSET_ID}:${ASSET_VERSION}?name=${ASSET_ID} | jq -r '.version')
#		echo $NEW_VERSION
#		echo "Creating execution"
#		curl -i -H "Authorization: Bearer $TOKEN" -H "Content-Type: application/json" --data '{"targetId": "'"$TARGET_ID"'","configuration":"default"}'  ${AP_BASE_URI}/apitesting/xapi/v1/organizations/${AP_ORG_ID}/suites/${AP_ORG_ID}:${ASSET_ID}/versions/${NEW_VERSION}/executions
#		echo "Creating schedule"
#		curl -i -H "Authorization: Bearer $TOKEN" -H "Content-Type: application/json" --data '{"targetId": "'"$TARGET_ID"'","configuration":"default","cronExpression":"0 */5 * ? * *","scheduledInterval":"CRON_EXPRESSION","version":"'"$NEW_VERSION"'"}' ${AP_BASE_URI}/apitesting/xapi/v1/organizations/${AP_ORG_ID}/suites/${AP_ORG_ID}:${ASSET_ID}/schedules
#		for i in $ASSET_SUITES; do
#			#if [[ "$NEW_VERSION" != "$i" ]]; then
#				echo "Deleting previous version:" $i
#				curl -i -X DELETE -H "Authorization: Bearer $TOKEN" ${AP_BASE_URI}/apitesting/xapi/v1/organizations/${AP_ORG_ID}/suites/${AP_ORG_ID}:${ASSET_ID}/versions/$i
#			#fi
#		done
		bat schedule create --config=$ASSET_ENV --location=$TARGET_ID --cron='0 */5 * ? * *' 
		);
		
	done
done || exit 1