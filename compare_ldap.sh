#!/bin/bash
zimbra_file=/storage2/zimbra/files/accs_full.txt
zimbra_fin=/storage2/zimbra/files/zimbra_mailboxes.txt
ldap_file=/storage2/zimbra/files/ldap.txt
final_file=/storage2/zimbra/files/change_users.txt
ldapsearch -LLL -x -b "ou=addressbook,dc=avk,dc=ua" -h 192.168.3.1 -p 389 "mail=*"|grep mail|awk '{print $2}' > $ldap_file
cat $zimbra_file|while read line
	do
                user=`echo ${line%?dkf*}`
		user_final=`echo $user@avk.ua`
                echo $user_final > $zimbra_fin
	done
cat $zimbra_fin|while read mailbox
	do
		username=`echo ${mailbox%$?avk*}`
		ldap_username=`cat $ldap_file|grep -i $username`
                mailboxf=`echo $mailbox| tr A-Z a-z`
                ldap_usernamef=`echo $ldap_username| tr A-Z a-z`
		if [ "$mailboxf" != "$ldap_usernamef" ]
			then
				echo $mailbox does not match with ldap address book >> $final_file
			fi
	done 
if [ -s $final_file ]
	then
		message_text=`cat $final_file`
		echo $message_text|mail -s "ldap address book" Elena.Eremenko@avk.ua
		rm $final_file
	fi

