:# create local user (e.g.  user=dockercifs/password=dockercifs)
:# start C drive sharing only to given user (e.g. dockercifs)
docker build --file Dockerfile --tag korabo/boot2docker-cifs:latest ./
:# docker login
:# docker push korabo/boot2docker-cifs:latest
:# docker run --env CIFS_USR=dockercifs --env CIFS_PSW=dockercifs --rm korabo/boot2docker-cifs:latest > boot2docker.cifs.iso
:# sudo docker-machine create --driver hyperv --hyperv-virtual-switch hv-nat --hyperv-boot2docker-url boot2docker.cifs.iso dkcifs
:# copied by docker-machine to C:\Users\<username>\.docker\machine\machines\default\boot2docker.iso
:# AFTER CREATED: replace virtual-switch, docker-machine regenerate-certs default, docker-machine env default
:# In boot2docker-cifs vm on Hyper-V  do: sudo bash /opt/mnt_c.bash
