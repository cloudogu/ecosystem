# Automatic security updates in the CES

There are [multiple options](https://help.ubuntu.com/community/AutomaticSecurityUpdates) to activate automatic security updates in Ubuntu. The most common one is using the "unattended-upgrades" package. This package automatically installs apt package updates as soon as they become available.
As this behavior may interfere with the administrator's wish to have the machine under control, the "unattended-upgrades" package is deactivated in the CES.

To reactivate the "unattended-upgrades" package and activate automatic security updates in the CES, please follow these steps:

- Remove the file `/etc/apt/apt.conf.d/99_disable_periodic_update`
- Enable the `apt-daily.timer` service:
  - `sudo systemctl enable apt-daily.timer`
  - `sudo systemctl start apt-daily.timer`
- Make sure the file `/etc/apt/apt.conf.d/20auto-upgrades` holds the following content:

```
APT::Periodic::Update-Package-Lists "1";
APT::Periodic::Unattended-Upgrade "1";
```

- Make sure the following lines are not commented out in `/etc/apt/apt.conf.d/50unattended-upgrades`:

```
"${distro_id}:${distro_codename}";
"${distro_id}:${distro_codename}-security";
```

- Enable the `unattended-upgrades` service:
  - `sudo systemctl enable unattended-upgrades`
  - `sudo systemctl start unattended-upgrades`

To validate that automatic updates are activated, run the command `apt-config dump APT::Periodic::Unattended-Upgrade`.
The output should be: `APT::Periodic::Unattended-Upgrade "1";`

## Troubleshooting
## Ubuntu versions <= 18.04 no longer receive apt updates.
As of April 2023, the LTS version of [Ubuntu 18.04 will no longer receive updates](https://ubuntu.com/about/release-cycle).
For this reason, the Cloudogu Ecosystem (CES) will also no longer support Ubuntu version 18.04. In addition, Cloudogu's apt repository, from which the Cloudogu EcoSystem apt packages are pulled, has also been changed.
If you are now using an older Cloudogu version, we suggest you update your Ubuntu version to at least 20.04. Please run an update with the following commands first:
```shell
apt-get update
apt-get upgrade
```
The package `ces-commons` should now be installed in at least version `0.8.0`. This can be checked with the command `apt list | grep ces-commons`.

If you still do not receive updates for CES packages we recommend to check the file `/etc/apt/sources.list.d/ces.list`. This should contain a line of the form `deb [arch=amd64] https://apt.cloudogu.com/ces/ focal main`.
