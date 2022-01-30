#!/usr/bin/env bash
#############################################################################
##
##  download and install all available updates on a debian/ubuntu system
##
#############################################################################

set -eu

# ---------------------------------------------------------------------------
#  check if we are root
# ---------------------------------------------------------------------------

if [ "${UID}" != 0 ]; then
    echo "ERROR: You need to be root to run this script."
    exit 1
fi

# ---------------------------------------------------------------------------
#  initializations
# ---------------------------------------------------------------------------

apt=$(command -v apt-get)

if [ -z "${apt}" ]; then
    echo "ERROR: Cannot find apt-get."
    exit 1
fi

# ---------------------------------------------------------------------------
#  download and install the updates
# ---------------------------------------------------------------------------

${apt} update              # update the local cache
${apt} -y dist-upgrade     # download and install all available updates
${apt} -y autoremove       # remove obsolete packages
${apt} autoclean           # clean-up the local update cache

# ---------------------------------------------------------------------------
#  check if we need to reboot the system
# ---------------------------------------------------------------------------

if [ -f /var/run/reboot-required ]; then
    echo "INFO: You need to reboot your system to finish the updates."
fi

### eof #####################################################################
