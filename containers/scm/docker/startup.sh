#!/bin/bash
source /etc/ces/functions.sh
echo "1"
if ! [ -d /var/lib/scm/plugins/de/triology/scm/plugins/scm-cas-plugin ]
	then
		echo "No cas-plugin"
		/opt/scm-server/bin/scm-server &
		FQDN=$(get_fqdn)
		while ! [ $(curl -sL -w "%{http_code}" "http://localhost:8080/scm/api/rest/plugins/installed" -u scmadmin:scmadmin -o /dev/null) -eq 200 ]
		do
			echo "wait for scm"
			sleep 1
		done
		echo "Install scm-cas-plugin"
		/usr/bin/curl -X POST http://localhost:8080/scm/api/rest/plugins/install/de.triology.scm.plugins:scm-cas-plugin:1.7 -u scmadmin:scmadmin
		mkdir "/var/lib/scm/config"
	  render_template "/opt/scm-server/conf/cas_plugin.xml.tpl" > "/var/lib/scm/config/cas_plugin.xml"
		echo "2"
		kill $!
fi
echo "3"
exec /opt/scm-server/bin/scm-server
