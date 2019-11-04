#!/usr/bin/env bash
CRED_FILE=./opt/cifs.cred

# create cred file for cifs mount
cat <<EOL > $CRED_FILE
username=${CIFS_USR:-dockercifs}
password=${CIFS_PSW:-dockercifs}
# domain=${CIFS_DMN:-CifsSvrDomainName}
EOL

time make-b2d-iso.sh
du -hs /tmp/boot2docker.iso
cat /tmp/boot2docker.iso
