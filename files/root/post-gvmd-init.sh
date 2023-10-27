#!/bin/sh
#
echo " "
echo -e "\e[1;37m Generating admin password ...\e[0m"
echo " "

sleep 3

adminpass=$(openssl rand -base64 14)


su -m gvm -c "gvmd --create-user=admin"
su -m gvm -c "gvmd --user=admin --new-password=${adminpass}"

adminuuid=$(su -m gvm -c "gvmd --get-users --verbose" | cut -d " " -f2)

su -m gvm -c "gvmd --modify-setting 78eceaec-3385-11ea-b237-28d24461215b --value ${adminuuid}"

echo " "
echo -e "\e[1;37m ################################################ \e[0m"
echo -e "\e[1;37m Greenbone OpenVAS admin credential               \e[0m"
echo -e "\e[1;37m Hostname : https://jail-host-ip                  \e[0m"
echo -e "\e[1;37m Username : admin                                 \e[0m"
echo -e "\e[1;37m Password : ${adminpass}                          \e[0m"
echo -e "\e[1;37m ################################################ \e[0m"
echo " "

echo " "
echo -e "\e[1;37m Password generated ...\e[0m"
echo " "

sleep 3
