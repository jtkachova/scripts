#!/bin/bash
accts_file=/home/test/all_acc_standby.txt
cat $accts_file|while read line
        do
		#Get first and last name regarding username
		name=`zmprov -ga $line displayName|sed -n "2p"`
                echo $line $name >> /home/test/full_name_zimbra_acc_standby_final.txt
		done

