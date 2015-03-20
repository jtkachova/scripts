#!/bin/bash
file=/tmp/check_zimbra.txt
pattern=Running
zmcontrol status >> $file
line=`cat $file|grep $1`
	status=`echo $line|awk '{print $2}'`
	if [ "$status" != "$pattern" ]
		then
                     echo "1"
		else
               	     echo "0"

rm $file

