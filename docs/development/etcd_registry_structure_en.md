# Etcd registry structure

The configuration and execution of the Cloudogu EcoSystem (CES) relies on an [etcd](https://coreos.com/etcd/) registry. It holds key-value pairs which can be listed by using the `etcdctl ls` command. The key-value pairs are altered by the CES tools and dogus and should not be changed manually unless you know exactly what you are doing!

## Registry structure details

### /docker

This path is used by docker to store operational characteristics. The keys stored here should never be changed manually.

### /config

This path holds configuration of all installed dogus and global configuration.

#### /config/_global

This path holds configuration that is used by multiple tools in the CES, e.g. the FQDN, Domain, CES admin group, the default dogu and certificates.

Some of the key paths are:

- /config/_global/key_provider
- /config/_global/fqdn
- /config/_global/domain
- /config/_global/certificate
- /config/_global/admin_group
- /config/_global/default_dogu

#### /config/DOGUNAME

In paths like "/config/jenkins", the dogu-specific configuration is stored.

One key that is always present is "/config/DOGUNAME/public.pem" which holds the public key to encrypt data that should only be readable by the dogu itself.

The amount of other configuration keys varies widely among the dogus. Most of their purpose is described in the correlating dogu.json.

If manual alteration of the dogu configuration keys is needed, a comfortable way to do so is via the `cesapp edit-config DOGUNAME` command.

### /dogu

This path holds technical information about the dogus. In keys like "/dogu/sonar/6.7.6-1" the information of the dogu.json is saved in JSON format.

There keys stored here are automatically created when a dogu is installed and should never be changed manually.

### /state

The keys stored here (e.g. "/state/jenkins") hold information about the execution state of the dogus. Their values are set from within the dogus via the `doguctl state` command. They are part of a health check which can be declared by setting "Type": "state" inside the "HealthChecks" object of a dogu.json.

The state keys are utilized when a health check is performed on a dogu via the `cesapp healthy DOGUNAME` command. If the corresponding "/state/DOGUNAME" key holds the string "ready", the health check succeeds.

### /services


## Updating certificates

If you want to update the certificate (chain) of your EcoSystem, please follow this procedure:

### Self-signed certificates

- Run the script `/usr/local/bin/ssl.sh`, e.g. via `sudo /usr/local/bin/ssl.sh`
- Restart your EcoSystem

### External certificates
- External keys and certificates have to be available in PEM format
- Save the private key of your certificate in the etcd key `/config/_global/certificate/server.key`, e.g. via `cat private_key.pem | etcdctl set /config/_global/certificate/server.key`
- Save the certificate (chain) in the etcd key `/config/_global/certificate/server.crt`
   - If you only want to import one certificate, do so via `cat certificate.pem | etcdctl set /config/_global/certificate/server.crt`
   - If you want to import a certificate chain, please make sure to have all certificates (instance, intermediates) in the correct order: First the instance certificate, followed by the intermediate certificate(s).
- Restart your EcoSystem
