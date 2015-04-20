#!/bin/bash
cd /opt/app/mega-store/
node_list=/opt/list.txt
status1=changed
cat $node_list|while read line
        do
f1=`ls -t /var/lib/puppet/reports/$line| head -1`
#echo $f1
node_class=`cat /var/lib/puppet/reports/$line/$f1|grep for_capistrano`
if [ -n "$node_class" ]
   then
   status=`cat /var/lib/puppet/reports/$line/$f1|grep status| grep changed|awk '{print $2}'`
   if [ "$status" = "$status1" ]
             echo $line
             echo $status
	     echo $status1
             then
		touch /etc/puppet/files/puppet_image.txt
                #/usr/local/rvm/gems/ruby-2.1.1/bin/cap production deploy
		echo "changed" >> /etc/puppet/files/puppet_image.txt
                echo "node" >> /etc/puppet/files/blank.txt
             fi
fi
done
exit 0
