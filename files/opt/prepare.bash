#!/usr/bin/env bash
CRED_ORG=/opt/cifs.cred
CRED_FILE=/var/lib/boot2docker/cifs.cred
MNT_CMD=/opt/mnt_c.bash
B2D_SYN=/var/lib/boot2docker/bootsync.sh

# create cred file for cifs mount
cat $CRED_ORG > $CRED_FILE

# mount cifs & add dns resolver
cat <<EOL > $B2D_SYN
#!/usr/bin/env bash
bash $MNT_CMD
EOL
