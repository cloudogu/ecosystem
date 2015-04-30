#!/bin/bash
echo check packages

while read SEL; do
  echo $SEL | /usr/bin/debconf-set-selections
done < $INSTALL_HOME/install/debconf-set-selections

ALL=$(dpkg -l | awk '{print $2}')
NEWPKGS=$(cat $INSTALL_HOME/install/packages)
INSTALL=0
for PKG in $NEWPKGS; do
  echo $ALL | grep "$PKG" &>/dev/null
  if [ $? = 0 ]; then
    echo "package $PKG is already installed"
  else
    INSTALL=1
  fi
done

if [ $INSTALL != 0 ]; then
  apt-get update
  apt-get install -yy \
    -o Dpkg::Options::="--force-confdef" \
    -o Dpkg::Options::="--force-confold" $NEWPKGS
else
  echo "all packages already installed"
fi
