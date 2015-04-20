#!/bin/bash
Acces_key=/root/tranzmate/API-keys/pk-KFEHDJ3Q2TIBDABLRBZXWEAMIWS4JAJI.pem
Private_key=/root/tranzmate/API-keys/cert-KFEHDJ3Q2TIBDABLRBZXWEAMIWS4JAJI.pem
# file with results command ec2-describe-instances
file=/home/julyb/result
#region
region=eu-west-1
#file contains instance_id and names of servers
id_file=/home/julyb/ins_id
#file with public DNS names before check
name_cur_file=/home/julyb/name_cur
#file with public DNS after check
name_file=/home/julyb/name_file
n=1
l=1
    cat $id_file|while read line
        do
           instance_id=`echo $line|awk '{print $1}'`
           ec2-describe-instances -K $Acces_key -C $Private_key --region $region $instance_id    --filter "ip-address=*">$file
           cat $file |awk '{print $4}'|sed -n '2p'>> $name_file
        done

    cat $name_cur_file|while read myline
        do

          cat $name_file|while read line
              do
                name_cur[$n]=`echo $myline`
                name_n[$l]=`echo $line`
                l=`expr $l + 1`
               done
         instance_name=`cat $id_file|sed -n "$n p"|awk '{print $2}'`
         if [ "${name_n[$n]}" != "${name_cur[$n]}" ]
             then
                 /usr/bin/sendEmail -f monitor@siq4you.com -t support.siq4you.com -o message-charset=utf-8 -u "$instance_name changed name" -m "$instance_name changed name to ${name_n[$n]}"
                 echo "warning"
             else
                 echo "ok"
         fi
       n=`expr $n + 1`
     done
rm $name_file
touch $name_file
exit 0

