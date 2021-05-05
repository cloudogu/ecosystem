# fail2ban

fail2ban is a tool with which server services can be protected against DoS attacks. The tool evaluates certain log files
and log files and blocks the affected IP addresses for a certain, configurable time in the event of repeated failed
attempts.

## Installation

fail2ban is automatically installed in newer images of the CES (from 06/2021). fail2ban is activated and configured for
the checks of ssh connections.

The current status of fail2ban can be queried with the command ``fail2ban-client status``.

### Manual installation for older CES versions

fail2ban can be installed manually for older versions of CES. This can be done in the following way:
Update package list:

```
sudo apt-get update
```

Perform installation:

```
sudo apt install fail2ban
```

Alternatively, to install a specific version of fail2ban, run the following command:

```
FAIL2BAN_VERSION=0.11.1-1
apt-get -y install fail2ban=${FAIL2BAN_VERSION}
```

The configuration of fail2ban is described later in this document.

## Starting and stopping fail2ban

fail2ban is automatically started after installation. fail2ban can be stopped via the CLI of fail2ban.

```
fail2ban-client stop
```

With the following command fail2ban can be started again.

```
fail2ban-client start
```

## Configuration

fail2ban can be configured for different server services. By default, fail2ban is enabled in CES for checking ssh
connections. The values configured are `ignoreip`, `maxretry`, `findtime`, `bantime` and the `logpath`.

The attributes have the following meaning:

* `ignoreip`: list of IP addresses to be ignored
* `maxretry`: sets the number of failed attempts before the host is blocked
* `findtime`: sets the number of seconds the filter will look back for failed attempts
* `bantime`: sets the number of seconds a host will be blocked for
* `logpath`: adds a specific log file to the watchlist

The configuration is done separately for each server service.

### Default configuration / Manual configuration

fail2ban comes with a command line client that can be used to perform various actions with fail2ban. Via this client the
configuration of fail2ban can be created and adjusted.

The basic check of ssh connections can be activated with the following command. The following default settings are
configured for the CES via the fail2ban-client:

```
fail2ban-client start sshd
```

The fail2ban-client can then also be used to set a corresponding configuration for the check. For new CES instances, the
following default settings are configured via the fail2ban-client:

```
fail2ban-client set sshd addignoreip 127.0.0.1/8
fail2ban-client set sshd maxretry 5
fail2ban-client set sshd findtime 10m
fail2ban-client set sshd bantime 10m
fail2ban-client set sshd addlogpath /var/log/auth.log
```

A complete reference with all commands of the fail2ban client can be found on the official site of fail2ban
at https://www.fail2ban.org/wiki/index.php/Commands. The command reference can also be found with the command
```fail2ban-client -h```.

## Log file of fail2ban

For evaluation and analysis, fail2ban logs all actions performed in a separate log file. This log file can be found
under `/var/log/fail2ban.log`.
