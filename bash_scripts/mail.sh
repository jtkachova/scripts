#!/bin/bash
cd /var/mail/
user_file=/home/mail/user.txt
final_file=/home/mail/users_final.txt
max_size=5
cat $user_file|while read line
        do
		size=`echo $line|awk '{print $1}'|grep M|sed s/[^0-9,]//g`
		echo $size
		if [ -n "$size" ]
			then
				if [ "$size" > "$max_size" ]
					then
						echo $line|awk '{print $2}'  >> $final_file
					fi
			fi	
done
