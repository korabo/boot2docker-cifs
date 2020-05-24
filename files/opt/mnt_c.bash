#!/usr/bin/env bash
CRED_FILE=/var/lib/boot2docker/cifs.cred
# WIN_USR=$CIFS_USR
# WIN_PSW=$CIFS_PSW
# CIFS_OPTS=username=${WIN_USR},password=${WIN_PSW},vers=2.0,dir_mode=0777,file_mode=0777
CIFS_OPTS=credentials=${CRED_FILE},iocharset=utf8,dir_mode=0777,file_mode=0777
mkdir -p /c
# WinHost=$(netstat -r|awk '/^default/ {print $2}'|sed -r 's/([^.]*)(\.|).*/\1/g')
WinHost=$(netstat -r|awk '/^default/ {print $2}')

umount -f /c || true
mount.cifs //${WinHost:-WindowsHostName}/c /c  -o "${CIFS_OPTS}"
# change fsta
FSTAB_FILE=/etc/fstab
ENTRY_LINE="//${WinHost:-WindowsHostName}/c /c cifs ${CIFS_OPTS} 0 2"
_CIFS_ENTRY_=N
# check similer entry
grep ' /c cifs ' $FSTAB_FILE|grep -e '^[^#]' 2>&1 > /dev/null && _CIFS_ENTRY_=Y
if [[ $_CIFS_ENTRY_ == 'Y' ]];then
    # check if same entry
    grep "$ENTRY_LINE" $FSTAB_FILE|grep -e '^[^#]' 2>&1 > /dev/null && _CIFS_ENTRY_=E
fi
if [[ $_CIFS_ENTRY_ == 'Y' ]];then
    # already have entry, delete it
    _CIFS_ENTRY_=N
    sed -i '/^[^#].* \/c cifs .*$/d' $FSTAB_FILE
fi
if [[ $_CIFS_ENTRY_ == 'N' ]];then
    # add new one
    echo "$ENTRY_LINE" >> $FSTAB_FILE
fi
