listen 443 ssl spdy;
server_name ${FQDN};

ssl_certificate /etc/ces/ssl/server.crt;
ssl_certificate_key /etc/ces/ssl/server.key;

ssl_session_cache shared:SSL:50m;
ssl_session_timeout 5m;

ssl_prefer_server_ciphers on;
ssl_protocols TLSv1 TLSv1.1 TLSv1.2;
ssl_ciphers  HIGH:!aNULL:!MD5;
