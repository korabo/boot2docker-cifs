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
In Hyper-V manager, change virtual switch from 'hv-nat' to 'default switch'.
Because defautl switch can provide dhcp/nat/dns server to vm.

In boot2docker-cifs vm on Hyper-V:
```bash
sudo bash /opt/mnt_c.bash
sudo df -h
ls -F /c
```

Trouble:
1) failed to acccess to server on created docker container.
   check dnsserver lines in /etc/resolv.conf  