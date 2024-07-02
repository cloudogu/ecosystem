# Administration notes

## Authorizations of new users in User Management
### Groups
A newly created user has no groups assigned to him. Basically, there are always two groups available
which can be assigned to a user. The "cesManager" group and the "cesAdmin" group. Furthermore
further groups can be added in the user management under the tab "Groups" and assigned to the users.
be assigned to the users. These groups are transferred to the individual Dogus and can be authorized there. 

Further information on rights management can be found [here](https://docs.cloudogu.com/en/usermanual/usermgt/documentation/#permission-concept-in-the-cloudogu-ecosystem).

#### cesManager group
A user in the cesManager group has access to the Administrative Dogus, such as the Backup & Restore Dogu.

#### cesAdmin Group
The name of this group is selected during CES setup and therefore may vary. Users in this group get all administrative
administrative permissions in all dogus.

## Common problems
### Manually created users and groups
In some dogus it leads to problems when a user is created in the dogu. Basically, a user must be created in User Management so that it can log in to all dogus.
Some dogus additionally support the manual creation of users, but in others it can lead to problems.

If it is not possible in a dogu for a certain user, which has already been created in User Management, to log in to the dogu, the reason may be that the user was created manually in the dogu.

If this is the case, the user must be deleted in this Dogu. The user will then be automatically synchronized with the Dogu the first time he logs in.

The same applies to groups that were created manually. If there are any problems with this, they must also be deleted in the dogu.

### Change of user data

If a user's data changes, such as their name, these changes must be made in User Management. Changes in the individual dogus are ineffective, as they will be overwritten with those from User Management the next time the user logs in.
The synchronization of user data takes place at the time of login in a dogu. For example, if a user's name is changed in User Management, this will not be visible in a Dogu until the user has logged in there after the change.

