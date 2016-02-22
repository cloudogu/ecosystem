#!/bin/bash
source /etc/ces/functions.sh
if ! [ -d /var/lib/scm/plugins/de/triology/scm/plugins/scm-cas-plugin ]
	then
		echo "no cas-plugin installed"
		/opt/scm-server/bin/scm-server &
		tries=0
		while ! [ $(curl -sL -w "%{http_code}" "http://localhost:8080/scm/api/rest/plugins/installed" -u scmadmin:scmadmin -o /dev/null) -eq 200 ]
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
		echo "install scm-cas-plugin"
		/usr/bin/curl -X POST http://localhost:8080/scm/api/rest/plugins/install/de.triology.scm.plugins:scm-cas-plugin:1.7 -u scmadmin:scmadmin

		kill $!
fi
FQDN=$(get_fqdn)
mkdir "/var/lib/scm/config"
render_template "/opt/scm-server/conf/cas_plugin.xml.tpl" > "/var/lib/scm/config/cas_plugin.xml"
exec /opt/scm-server/bin/scm-server
