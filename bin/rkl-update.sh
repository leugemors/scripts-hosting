#!/usr/bin/env bash
#############################################################################
##
##  download and install all available updates
##
#############################################################################


# ---------------------------------------------------------------------------
#  first check if we are root
# ---------------------------------------------------------------------------

if [ $UID != 0 ]; then
  printf "\nERROR: You need to be root to run this script!\n\n"
  exit 1
fi


# ---------------------------------------------------------------------------
#  initialisations
# ---------------------------------------------------------------------------

APT=$(which apt-get)

if [ -z $APT ]; then
  printf "\nERROR: Cannot find apt-get, are you sure this is Ubuntu/Mint?\n\n"
  exit 1
fi


# ---------------------------------------------------------------------------
#  download and install the updates
# ---------------------------------------------------------------------------

$APT update
$APT -y dist-upgrade


# ---------------------------------------------------------------------------
#  remove obsolete packages
# ---------------------------------------------------------------------------

$APT -y autoremove


# ---------------------------------------------------------------------------
#  maintain the local cache
# ---------------------------------------------------------------------------

$APT autoclean


# ---------------------------------------------------------------------------
#  check if we need to reboot the system
# ---------------------------------------------------------------------------

if [ -f /var/run/reboot-required ]; then
  printf "\nINFO: You need to reboot your system to finish the updates!\n\n"
fi


### eof #####################################################################
