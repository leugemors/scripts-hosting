#!/bin/bash
#############################################################################
##
##  configuring an iptables firewall on ubuntu systems (with ufw)
##
#############################################################################

### get the ip addresses

#HOST=`hostname -i`
#LAN="10.209.0.0/20"

### first disable and reset all current firewall rules

ufw disable
echo y | ufw reset

### nothing comes in and everything can go out

ufw default deny incoming
ufw default allow outgoing

### open port for ssh (max 6 tries per second)

ufw limit 22/tcp     # SSH

### open ports for dns server

#ufw allow 53/tcp    # BIND
#ufw allow 53/udp    # BIND

### open port for ntpd

#ufw allow 123        # NTP

### open ports for nis

#ufw allow 111        # PORTMAPPER
#ufw allow 985        # YPBIND
#ufw allow 986        # YPBIND

### open ports for the zimbra mail server

#ufw allow 25/tcp    # SMTP
#ufw allow 80/tcp    # HTTP
#ufw allow 110/tcp   # POP3
#ufw allow 143/tcp   # IMAP
#ufw allow 443/tcp   # HTTPS
#ufw allow 465/tcp   # SSMTP
#ufw allow 587/tcp   # TLS
#ufw allow 993/tcp   # IMAPS
#ufw allow 995/tcp   # POP3S
#ufw allow 7025/tcp  # LMTP
#ufw limit 7071/tcp  # ADMIN
#ufw limit 8080/tcp  # HTTP
#ufw limit 8443/tcp  # HTTPS
#ufw allow from $LAN to $HOST port 389 proto tcp  # LDAP

### open ports for the web server

#ufw allow 80/tcp     # HTTP
#ufw allow 443/tcp    # HTTPS

#ufw allow 8080/tcp   # TOMCAT
#ufw allow 8443/tcp   # TOMCAT

### open port for database server (only from lan)

#ufw allow from $LAN to $HOST port 3306 proto tcp  # MARIADB
#ufw allow from $LAN to $HOST port 5432 proto tcp  # POSTGRESQL

### open ports for samba (only local)

#ufw allow from $LAN to $HOST port 137 proto udp
#ufw allow from $LAN to $HOST port 138 proto udp
#ufw allow from $LAN to $HOST port 139 proto tcp
#ufw allow from $LAN to $HOST port 445 proto tcp

### open miscelaneous ports

#ufw allow 5666/tcp   # NRPE
#ufw allow 5900/tcp   # VNC
#ufw allow 17500/tcp  # DROPBOX

### configuring an ip blacklist

#ufw deny from 10.0.0.0/8
#ufw deny from 172.16.0.0/12
#ufw deny from 192.168.0.0/16

### enable the firewall

echo y | ufw enable

### show what we have done

ufw status verbose

### EOF #####################################################################
