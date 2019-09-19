:# create local user (e.g.  user=dockercifs/password=dockercifs)
:# start C drive sharing only to given user (e.g. dockercifs)
docker build --file Dockerfile --tag korabo/boot2docker:cifs ./
:# docker run --env CIFS_USR=dockercifs --env CIFS_PSW=dockercifs --rm korabo/boot2docker-cifs:latest > boot2docker.cifs.iso
:# sudo docker-machine create --driver hyperv --hyperv-virtual-switch hv-nat --hyperv-boot2docker-url boot2docker.cifs.iso dkcifs
:# copied to C:\Users\s.takeuchi\.docker\machine\machines\default\boot2docker.iso
:# AFTER CREATED: replace virtual-switch, docker-machine regenerate-certs dkcifs, docker-machine env dkcifs
:# In boot2dockercifs ; sudo bash /opt/mnt_c.bash
