# boot2docker-cifs
create windows Hyper-V docker-machine image for use with cifs to mount C: drive

### Check only with Hyper-V docker-machine

### create ISO file with docker-machine

precondition: docker for windows and tools are prepared.
example installation with scoop:
```cmd
scoop install sudo
scoop install docker
```

confirm this command:
```cmd
C:\home> docker ps
CONTAINER ID      IMAGE      COMMAND      CREATED       STATUS      PORTS      NAMES
```

create iso file
```cmd
C:\home> docker run --env CIFS_USR=dockercifs --env CIFS_PSW=dockercifs --rm korabo/boot2docker-cifs:latest > boot2docker.cifs.iso
```

create docker-machine with created iso file
```cmd
C:\home> sudo docker-machine create --driver hyperv --hyperv-virtual-switch hv-nat --hyperv-boot2docker-url boot2docker.cifs.iso default
```
