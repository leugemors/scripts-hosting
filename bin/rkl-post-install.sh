#!/usr/bin/env bash
#############################################################################
##
##  post install script for gnu/linux mint
##
#############################################################################


# ---------------------------------------------------------------------------
#  check if we are root
# ---------------------------------------------------------------------------

if [ $UID != 0 ]; then
  printf "\nERROR: You need to be root to run this script!\n\n"
  exit 1
fi


# ---------------------------------------------------------------------------
#  initializations
# ---------------------------------------------------------------------------

APT=$(which apt-get)
INSTALL="$APT -y install"

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
#  install some basic packages
# ---------------------------------------------------------------------------

$INSTALL figlet
$INSTALL git
$INSTALL hardinfo
$INSTALL htop
$INSTALL iftop
$INSTALL iotop
$INSTALL lynx
$INSTALL mc
$INSTALL traceroute
$INSTALL unhide
$INSTALL unzip
$INSTALL vim
$INSTALL zip


# ---------------------------------------------------------------------------
#  check if we need to reboot the system
# ---------------------------------------------------------------------------

if [ -f /var/run/reboot-required ]; then
  printf "\nINFO: You need to reboot your system to finish the updates!\n\n"
fi


### eof #####################################################################
