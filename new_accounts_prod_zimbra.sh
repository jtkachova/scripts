#!/bin/bash
tmp_file=/home/test/tmp_accs.txt
file_accs=/mnt/share/files/accs_prod.txt
accs_full_file=/mnt/share/files/accs_full.txt
/opt/zimbra/bin/zmprov -lgaa > $accs_full_file
date=`date +%D`
touch $file_accs
su - zimbra -c /opt/zimbra/bin/zmaccts|awk '{print $1, $3}'|grep $date > $tmp_file
cat $tmp_file|awk '{print $1}'|while read line
	do
			name=`/opt/zimbra/bin/zmprov -ga $line displayName|sed -n "2p"`
			        echo $line $name >> $file_accs
			done
#Create file with full list accounts
chmod a+rw $file_accs
chmod a+rw $accs_full_file
