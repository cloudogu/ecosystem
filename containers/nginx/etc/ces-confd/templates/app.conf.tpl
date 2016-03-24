server {
  include /etc/nginx/include.d/ssl.conf;

  # default proxy settings
  proxy_set_header Host $http_host;
  proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
  proxy_set_header X-Forwarded-Proto https;
  proxy_set_header X-Real-IP $remote_addr;
  proxy_set_header X-Scheme $scheme;
  proxy_set_header X-Real-IP $remote_addr;
  # disable gzip encoding for proxy applications
  proxy_set_header Accept-Encoding identity;

  include /etc/nginx/include.d/warp.conf;

{{range .}}{{if (eq .Name "universeadm")}}
  # redirect to /universeadm
  location = / {
    return 301 https://$host/universeadm;
  }
{{end}}{{end}}

  # services
{{range .}}
  location /{{.Name}} {
    proxy_pass {{.URL}};
  }
{{end}}
  # end of services
}
