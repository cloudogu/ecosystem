# Dogu Configuration

Custom configuration settings are stored in the registry (etcd) of the Cloudogu EcoSystem. Their are two keys which are relevant for a dogu:

* **/config/nameOfDogu** (dogu specific settings)
* **/config/_global** (global settings)

## Usage

A dogu is able to retrieve this settings with the `doguctl` command line util e.g.:

```bash
# read setting test from /config/conf-dogu/title
doguctl config title

# read encrypted setting secret from /config/conf-dogu/secret
doguctl config -e secret

# read global setting admin_group from /config/_global/admin_group
doguctl config -g admin_group
```

## Validation

The `cesapp` is able to validate those settings (since 0.14), if the dogu defines a configuration section in the *dogu.json* e.g.:

```json
{
  "Name": "sample/conf-dogu",
  "Version": "0.1.0",
  "DisplayName": "Conf Dogu",
  "Description": "Dogu with configuration",
  "Image": "registry.cloudogu.com/sample/conf-dogu",
  "URL": "https://cloudogu.com",
  "Configuration": [{
    "Name": "title",
    "Description": "Title of index page"
  }, {
    "Name": "secret",
    "Description": "Encrypted secret",
    "Encrypted": true
  }, {
    "Name": "body",
    "Description": "Body of the index page",
    "Optional": true
  }]
}
```

The `cesapp` will throw an error, if a required settings in the registry is missing (title or secret in the example above).

## Editing

The settings of a dogu can be changed or created with the `edit-config` sub comand of the `cesapp`. 
The command can be used with a path to a *dogu.json*, with the name of a installed dogu or with a remote name e.g.:

```bash
# edit settings of a local dogu.json which is located in /vagrant/containers/conf-dogu
cesapp edit-config /vagrant/containers/conf-dogu

# edit settings of local /vagrant/containers/conf-dogu/dogu.json
cesapp edit-config /vagrant/containers/conf-dogu/dogu.json

# edit settings of a remote json
cesapp edit-config sample/conf-dogu

# edit settings of a installed dogu
cesapp edit-config conf-dogu
```

By default settings can only be changed and not removed. If is it necessary to remove a setting from the registry the `edit-config` sub command, must be used with the `delete-on-empty`.

```bash
cesapp edit-config --delete-on-empty conf-dogu
```

When now a configuration value is empty, the setting will be removed from the registry.