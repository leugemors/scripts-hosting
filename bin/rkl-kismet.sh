#!/usr/bin/env bash
#############################################################################
##
##  script to put my wifi card into monitoring mode to run kismet
##
#############################################################################

# apt-get install aircrack-ng
INTERFACE="wlp59s0"


# put wifi card in monitoring mode
sudo airmon-ng check kill
sudo airmon-ng start $INTERFACE


# start kismet
kismet


# switch things back
sudo airmon-ng stop ${INTERFACE}mon
sudo systemctl restart network-manager


### eof #####################################################################