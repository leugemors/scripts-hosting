#!/usr/bin/env bash
#############################################################################
##
##  script to install the latest wordpress version
##
#############################################################################


# ---------------------------------------------------------------------------
#  first check if we are root
# ---------------------------------------------------------------------------
 
if [ $UID != 0 ]; then
    printf "ERROR: You need to be root to run this script\n\n"
    exit 1
fi


# ---------------------------------------------------------------------------
#  configuration
# ---------------------------------------------------------------------------

INSTALL_DIR="/var/www/wordpress"

MY_DB="www_ruralwf_org"
MY_HOST="localhost"
MY_PORT="3306"
MY_USER="ruralwf"

WP_TITLE="Rural Women Foundation Nigeria"
WP_USER="richard"
WP_PASS=""
WP_EMAIL="richard@uzori.com"
WP_URL="https://working.ruralwf.org"


# ---------------------------------------------------------------------------
#  create database
# ---------------------------------------------------------------------------

#$MYSQL -e "create user $MY_USER identified by $MY_PASS;"
$MYSQL -e "drop database $MY_DB;"
$MYSQL -e "create database if not exists $MY_DB;"
$MYSQL -e "grant all privileges on $MY_DB.* to $MY_USER;"
$MYSQL -e "flush privileges;"


# ---------------------------------------------------------------------------
#  download and install wordpress
# ---------------------------------------------------------------------------

mkdir -p $INSTALL_DIR/$
curl https://wordpress.org/latest.tar.gz -o ./latest.tar.gz
tar zxf latest.tar.gz



# Build our wp-config.php file
sed -e "s/localhost/"$mysqlhost"/" -e "s/database_name_here/"$mysqldb"/" -e "s/username_here/"$mysqluser"/" -e "s/password_here/"$mysqlpass"/" wp-config-sample.php > wp-config.php

# Grab our Salt Keys
SALT=$(curl -L https://api.wordpress.org/secret-key/1.1/salt/)
STRING='put your unique phrase here'
printf '%s\n' "g/$STRING/d" a "$SALT" . w | ed -s wp-config.php

# Run our install ...
curl -d "weblog_title=$wptitle&user_name=$wpuser&admin_password=$wppass&admin_password2=$wppass&admin_email=$wpemail" http://$siteurl/wp-admin/install.php?step=2

# Tidy up
rmdir wordpress
rm latest.tar.gz
rm wp-config-sample.php

# Download starkers
cd wp-content/themes/
wget https://github.com/viewportindustries/starkers/archive/master.zip
unzip master.zip
rm master.zip


