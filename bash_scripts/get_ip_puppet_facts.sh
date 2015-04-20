#!/bin/bash
#cd /opt/app/mega-store/
grep -rn ipaddress_eth1 /var/lib/puppet/yaml/facts/* | awk '{print $3}'|sed 's,",,g' > /etc/puppet/files/ip_address_list.txt

