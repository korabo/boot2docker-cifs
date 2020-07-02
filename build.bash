#!/usr/bin/env bash
RGSTR_SVR=korabo
IMG_NM=boot2docker-cifs
IMG_TG=latest

# in windows bash, $ must be escaped; cannto use ^(|-h|--help)$ as regex
HELP_ON='^(|-h|--help)$'
if [[ $1 =~ $HELP_ON ]];then
  echo "buld,run,tag,push docker to ${RGSTR_SVR}/${IMG_NM}:${IMG_TG}"
  echo "usage: $0 <bld|run|tag|push|-h|--help>"
  echo "  e.g.) $0 bld"
  exit
fi

case $1 in
    bld)
      docker build -f Dockerfile -t ${IMG_NM}:${IMG_TG} ./
      ;;
    run)
      docker run --rm -it ${IMG_NM}:${IMG_TG} bash -l
      ;;
    tag)
      docker tag ${IMG_NM}:${IMG_TG} ${RGSTR_SVR}/${IMG_NM}:${IMG_TG}
      ;;
    push)
      docker push ${RGSTR_SVR}/${IMG_NM}:${IMG_TG}
      ;;
    *)
      exit
esac

# :# create local user (e.g.  user=dockercifs/password=dockercifs)
# :# start C drive sharing only to given user (e.g. dockercifs)
# :# docker build --file Dockerfile --tag korabo/boot2docker-cifs:latest ./
# :# docker login
# :# docker push korabo/boot2docker-cifs:latest
# :# docker run --env CIFS_USR=dockercifs --env CIFS_PSW=dockercifs --rm korabo/boot2docker-cifs:latest > boot2docker.cifs.iso
# :# sudo docker-machine create --driver hyperv --hyperv-virtual-switch hv-nat --hyperv-boot2docker-url boot2docker.cifs.iso dkcifs
# :# copied by docker-machine to C:\Users\<username>\.docker\machine\machines\default\boot2docker.iso
# :# AFTER CREATED: replace virtual-switch, docker-machine regenerate-certs default, docker-machine env default
# :# In boot2docker-cifs vm on Hyper-V  do: sudo bash /opt/mnt_c.bash
