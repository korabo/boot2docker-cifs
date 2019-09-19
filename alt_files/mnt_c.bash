#!/usr/bin/env bash
CIFS_OPTS=username=${CIFS_USR},password=${CIFS_PSW},vers=2.0,dir_mode=0777,file_mode=0777
mkdir -p /c
WinHost=$(netstat -r|awk '/^default/ {print $2}'|sed -r 's/([^.]*)(\.|).*/\1/g')
mount.cifs //${WinHost:-WindowsHostName}/c /c  -o "${CIFS_OPTS}"
echo "//${WinHost:-WindowsHostName}/c /c cifs ${CIFS_OPTS} 0 2" >> /etc/fstab
echo "nameserver 8.8.8.8" >> /etc/resolv.conf
echo "nameserver 4.4.4.4" >> /etc/resolv.conf
if [[ -z $1 ]];then
  echo "/opt/mnt_c.bash -run" > /var/lib/boot2docker/bootsync.sh
fi
