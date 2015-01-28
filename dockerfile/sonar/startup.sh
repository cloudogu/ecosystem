#!/bin/bash

function move_sonar_dir(){
  DIR="$1"
  if [ ! -d "/var/lib/sonar/$DIR" ]; then
    mv /opt/sonar/$DIR /var/lib/sonar
    ln -s /var/lib/sonar/$DIR /opt/sonar/$DIR
  fi
}

move_sonar_dir conf
move_sonar_dir extensions
move_sonar_dir logs

/opt/sonar/bin/linux-x86-64/sonar.sh console
