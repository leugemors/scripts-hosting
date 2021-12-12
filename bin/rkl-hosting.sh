#!/usr/bin/env bash
#############################################################################
##
##  post installation script for uzori hosting servers
##
#############################################################################


# ---------------------------------------------------------------------------
#  check if we are root
# ---------------------------------------------------------------------------

if [ $UID != 0 ]; then
  printf "\nYou need to be root to run this script.\n\n"
  exit 1
fi


# ---------------------------------------------------------------------------
#  check if we are on a ubuntu/mint system
# ---------------------------------------------------------------------------

APT=$(which apt-get)
INSTALL="$APT -y install"

if [ -z $APT ]; then
  printf "\nERROR: Cannot find apt-get, are you sure this is Ubuntu/Mint?\n\n"
  exit 1
fi


# ---------------------------------------------------------------------------
#  what are we going to install
# ---------------------------------------------------------------------------

INSTALL_WEB_SERVER="yes"
INSTALL_PHP="yes"
INSTALL_DATABASE="yes"


# ---------------------------------------------------------------------------
#  first install all available updates
# ---------------------------------------------------------------------------

$APT update
$APT -y dist-upgrade


# ---------------------------------------------------------------------------
#  install some essential packages
# ---------------------------------------------------------------------------

$INSTALL binutils
$INSTALL fail2ban
$INSTALL figlet
$INSTALL htop
$INSTALL iftop
$INSTALL iotop
$INSTALL lynx
$INSTALL mc
$INSTALL mlocate
$INSTALL mutt
$INSTALL net-tools
$INSTALL tasksel
$INSTALL traceroute
$INSTALL unhide
$INSTALL unzip
$INSTALL vim 
$INSTALL zip


# ---------------------------------------------------------------------------
#  install the webserver
# ---------------------------------------------------------------------------

if [ $INSTALL_WEB_SERVER = "yes" ]; then
  $INSTALL nginx
  $INSTALL certbot
  $INSTALL python3-certbot-nginx
  systemctl start nginx.service
  systemctl enable nginx.service
fi


# ---------------------------------------------------------------------------
#  install php
# ---------------------------------------------------------------------------

if [ $INSTALL_PHP = "yes" ]; then
  add-apt-repository -y ppa:ondrej/php
  $APT update
  $INSTALL php8.1-cgi
  $INSTALL php8.1-curl
  $INSTALL php8.1-fpm
  $INSTALL php8.1-gd
  $INSTALL php8.1-imagick
  $INSTALL php8.1-json
  $INSTALL php8.1-mbstring
  $INSTALL php8.1-mysql
  $INSTALL php8.1-opcache
  $INSTALL php8.1-xml
  $INSTALL php8.1-zip
  systemctl start php8.1-fpm.service
  systemctl enable php8.1-fpm.service
fi


# ---------------------------------------------------------------------------
#  install the database
# ---------------------------------------------------------------------------

if [ $INSTALL_DATABASE = "yes" ]; then
  $INSTALL mariadb-server
  systemctl start mariadb.service
  systemctl enable mariadb.service
  #mysql_secure_installation
fi


### eof #####################################################################
