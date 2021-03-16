#!/bin/bash
#############################################################################
##
##  my personal backup script
##
#############################################################################

VERSION="0.45"


# ---------------------------------------------------------------------------
#  print a simple header
# ---------------------------------------------------------------------------

printf "\nBackup Tool v${VERSION}\n=================\n"


# ---------------------------------------------------------------------------
#  first check if we are root
# ---------------------------------------------------------------------------

if [ $UID != 0 ]; then
    printf "ERROR: You need to be root to run this script\n\n"
    exit 100
fi


# ---------------------------------------------------------------------------
#  read configuration
#
#  the configuration file rkl-backup.conf should go in /usr/local/etc
# ---------------------------------------------------------------------------

CONFIGFILE="/usr/local/etc/rkl-backup.conf"

if [ -f $CONFIGFILE ]; then
    source $CONFIGFILE
else
    printf "ERROR: Cannot find configuration file: $CONFIGFILE\n\n"
    exit 1
fi


# ---------------------------------------------------------------------------
#  some initializations
# ---------------------------------------------------------------------------

TIME=$(date)
printf "Start backup of $WHO at : $TIME\n"


# ---------------------------------------------------------------------------
#  create the backup directory
# ---------------------------------------------------------------------------

printf "Creating the backup directory ...\n"

# set user rights on backup files
umask 0027

[ -d $TARGET/$DATE ] || mkdir -p $TARGET/$DATE

RESULT=$?
if [ $RESULT != 0 ]; then
    printf "ERROR: Could not create the backup directory ($RESULT)\n"
    exit 1
fi


# ---------------------------------------------------------------------------
#  create temp dir for database dump files
# ---------------------------------------------------------------------------

printf "Creating a temporary directory ...\n"

if [ $MYSQL = "yes" -o $POSTGRESQL = "yes" ]; then

    TEMPDIR=$(mktemp -d)

    RESULT=$?
    if [ $RESULT != 0 ]; then
        printf "ERROR: Could not create a temporary directory ($RESULT)\n"
        exit 2
    fi

fi


# ---------------------------------------------------------------------------
#  dump mysql/mariadb databases
# ---------------------------------------------------------------------------

if [ $MYSQL = "yes" ]; then

    printf "Dumping the MySQL/MariaDB databases ...\n"

    for DATABASE in $MY_DB; do

        printf " * Creating a dump of the MySQL/MariaDB database $DATABASE ...\n"

        mysqldump -u $MY_USER $DATABASE > $TEMPDIR/${DATABASE}.sql

        RESULT=$?
        if [ $RESULT != 0 ]; then
            printf "ERROR: Could not dump the MySQL/MariaDB database $DATABASE correctly! ($RESULT)\n"
        fi

    done
fi


# ---------------------------------------------------------------------------
#  dump postgresql databases
# ---------------------------------------------------------------------------

if [ $POSTGRESQL = "yes" ]; then

    printf "Dumping the PostgreSQL databases ...\n"

    for DATABASE in $PG_DB; do

        printf " * Creating a dump of the PostgreSQL database $DATABASE ...\n"

        PGPASSWORD=$PG_PW pg_dump -b -c -C -h $PG_HOST \
            -p $PG_PORT -U $PG_USER $DATABASE \
            > $TEMPDIR/${DATABASE}.sql

        RESULT=$?
        if [ $RESULT != 0 ]; then
            printf "ERROR: Could not dump the PostgreSQL database $DATABASE correctly! ($RESULT)\n"
        fi

    done
fi


# ---------------------------------------------------------------------------
#  create the actual backup
# ---------------------------------------------------------------------------

printf "Creating the backup ...\n"

if [ $SPLIT = "yes" ]; then

    if [ $MYSQL = "yes" -o $POSTGRESQL = "yes" ]; then

        printf " * databases ...\n"
        tar $TAR_OPT $TARGET/$DATE/${WHO}_${DATE}_databases.${TAR_EXT} $TEMPDIR \
            > $TARGET/$DATE/backup_databases.log 2>&1

        RESULT=$?
        if [ $RESULT != 0 ]; then
            printf "   some file are most likely changed during the backup of: databases\n"
        fi

    fi

    for BACK in $BACKUP; do

        B=$(basename $BACK)
        printf " * $B ...\n"
        tar $TAR_OPT $TARGET/$DATE/${WHO}_${DATE}_${B}.${TAR_EXT} $BACK \
            > $TARGET/$DATE/backup_$B.log 2>&1

        RESULT=$?
        if [ $RESULT != 0 ]; then
            printf "   some file are most likely changed during the backup of: $B\n"
        fi

    done

else

    tar $TAR_OPT $TARGET/$DATE/${WHO}_${DATE}.${TAR_EXT} $BACKUP $TEMPDIR \
        > $TARGET/$DATE/backup.log 2>&1

    RESULT=$?
    if [ $RESULT != 0 ]; then
        printf "   some file are most likely changed during the backup\n"
    fi

fi


# ---------------------------------------------------------------------------
#  copy the back to a remote location
# ---------------------------------------------------------------------------

if [ $REMOTE_COPY = "yes" ]; then

    printf "Sending the backup to a remote location ...\n"
    scp -pr $TARGET/$DATE $REMOTE_USER@$REMOTE_HOST:$REMOTE_DIR

    RESULT=$?
    if [ $RESULT != 0 ]; then
        printf "ERROR: Sending the backup to a remote location has failed ($RESULT)\n"
    fi

fi


# ---------------------------------------------------------------------------
#  delete old backup files
# ---------------------------------------------------------------------------

if [ $CLEANUP = "yes" ]; then

    printf "Delete old backup files ...\n"

    # first delete all old files (to avoid using rm -rf)
    find $TARGET -type f -mtime +$DAYS -exec rm {} \;

    RESULT=$?
    if [ $RESULT != 0 ]; then
        printf "ERROR: Could not delete old backup files ($RESULT)\n"
    fi

    # then delete all old (empty) directories
    find $TARGET -type d -delete -empty 2> /dev/null

fi


# ---------------------------------------------------------------------------
#  delete temp files and directory
# ---------------------------------------------------------------------------

if [ $MYSQL = "yes" -o $POSTGRESQL = "yes" ]; then

    # first delete all temporary database dump files (to avoid using rm -rf)
    rm $TEMPDIR/*

    RESULT=$?
    if [ $RESULT != 0 ]; then
        printf "ERROR: Could not delete temporary files ($RESULT)\n"
    fi

    # then delete the temporary directory
    rmdir $TEMPDIR

    RESULT=$?
    if [ $RESULT != 0 ]; then
        printf "ERROR: Could not delete temporary directory ($RESULT)\n"
    fi

fi


# ---------------------------------------------------------------------------
#  set backup files to the right owner
# ---------------------------------------------------------------------------

chown -R $OWNER:$GROUP $TARGET


# ---------------------------------------------------------------------------
#  we're done
# ---------------------------------------------------------------------------

TIME=$(date)
printf "Finish backup of $WHO at : $TIME\n"


# ---------------------------------------------------------------------------
#  email the results
# ---------------------------------------------------------------------------

# install mail
# install postfix as satelite system
# backup | tee backup_mail.txt
# cat backup_mail.txt | mail -s Bla richard@uzori.com

if [ EMAIL_SEND = "yes" ]; then
    # got to do something smart here
    printf "Email the results ..."
fi


### eof #####################################################################
