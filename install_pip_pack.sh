#!/bin/bash
cat /opt/git/fbu/requirements.txt|while read line
	do
		pack=`/usr/bin/pip freeze|grep $line`
			if [ -z "$pack" ]	
				then
					/usr/bin/pip install $line	
			fi				
	done
exit 0
