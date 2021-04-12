**Note**: This file has been automatically translated!

# Special features when changing the global admin group

Cloudogu EcoSystem (CES) provides a factory default admin group that is assigned to user accounts that administer this CES instance. The name of this admin group can be renamed, but only with certain precautions.

By changing the global admin group, the admin groups in all dogus must also be updated. How to make this change and what to keep in mind is explained in more detail in this document.

## Change entry in registry
With the command:
```
etcdctl set /config/_global/admin_group "<new name>"
```
the admin group name can be changed in the registry. Afterwards, the new value will be printed if the change was successful.
Additionally, the change can also be verified with the following command:
```
etcdctl get /config/_global/admin_group
```
The output will be the name of the admin group.

Necessary steps to change the admin group:
```
1. create new admin group (if not existing)
2. enrich admin group with user accounts
3. change admin group in registry
4. restart Dogu(s)
```

## Dogu specific features
The different Dogus handle the admin group change differently. The following is an explanation of the peculiarities.

### SonarQube `(from Dogu version 6.7.7-2)`
SonarQube creates the appropriate admin group in the `startup.sh` script and gives it the necessary permissions. Additionally, the current admin group is also stored in the Dogu configuration within the registry under the path `/config/sonar/admin_group_last`.
> **The value of `/config/sonar/admin_group_last` must never be adjusted manually.** (see point `Special case`)

When Sonar-Dogus is restarted, it checks if the global admin group and the admin group stored for Sonar are different.

The following cases can occur:.

1. there is no difference and the Dogu starts as usual.
   1. at the first Dogu start the admin group is created accordingly. At a restart this group remains unchanged.
2. the names of the admin groups are different
   1. the new group is created and gets the necessary rights.
   2. the admin group last used by the dogu is stripped of all administrative permissions. However, the group will still exist.

#### Special case
By manually changing the configuration entry `/config/sonar/admin_group_last` it can contain the name of a non-existing admin group.

Sonar is then stuck in an endless restart loop. The dogu is thus not usable.
To solve the problem it is sufficient to start with:
```
etcdctl set /config/sonar/admin_group_last "<name>"
```
to set a valid value. Alternatively, the entry can be removed completely with the following command.
```
etcdctl rm /config/sonar/admin_group_last
```


### Sonatype Nexus `(from Dogu version 3.18.1-01-1)`

*The general flow of admin group migration is the same as SonarQube.

Nexus creates the appropriate admin group in the `startup.sh` script and grants it the necessary permissions. Additionally, the current admin group is also stored in the Dogu configuration within the registry under the path `/config/nexus/admin_group_last`.

If the value of `/config/nexus/admin_group_last` is changed manually, the migration process is restarted, resulting in the current admin group being given admin rights again, the manually entered group under `[...]/admin_group_last` being stripped of admin rights again, and the configuration value being overwritten with the current admin group.
