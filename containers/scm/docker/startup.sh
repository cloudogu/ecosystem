#!/bin/bash
source /etc/ces/functions.sh
# Installuser should be generated
admusr="scmadmin"
admpw="scmadmin"
autoupdate="1"
FQDN=$(get_fqdn)
MAILFROM="cloudoguscm@cloudogu.com"
RELAYHOST="postfix"
/opt/scm-server/bin/scm-server &
tries=0
while ! [ $(curl -sL -w "%{http_code}" "http://localhost:8080/scm/api/rest/plugins/overview.json" -u "$admusr":"$admpw" -o /dev/null) -eq 200 ]
do
	((tries++))
	echo "wait for scm"
	sleep 1
	if [ $tries -gt 200 ]
		then
			echo "scm didnt start"
			echo "exit now"
			kill $!
			exit 1
	fi
done
# Plugin installation start
# get plugin state (json) and list of installed and available plugins
pluginState=$(/usr/bin/curl "http://localhost:8080/scm/api/rest/plugins/overview.json" -u "$admusr":"$admpw")
pluginAvail=$(/usr/bin/curl "http://localhost:8080/scm/api/rest/plugins/available.json" -u "$admusr":"$admpw")
echo "pluginState: $pluginState"
echo "================ plugin installation loop ================"
for i in $(cat /opt/scm-server/conf/pluginlist); do
	echo "================== installing $i plugin =================="
	version=$(echo "$pluginState" | jq ".[] | select (.name==\"$i\") | .version" --raw-output)
	groupId=$(echo $pluginState | jq ".[] | select (.name==\"$i\") | .groupId" --raw-output)
	state=$(echo $pluginState | jq ".[] | select (.name==\"$i\") | .state" --raw-output)
	versionAvail=$(echo $pluginAvail | jq ".[] | select (.name==\"$i\") | .version" --raw-output)
	echo "=========================================================="
	echo "Plugin :$i"
	echo "Version: $version"
	echo "availableVersion: $versionAvail"
	echo "Vendor: $groupId"
	echo "Status: $state"
	echo "=========================================================="
	# NOT INSTALLED --> INSTALL
	if [ "$state" == "AVAILABLE" ]; then
		/usr/bin/curl -s -X POST "http://localhost:8080/scm/api/rest/plugins/install/$groupId:$i:$version" -u "$admusr":"$admpw"
		echo "===================== installed $i ======================="
	else
	# INSTALLED AND OUTDATED --> UPDATE
		if ! [ "$version" == "versionAvail" ] || [ "$autoupdate" == "1" ]; then
			/usr/bin/curl -s -X POST "http://localhost:8080/scm/api/rest/plugins/update/$groupId:$i:$version" -u "$admusr":"$admpw"
			echo "====================== updated $i ========================"
		fi
	fi
done
if ! [ -d "/var/lib/scm/config" ];  then
	mkdir -p "/var/lib/scm/config"
fi
# configure scm-cas-plugin
render_template "/opt/scm-server/conf/cas_plugin.xml.tpl" > "/var/lib/scm/config/cas_plugin.xml"
# configure scm-mail-plugin
render_template "/opt/scm-server/conf/mail.xml.tpl" > "/var/lib/scm/config/mail.xml"
# Plugin installation end
kill $!

exec /opt/scm-server/bin/scm-server
