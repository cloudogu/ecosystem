#!/bin/bash

# sync resources to fs
rsync -rv $INSTALL_HOME/resources/* /

# space for privilege adjustment
