#!/bin/bash
hostname=`cat /etc/hostname`
ip=`wget -O - -q icanhazip.com`
echo -e "Name = $hostname \nip = $ip \nCustomer = " > /etc/company.facts

