#!/bin/bash
set -e 

# sleep 30

newman run https://www.getpostman.com/collections/29c4e07a8d6d539a954e --reporters cli,junit --reporter-junit-export outputfile.xml --environment https://api.getpostman.com/environments/651996-b80ed237-9179-35ec-d8a1-35d574e118c8?apikey=100822fe2bd7454eb916c8ebdd4be266 --folder airports
# newman run https://www.getpostman.com/collections/29c4e07a8d6d539a954e --reporters cli,junit --reporter-junit-export outputfile.xml --environment https://api.getpostman.com/environments/651996-f4ff0aa5-3c70-edbe-ddb1-d81231001eb4?apikey=100822fe2bd7454eb916c8ebdd4be266 --folder airports

sed -i -e 's/<testcase/<testcase classname=\"CI.GLPLAMBDAAIR\"/g' outputfile.xml

export token=$(curl -H "Content-Type: application/json" -X POST --data "{ \"client_id\": \"BFA4CE54FF254CA99431F2553C992A48\",\"client_secret\": \"8bf82f7dc63f8513a6c29c8088400e825930602e48c99bfa501fcef0708fd5a1\" }" https://xray.cloud.xpand-it.com/api/v1/authenticate| tr -d '"')

curl -H "Content-Type: text/xml" -X POST -H "Authorization: Bearer $token" --data @"outputfile.xml" https://xray.cloud.xpand-it.com/api/v1/import/execution/junit?testExecKey=GL-9