#!/bin/bash
set -e  

curl --request GET --url 'https://api.getpostman.com/environments/651996-b80ed237-9179-35ec-d8a1-35d574e118c8' --header 'X-Api-Key: 100822fe2bd7454eb916c8ebdd4be266' > ci.json
wget -O collection.json https://www.getpostman.com/collections/29c4e07a8d6d539a954e
# bzt ./test.yml -o modules.blazemeter.report-name="$REPORT"
bzt ./test.yml -o modules.blazemeter.report-name="debug-1"

ls -la

# curl -H "Content-Type: text/xml" -X POST -H "Authorization: Bearer $token" --data @"outputfile.xml" https://xray.cloud.xpand-it.com/api/v1/import/execution/junit?testExecKey=$XRAY_PERF_TEST
curl -H "Content-Type: text/xml" -X POST -H "Authorization: Bearer $token" --data @"outputfile.xml" https://xray.cloud.xpand-it.com/api/v1/import/execution/junit?testExecKey=GL-14