# Dogu upgrades

Starting with version 0.14 of the `cesapp` dogu can be upgraded with the `upgrade` command and available upgrade can be listed with `list-upgrades`.

## Usage

```bash
# list available upgrades
cesapp list-upgrades

# upgrade to latest scm version
cesapp upgrade scm

# upgrade to version 1.53-1 of scm
cesapp upgrade scm 1.53-1

# upgrade to version 1.52-1 and ignore version conflicts
cesapp upgrade scm 1.52-1 --force

```

## Upgrade steps

During the upgrade process the `cesapp` will execute the following list of steps:

* stop all depending dogus
* execute the pre-upgrade script, if it is configured
* remove old container
* start new container
* execute post-upgrade script, if it is configured
* start depending dogus

## Upgrade scripts

The upgrade scripts can be defined in the dogu.json e.g.:

```json
{
  "Name": "upgradable-dogu",
  "Version": "0.2.0",
  "DisplayName": "Upgradable Dogu",
  "Image": "registry.cloudogu.com/sample/upgradable-dogu",
  "ExposedCommands": [{
    "Name": "pre-upgrade",
    "Command": "/pre-upgrade.sh"
  }, {
    "Name": "post-upgrade",
    "Command": "/post-upgrade.sh"
  }]
}
```

Note the script configuration is always loaded from the new version of the dogu. 
If a pre-upgrade script is defined in the new version, the it is copied from the **new image** in to the **old container** and is executed in the **old container**. The post-upgrade is executed after the **new container** is started. 
This behaviour is useful for complicated tasks such as dump (pre-upgrade) and restore (post-upgrade).