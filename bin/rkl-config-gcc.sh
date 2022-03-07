#!/usr/bin/env bash
#############################################################################
##
##  setup gcc on ubuntu/mint laptops
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

APTGET=`which apt-get`
INSTALL="$APTGET -y install"

# ---------------------------------------------------------------------------
#  set up gcc
#  gcc versions 4.8, 5 and 6 are no longer in the standard repository
# ---------------------------------------------------------------------------

# delete current update-alternatives for gcc and g++
update-alternatives --remove-all gcc 
update-alternatives --remove-all g++

# install gcc and g++ version 7
$INSTALL gcc-7 g++-7

# install gcc and g++ version 8
$INSTALL gcc-8 g++-8

# install gcc and g++ version 9
$INSTALL gcc-9 g++-9

# install gcc and g++ version 10
$INSTALL gcc-10 g++-10

# ---------------------------------------------------------------------------
#  add new alternatives
# ---------------------------------------------------------------------------

update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-7 10
update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-8 20
update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-9 30
update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-10 40

update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-7 10
update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-8 20
update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-9 30
update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-10 40

#update-alternatives --install /usr/bin/cc cc /usr/bin/gcc 60
#update-alternatives --install /usr/bin/c++ c++ /usr/bin/g++ 60

# ---------------------------------------------------------------------------
#  configure alternatives
# ---------------------------------------------------------------------------

update-alternatives --set gcc /usr/bin/gcc-10
update-alternatives --set g++ /usr/bin/g++-10
update-alternatives --set cc /usr/bin/gcc
update-alternatives --set c++ /usr/bin/g++

### eof #####################################################################
