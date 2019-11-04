# Create docker image for windows with cifs enabled
# http://weblogs.com.pk/khurram/archive/2016/07/03/customized-boot2docker-iso-with-cifs.aspx with Fix
# 1.0 ST(KRB/SPG)
# way to Make
# docker build --file Dockerfile --tag korabo/boot2docker-cifs ./
# docker run --env CIFS_USR=dockercifs --env CIFS_PSW=dockercifs --rm korabo/boot2docker-cifs:latest > boot2docker.cifs.iso
# sudo docker-machine create --driver hyperv --hyperv-virtual-switch hv-nat --hyperv-boot2docker-url boot2docker.cifs.iso dkcifs
# copied to C:\Users\s.takeuchi\.docker\machine\machines\default\boot2docker.iso
# AFTER CREATED: replace virtual-switch, docker-machine regenerate-certs dkcifs, docker-machine env dkcifs
# In boot2dockercifs ; sudo bash /opt/mnt_c.bash

# https://hub.docker.com/u/boot2docker
# https://github.com/boot2docker/boot2docker
FROM boot2docker/boot2docker

#wget http://distro.ibiblio.org/tinycorelinux/5.x/x86/tcz/cifs-utils.tczRf
#tce-load -i cifs-utils.tcz

ENV CIFS_USR=dockercifs \
   	CIFS_PSW=dockercifs

WORKDIR /rootfs
ENV ROOTFS /rootfs

# # <<- - - FROM boot2docker : Already defined ENVs - - -
# ENV TCL_MIRRORS http://distro.ibiblio.org/tinycorelinux http://repo.tinycorelinux.net
# ENV TCL_MAJOR 10.x
# ENV TCL_VERSION 10.1

# # http://distro.ibiblio.org/tinycorelinux/8.x/x86_64/archive/8.2.1/distribution_files/rootfs64.gz.md5.txt
# ENV TCL_ROOTFS="rootfs64.gz" TCL_ROOTFS_MD5="ec65d3b2bbb64f62a171f60439c84127"

# # packages (and their deps) that we either need for our "tce-load" patches or that dep on "...-KERNEL" which we don't need (since we build our own kernel)
# # http://distro.ibiblio.org/tinycorelinux/8.x/x86_64/tcz/squashfs-tools.tcz.dep
# # http://distro.ibiblio.org/tinycorelinux/8.x/x86_64/tcz/squashfs-tools.tcz.md5.txt
# ENV TCL_PACKAGES="squashfs-tools.tcz liblzma.tcz lzo.tcz libzstd.tcz" TCL_PACKAGE_MD5__squashfs_tools_tcz="a44331fa2117314e62267147b6876a49" TCL_PACKAGE_MD5__liblzma_tcz="846ce1b68690e46f61aff2f952da433f" TCL_PACKAGE_MD5__lzo_tcz="c9a1260675774c50cea1a490978b100d" TCL_PACKAGE_MD5__libzstd_tcz="a7f383473a4ced6c79e8b1a0cc9ad167"

# # https://www.kernel.org/category/signatures.html#important-fingerprints
# ENV LINUX_GPG_KEYS \
# # Linus Torvalds
# 		ABAF11C65A2970B130ABE3C479BE3E4300411886 \
# # Greg Kroah-Hartman
# 		647F28654894E3BD457199BE38DBBDC86092693E

# ENV LINUX_VERSION 4.14.134

# # https://lkml.org/lkml/2018/4/12/711 (https://github.com/boot2docker/boot2docker/pull/1322)
# # https://github.com/jirka-h/haveged/releases
# ENV HAVEGED_VERSION 1.9.4

# # http://download.virtualbox.org/virtualbox/
# # updated via "update.sh"
# ENV VBOX_VERSION 5.2.32
# # https://www.virtualbox.org/download/hashes/$VBOX_VERSION/SHA256SUMS
# ENV VBOX_SHA256 4311c7408a3410e6a33264a9062347d9eec04f58339a49f0a60488c0cabc8996

# # https://github.com/xenserver/xe-guest-utilities/tags
# ENV XEN_VERSION 7.14.0

# # https://github.com/tianon/cgroupfs-mount/releases
# ENV CGROUPFS_MOUNT_VERSION 1.4

# ENV DOCKER_VERSION 19.03.1
# # >>- - - FROM boot2docker : Already defined ENVs - - -


# Update MOTD
RUN echo "#########################################" >> $ROOTFS/etc/motd; \
	echo "##        Boot2Docker with CIFS        ##" >> $ROOTFS/etc/motd; \
	echo "## for initialize exec below cmd once: ##" >> $ROOTFS/etc/motd; \
	echo "##     sudo bash /opt/prepare.bash     ##" >> $ROOTFS/etc/motd; \
	echo "#########################################" >> $ROOTFS/etc/motd
	
# # create setup script /opt/mnt_c.bash for mount, dns, etc
# RUN  set -xeu && {\
#      echo '#!/usr/bin/env bash'; \
#      echo 'WIN_USR=$CIFS_USR'; \
#      echo 'WIN_PSW=$CIFS_PSW'; \
# 	 echo "CIFS_OPTS=username=\${CIFS_USR},password=\${CIFS_PSW},vers=2.0,dir_mode=0777,file_mode=0777"; \
#      echo 'mkdir -p /c'; \
#      echo "WinHost=\$(netstat -r|awk '/^default/ {print \$2}'|sed -r 's/([^.]*)(\.|).*/\1/g')"; \
#      echo 'mount.cifs //${WinHost:-WindowsHostName}/c /c  -o "${CIFS_OPTS}"'; \
#      echo 'echo "//${WinHost:-WindowsHostName}/c /c cifs ${CIFS_OPTS} 0 2" >> /etc/fstab'; \
#      echo 'echo "nameserver 8.8.8.8" >> /etc/resolv.conf'; \
#      echo 'echo "nameserver 8.8.4.4" >> /etc/resolv.conf'; \
#      echo 'if [[ -z $1 ]];then'; \
#      echo '  echo "/opt/mnt_c.bash -run" > /var/lib/boot2docker/bootsync.sh'; \
#      echo 'fi'; \
#    } | tee $ROOTFS/opt/mnt_c.bash && \
#      chmod a+x $ROOTFS/opt/mnt_c.bash && \
# 	#  to confirm script is good
# 	 cat $ROOTFS/opt/mnt_c.bash
 
# install pkg for cifs mount
ENV TCL_PACKAGES_EXTRA="samba-libs.tcz cifs-utils.tcz"
# Get Packages samba-libs.tcz samba-client.tcz cifs-utils.tc
RUN for package in $TCL_PACKAGES_EXTRA; do \
		for mirror in $TCL_MIRRORS; do \
			if \
				wget -O "usr/local/tce.installed/optional/$package" "$mirror/$TCL_MAJOR/x86_64/tcz/$package" \
			; then \
				break; \
			fi; \
		done; \
		unsquashfs -dest . -force "usr/local/tce.installed/optional/$package"; \
	done; \
	echo "finish"

# max watcher
RUN set -xeu && \
  echo "fs.inotify.max_user_watches = 524288" >> $ROOTFS/etc/sysctl.conf

COPY files/opt/mnt_c.bash ./opt/
COPY files/opt/prepare.bash ./opt/
COPY files/opt/mkiso.bash ./opt/

RUN set -xeu && \
  chmod a+x ./opt/*.bash

CMD ["sh", "-c", "[ -t 1 ] && exec bash || exec bash ./opt/mkiso.bash"]
