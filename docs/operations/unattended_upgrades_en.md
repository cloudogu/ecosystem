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
### Ubuntu versions <= 16.04 will longer receives apt updates
In April 2021, the LTS version of [Ubuntu 16.04 will no longer receive updates](https://ubuntu.com/about/release-cycle).
Subsequently, the Cloudogu Ecosystem will also no longer support Ubuntu version 16.04. For this reason, the apt repository from which updates are pulled has also been changed.
If you are now using an older Cloduogu version, we suggest you update your Ubuntu version to at least 18.04. If you should now use:
```shell
apt-get update
apt-get upgrade
```
to perform an update. If you still do not receive any updates we recommend to consult the file `/etc/apt/sources.list.d/ces.list`. Here the link must point to the apt-repo ` https://apt.cloudogu.com/ces/`. The version of the ces-commons should also be at least. `0.8.0`.
This can be checked with the command `apt list | grep ces-commons`.
