# greenbone-openvas-makejail

Greenbone-OpenVAS-MakeJail is a [AppJail](https://github.com/DtxdF/AppJail) file ([AppJail-makejail](https://github.com/AppJail-makejails)) used by deploy a testing [Greenbone OpenVAS](https://greenbone.net/en/) All-in-one infrastructure on [FreeBSD](https://freebsd.org/). The principal goals are helps us to fast way install, configure and run Greenbone OpenVAS components. Take on mind this container as is must be used by testing/learning purpose and it is not recommended for production because it has a minimal configuration for run Greenbone Suite.

![image](https://github.com/alonsobsd/greenbone-openvas-makejail/assets/11150989/a7f2b896-e6cd-40b0-a5d4-123a40fd39f6)

![image](https://github.com/alonsobsd/greenbone-openvas-makejail/assets/11150989/e4ee49cf-f82d-458f-ad08-072164b23cd5)


## Requirements
Before you can install greenbone-openvas using this makejail you need some initial configurations

#### Enable Packet filter
We need add somes lines to /etc/rc.conf

```sh
# sysrc pf_enable="YES"
# sysrc pflog_enable="YES"

# cat << "EOF" >> /etc/pf.conf
nat-anchor 'appjail-nat/jail/*'
nat-anchor "appjail-nat/network/*"
rdr-anchor "appjail-rdr/*"
EOF
# service pf reload
# service pf restart
# service pflog restart
```
rdr-anchor section is necessary for use dynamic redirect from jails

### Enable forwarding
```sh
# sysrc gateway_enable="YES"
# sysctl net.inet.ip.forwarding=1
```

### Add devfs rules
Some openvas scanner tasks  need access to /dev/bpf device. Add the following lines to /etc/devfs.rules
```sh
[devfsrules_jail=10]
add include $devfsrules_hide_all
add include $devfsrules_unhide_basic
add include $devfsrules_unhide_login
add path 'bpf' unhide mode 0660 group 272 unhide
```

#### Bootstrap a FreeBSD version
Before you can begin creating containers, AppJail needs fetch and extract components for create jails. If you are creating FreeBSD jails it must be a version equal or lesser than your host version. In this example we will create a 13.2-RELEASE bootstrap

```sh
# appjail fetch
```
#### Create a virtualnet
Create a virtualnet for add greenbone jail to it from greenbone-openvas-makejail

```sh
# appjail network add greenbone-net 10.0.0.0/24
```
it will create a bridge named greenbone-net in where greenbone jail epair interfaces will be attached. By default greenbone-openvas-makejail will use NAT for internet outbound. Do not forget added a pass rule to /etc/pf.conf because greenbone-openvas-makefile will try to download and install packages and some another resources for configuration of greenbone services

```sh
pass out quick on greenbone-net inet proto { tcp udp } from 10.0.0.2 to any
```
#### Create a lightweight container system
Create a container named greenbone with a private IP address 10.0.0.2. Take on mind IP address must be part of greenbone-net network

```sh
# appjail makejail -f gh+alonsobsd/greenbone-openvas-makejail -j greenbone -- --network greenbone-net --greenbone_ip 10.0.0.2
```

When it is done you will see credentials info for connect to gsad/gsa via web browser.

```sh
################################################ 
 Greenbone OpenVAS admin credential                
 Hostname : https://jail-host-ip   
 Username : admin                                 
 Password : @hkXudpIp93xbIOvD                     
################################################
 ```
Keep it to another secure place

## License
This project is licensed under the BSD-3-Clause license.
