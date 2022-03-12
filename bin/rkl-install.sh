#!/usr/bin/env bash
#############################################################################
##
##  script to setup an ubuntu/mint linux system for developers
##
#############################################################################

VERSION="0.25"

# ---------------------------------------------------------------------------
#  print a simple header
# ---------------------------------------------------------------------------

PrintHeader()
{
    printf "\nInstall Tool v${VERSION}\n=================="
    printf "\nSetup an Ubuntu or Mint Linux system for Developers.\n"
}

# ---------------------------------------------------------------------------
#  show some help
# ---------------------------------------------------------------------------

ShowHelp()
{
cat << __EOT

Usage:
  $0 [OPTIONS]...

Valid options are:
  -h   Show this help screen
  -1   OpenJDK Java 11 (LTS)
  -3   OpenJDK Java 13
  -6   OpenJDK Java 16
  -7   OpenJDK Java 17
  -d   Developper tools
  -f   Some fun stuff
  -m   Media stuff to play everything
  -n   Network and security tools
  -p   Python 3 with various libs
  -t   Various handy tools
  -w   WiFi network tools
  -x   Extra packages for x
  -z   Archive (zip) tools
  -a   All of the above (only Java 11 LTS)

__EOT
exit 1
}

# ---------------------------------------------------------------------------
#  check if we are root
# ---------------------------------------------------------------------------

CheckRoot()
{
    if [ $UID != 0 ]; then
      printf "\nERROR : You need to be root to run this script!\n\n"
      sudo $0
      exit 1
    fi
}

# ---------------------------------------------------------------------------
#  initializations
# ---------------------------------------------------------------------------

Initializations()
{
    APTGET=`which apt-get`
    INSTALL="$APTGET -y install"

    # java runtime environment and browser plugin
    JAVA1="openjdk-11-jre openjdk-11-jdk"
    JAVA3="openjdk-13-jre openjdk-13-jdk"
    JAVA6="openjdk-16-jre openjdk-16-jdk"
    JAVA7="openjdk-17-jre openjdk-17-jdk"

    # packages for developping
    DEVELOP="automake build-essential bison curl exuberant-ctags flex gawk \
        git gitk libaio1 libsvn-java libwebkitgtk-1.0-0 maven meld ml-yacc \
        libtool subversion"

    # some fun stuff
    FUN="ascii bb bsdgames cool-retro-term cowsay espeak fbi figlet fortune \
        hollywood linuxlogo pi sl sysvbanner"

    # media play everything
    MEDIA="ubuntu-restricted-extras ffmpeg icedax libdvd-pkg easytag id3tool \
        lame libxine2-ffmpeg mpg321 libavcodec-extra gstreamer1.0-libav"

    # network and security tools
    NETTOOLS="chkrootkit cifs-utils davfs2 iftop iotop nfs-common nmap \
        openssh-server traceroute unhide whois"

    # python3
    PYTHON="python3.8 python3-pip python3-autopep3 python3-setuptools \
        python3-wheel"

    # various handy tools
    TOOLS="apcalc c3270 dbview gddrescue hardinfo hexedit htop lynx mc ncdu \
        odt2txt tasksel tofrodos vim vim-scripts wipe tnef tree"

    # wifi network tools
    WIFI="aircrack-ng cowpatty hcxdumptool kismet reaver tshark wavemon"

    # stuff for x
    XTOOLS="bleachbit cheese gnote gparted gufw p7zip p7zip-rar pinta remmina \
        vim-gtk3 vlc vokoscreen x3270 xfonts-x3270-misc xsane"

    # archive (zip) tools
    ZIP="arc arj cabextract lzop nomarch pax rar sharutils unrar unzip zip"

    # everything (only java11)
    ALL="$JAVA1 $DEVELOP $FUN $MEDIA $NETTOOLS $PYTHON $TOOLS $WIFI $XTOOLS $ZIP"

    # make sure we can see all autostart apps
    sudo sed -i "s/NoDisplay=true/NoDisplay=false/g" /etc/xdg/autostart/*.desktop
}

# ---------------------------------------------------------------------------
#  install all available updates
# ---------------------------------------------------------------------------

InstallUpdates()
{
    $APTGET update
    $APTGET -y dist-upgrade
    $APTGET autoremove
    $APTGET autoclean
}

# ---------------------------------------------------------------------------
#  install packages
# ---------------------------------------------------------------------------

InstallPackages()
{
    for PACKAGE in $PACKAGES; do
        $INSTALL $PACKAGE
    done
}

#############################################################################
##
##  main program
##
#############################################################################

PrintHeader
CheckRoot
Initializations

# ---------------------------------------------------------------------------
#  parse command line options
# ---------------------------------------------------------------------------

if [ "$1" = "" ]; then
    ShowHelp
fi

# ---------------------------------------------------------------------------
#  do the magic
# ---------------------------------------------------------------------------

InstallUpdates

while getopts "h1367dfmnptwxza" OPTION; do

    case "$OPTION" in
        h) ShowHelp ;;
        1) PACKAGES=$JAVA1 ;;
        3) PACKAGES=$JAVA3 ;;
        6) PACKAGES=$JAVA6 ;;
        7) PACKAGES=$JAVA7 ;;
        d) PACKAGES=$DEVELOP ;;
        f) PACKAGES=$FUN ;;
        m) PACKAGES=$MEDIA ;;
        n) PACKAGES=$NETTOOLS ;;
        p) PACKAGES=$PYTHON ;;
        t) PACKAGES=$TOOLS ;;
        w) PACKAGES=$WIFI ;;
        x) PACKAGES=$XTOOLS ;;
        z) PACKAGES=$ZIP ;;
        a) PACKAGES=$ALL ;;
        *) exit 1 ;;
    esac

    InstallPackages

done

exit 0

### eof #####################################################################
