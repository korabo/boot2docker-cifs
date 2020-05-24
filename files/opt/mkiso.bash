#!/usr/bin/env bash
_DLM_='$'

# create IP env file for fixed ip, when env var exists
FIXIP_SRC=./opt/nw.fixip4.source
if [[ ! -z $IP_ADDR ]];then
cat <<_EOL_ > $FIXIP_SRC
# Fixed IP config
# IP_ADDR=192.168.199.11/24
# IP_NW=192.168.199.0/24
# IP_GW=192.168.199.254
IP_ADDR=${_DLM_}{IP_ADDR:-${IP_ADDR}}
IP_NW=${_DLM_}{IP_NW:-${IP_NW}}
IP_GW=${_DLM_}{IP_GW:-${IP_GW}}
_EOL_
else
cat <<_EOL_ > $FIXIP_SRC
# Fixed IP config
# IP_ADDR=192.168.199.11/24
# IP_NW=192.168.199.0/24
# IP_GW=192.168.199.254
_EOL_
fi

# create cred file source for cifs mount
CRED_SRC=./opt/cifs.cred.source
_USR_=${CIFS_USR:-dockercifs}
_PSW_=${CIFS_PSW:-dockercifs}
_DMN_=${CIFS_DMN:-CifsSvrDomainName}
echo "username=${_DLM_}{CIFS_USR:-${_USR_}}" > $CRED_SRC
echo "password=${_DLM_}{CIFS_PSW:-${_PSW_}}" >> $CRED_SRC
echo "domain=${_DLM_}{CIFS_DMN:-${_DMN_}}" >> $CRED_SRC

time make-b2d-iso.sh 1>&2
du -hs /tmp/boot2docker.iso 1>&2
cat /tmp/boot2docker.iso
