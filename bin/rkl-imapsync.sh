#!/usr/bin/env bash
#############################################################################
##
##  script to move email from one server to another using imap
##
#############################################################################

# git clone https://github.com/imapsync/imapsync
# make sure the firewall accepts IMAP and/or IMAPS connections


USERNAME1="name@domain.com"
PASSWORD1="********"

USERNAME2="name@domain.com"
PASSWORD2="********"

imapsync \
  --no-modulesversion \
  --nolog \
  --host1 hosting5.uzori.com \
  --user1 "$USERNAME1" \
  --password1 "$PASSWORD1" \
  --tls1 \
  --host2 hosting6.uzori.com \
  --user2 "$USERNAME2" \
  --password2 "$PASSWORD2" \
  --tls2


### eof #####################################################################