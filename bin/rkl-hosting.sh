#!/bin/bash
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
#  initializations
# ---------------------------------------------------------------------------

APT=$(which apt-get)
INSTALL="$APT -y install"

INSTALL_WEB_SERVER="yes"
INSTALL_PHP="yes"
INSTALL_DATABASE="yes"


# ---------------------------------------------------------------------------
#  install all available updates
# ---------------------------------------------------------------------------

$APT update
$APT -y dist-upgrade


# ---------------------------------------------------------------------------
#  fix locale issues for perl
# ---------------------------------------------------------------------------

#locale-gen en_US en_US.UTF-8
#dpkg-reconfigure locales


# ---------------------------------------------------------------------------
#  first install some esential packages
# ---------------------------------------------------------------------------

$INSTALL binutils
$INSTALL certbot
$INSTALL figlet
$INSTALL hardinfo
$INSTALL host
$INSTALL htop
$INSTALL iftop
$INSTALL iotop
$INSTALL lynx
$INSTALL man 
$INSTALL mc
$INSTALL mlocate
$INSTALL mutt
$INSTALL python3-certbot-nginx
$INSTALL tasksel
$INSTALL traceroute
$INSTALL ufw 
$INSTALL unhide
$INSTALL unzip
$INSTALL vim 
$INSTALL whois
$INSTALL zip


# ---------------------------------------------------------------------------
#  install webserver
# ---------------------------------------------------------------------------

if [ $INSTALL_WEB_SERVER = "yes" ]; then
  $INSTALL nginx
  systemctl start nginx.service
  systemctl enable nginx.service
fi


# ---------------------------------------------------------------------------
#  install php
# ---------------------------------------------------------------------------

if [ $INSTALL_PHP = "yes" ]; then
  add-apt-repository -y ppa:ondrej/php
  $APT update
  $INSTALL php7.4-cgi
  $INSTALL php7.4-curl
  $INSTALL php7.4-fpm
  $INSTALL php7.4-gd
  $INSTALL php7.4-imagick
  $INSTALL php7.4-json
  $INSTALL php7.4-mbstring
  $INSTALL php7.4-mysql
  $INSTALL php7.4-opcache
  $INSTALL php7.4-xml
  $INSTALL php7.4-zip
  systemctl start php7.4-fpm.service
  systemctl enable php7.4-fpm.service
fi


# ---------------------------------------------------------------------------
#  install database
# ---------------------------------------------------------------------------

if [ $INSTALL_DATABASE = "yes" ] ; then
  $INSTALL mariadb-server
  systemctl start mariadb.service
  systemctl enable mariadb.service
  #mysql_secure_installation
fi


### EOF #####################################################################
