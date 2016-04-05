#!/bin/bash
source /etc/ces/functions.sh
FQDN=$(get_config fqdn)
tries=0
while ! [ $(curl -s -L -w "%{http_code}" "http://localhost:9000/sonar/" -u "admin":"admin" -o /dev/null) -eq 200 ]
do
        ((tries++))
        echo "------------------- INFO  wait for sonar"
        sleep 1
        if [ $tries -gt 200 ]
                then
                        echo "------------------- ERROR  wait for sonar timed out"
                        echo "------------------- INFO  exiting now"
                        kill $!
                        exit 1
        fi
done

curl 'http://127.0.0.1:9000/sonar/settings/update?category=general&subcategory=general' -H 'content-type: application/x-www-form-urlencoded' --data "settings%5Bsonar.core.serverBaseURL%5D=https://$FQDN/sonar/&page_version=1" -u "admin":"admin"
#settings%5Bsonar.links.ci%5D=&settings%5Bsonar.ce.maxLogsPerTask%5D=&settings%5Bsonar.preview.includePlugins%5D=&settings%5Bsonar.preview.excludePlugins%5D=&settings%5Bsonar.links.scm%5D=&
