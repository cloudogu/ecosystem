# Dogu upgrades

Starting with version 0.14 of the `cesapp`, dogus can be upgraded with the `upgrade` command. In order to help with upgrading a Dogu, available upgrades can be listed with `list-upgrades`.

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

* stop all dogus depending on the one to be upgraded
* execute the pre-upgrade script, if configured
* remove old container
* start new container
* execute post-upgrade script, if configured
* start all dogus depending on the one to be upgraded

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

***Please Note:*** 

The configuration for the upgrade scripts is always loaded from the new version of the dogu. The new dogu knows, what is required for the update.
 
If a pre-upgrade script is defined in the new version, then it is extracted from the **new image** into the **old container**. This enables the execution of the pre-update script in the **old container**. 

The post-upgrade is executed after the **new container** is started.
 
This behaviour is useful for complicated tasks such as dump (pre-upgrade) and restore (post-upgrade).