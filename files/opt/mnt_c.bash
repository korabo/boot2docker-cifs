#!/usr/bin/env bash
CRED_FILE=/var/lib/boot2docker/cifs.cred
# WIN_USR=$CIFS_USR
# WIN_PSW=$CIFS_PSW
# CIFS_OPTS=username=${WIN_USR},password=${WIN_PSW},vers=2.0,dir_mode=0777,file_mode=0777
CIFS_OPTS=credentials=${CRED_FILE},vers=2.0,dir_mode=0777,file_mode=0777
mkdir -p /c
WinHost=$(netstat -r|awk '/^default/ {print $2}'|sed -r 's/([^.]*)(\.|).*/\1/g')

mount.cifs //${WinHost:-WindowsHostName}/c /c  -o "${CIFS_OPTS}"
echo "//${WinHost:-WindowsHostName}/c /c cifs ${CIFS_OPTS} 0 2" >> /etc/fstab

cat << _EOL_ >> /etc/resolv.conf
# https://developers.google.com/speed/public-dns/
nameserver 8.8.8.8
nameserver 8.8.4.4
_EOL_
