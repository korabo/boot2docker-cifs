#!/usr/bin/env bash
if [[ $1 =~ ^(-h|--help)$ ]];then
cat <<_HLP_
usage: $0
    available env vars
    CIFS_USR : windows file share user
    CIFS_PSW : windows file share password
    (CIFS_DMN : windows file share domain)
    (IP_ADDR : fixed ip address/mask; eg 192.168.199.10/24)
    (IP_NW   : fixed network e.g. 192.168.199.0/24)
    (IP_GW   : fixed gateway e.g. 192.168.199.254)
_HLP_
exit
fi

B2D_SYN=/var/lib/boot2docker/bootsync.sh

# create cred file for cifs mount
CRED_SRC=/opt/cifs.cred.source
CRED_FILE=/var/lib/boot2docker/cifs.cred
source $CRED_SRC
# domain=${CIFS_DMN:-CifsSvrDomainName}
echo "username=${username}" > $CRED_FILE
echo "password=${password}" >> $CRED_FILE
if [[ ${domain} == 'CifsSvrDomainName' ]];then
    echo "# domain=${domain}" >> $CRED_FILE
else
    echo "domain=${domain}" >> $CRED_FILE
fi

# mount cifs & add dns resolver
FIXIP_SRC=/opt/nw.fixip4.source
FIXIP_FILE=/var/lib/boot2docker/nw.fixip4
cp -p $FIXIP_SRC $FIXIP_FILE
cat <<'_EOL_' > $B2D_SYN
#!/usr/bin/env bash
FIXIP_FILE=/var/lib/boot2docker/nw.fixip4
MNT_CMD=/opt/mnt_c.bash
source $FIXIP_FILE || true
# enable if fixed IP
if [[ ! -z $IP_ADDR ]];then
    echo "Changeing IP address to $IP_ADDR"
    # change fix ip
    kill `cat /var/run/udhcpc.eth0.pid` || true
    # LINK OFF, Clear IP address
    ip link set eth0 down
    ip addr flush dev eth0
    # LINK ON
    ip link set eth0 up
    ip addr show dev eth0
    # ADD ROUTE
    ip route add ${IP_NW} dev eth0
    ip route add default via ${IP_GW}
    # assign static ip addr
    ip addr add ${IP_ADDR} brd + dev eth0
    ip addr show dev eth0
    # change DNS
    RSLV_CNF=/etc/resolv.conf
    NS_1=8.8.8.8
    NS_2=8.8.4.4
    NS_3=$IP_GW
    echo "Changing DNS on $RSLV_CNF"
    for ns in $NS_1 $NS_2 $NS_3;do
        grep $ns $RSLV_CNF 2>&1 > /dev/null && continue
        echo "nameserver $ns" >> $RSLV_CNF
    done
fi

# mount host machine drive on cifs
bash $MNT_CMD
_EOL_

chmod a+rx $B2D_SYN
exec $B2D_SYN
