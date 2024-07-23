#!/bin/bash
set -o errexit
set -o nounset
set -o pipefail

#fail2banVersion=1.0.2-3
fail2banVersion=1.1.0
fail2banPreRelease=1
fail2banDebSHA256SUM=4ef39bbda961aa4c4e97a099e962cf9863d66edf2808caab668ddcd4ed2ebda2
fail2banDebFileName=fail2ban_${fail2banVersion}-${fail2banPreRelease}.upstream1_all.deb

# Installs fail2ban via apt
installFail2Ban() {
  echo "Installing fail2ban..."
  #DEBIAN_FRONTEND=noninteractive apt-get -y install fail2ban=${fail2banVersion}
  # Do not install fail2ban via apt because the newest version (1.0.2-3) does not work with ubuntu 24.04 because of a missing python dependency.
  # See: https://github.com/fail2ban/fail2ban/issues/3487
  wget -q "https://github.com/fail2ban/fail2ban/releases/download/${fail2banVersion}/${fail2banDebFileName}"
  echo "${fail2banDebSHA256SUM} ${fail2banDebFileName}" | sha256sum --check
  dpkg -i "${fail2banDebFileName}"
  rm "${fail2banDebFileName}"
}

# Sets multiple configuration values for the fail2ban client.
configureFail2Ban() {
  echo "Configuring fail2ban for the ssh daemon..."
  cat <<EOF >/etc/fail2ban/jail.local
[sshd]
enabled = true
ignoreip = 127.0.0.1/8
maxretry = 5
findtime = 10m
bantime = 10m
logpath = /var/log/auth.log
EOF
  systemctl restart fail2ban
}

installFail2Ban
configureFail2Ban
