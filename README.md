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

create iso file with fixed IP and cifs def
```cmd
cd <creating iso dir>
docker run --env CIFS_USR=dockercifs --env CIFS_PSW=egRL8gTsVts2JPgh --env CIFS_DMN=BRE-PC18-10007 --env IP_ADDR=192.168.199.11/24 --env IP_NW=192.168.199.0/24 --env IP_GW=192.168.199.254 --rm korabo/boot2docker-cifs:latest > boot2docker.cifs.iso
```

### create docker-machine with Fixed IP on NAPT

#### create virtural switch with napt
http://www.vwnet.jp/windows/WS12R2/Hyper-V/Hyper-V_Network.htm
https://www.slideshare.net/SMurashima/hyperv-137904259

```cmd
New-VMSwitch -SwitchName "HV-NAT-192168199000" -SwitchType Internal
$NIC = Get-NetAdapter | ? Name -eq "vEthernet (HV-NAT-192168199000)"
$IfIndex = $NIC.IfIndex
New-NetIPAddress -IPAddress 192.168.199.254 -PrefixLength 24 -InterfaceIndex $IfIndex
New-NetNat -Name "192.168.199.0/24" -InternalIPInterfaceAddressPrefix 192.168.199.0/24
```

#### change network with virutl switch into PRIVATE
to use file share
```powershell
Get-NetConnectionProfile

Name             : 識別されていないネットワーク
InterfaceAlias   : vEthernet (HV-NAT-192168199000)
InterfaceIndex   : 13
NetworkCategory  : Public
IPv4Connectivity : NoTraffic
IPv6Connectivity : NoTraffic
```
use "InterfaceIndex   : 13"
```powershell
Set-NetConnectionProfile -InterfaceIndex 13 -NetworkCategory Private
```

#### Windows file share
create user on local-machine(BRE-PC18-10007)
username: dockercifs
password: egRL8gTsVts2JPgh

share:
 C:\ as C

#### create docker-machine with created iso file on napt virtual switch
```cmd
cd <created.iso dir>
sudo docker-machine create --driver hyperv --hyperv-virtual-switch HV-NAT-192168199000 --hyperv-cpu-count 2  --hyperv-boot2docker-url boot2docker.cifs.iso default
```

#### configure vm
change memory
e.g.) 1G -> 1.5G

initialize
  in vm, exec script for initialization
  ```bash
  sudo bash /opt/prepare.bash
  ```

### Trouble:
1) failed to acccess to server on created docker container.
   check dnsserver lines in /etc/resolv.conf  