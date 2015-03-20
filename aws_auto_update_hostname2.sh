#!/bin/bash
#set -x
#
#
#
export EC2_URL=https://ec2.us-west-1.amazonaws.com
export EC2_PRIVATE_KEY=/home/johnd/ec2-tools/pk-4LWJFYS6RW32U6MCMZKJWGNH5HI2LA3B.pem
export EC2_CERT=/home/johnd/ec2-tools/cert-4LWJFYS6RW32U6MCMZKJWGNH5HI2LA3B.pem

tzm_ec2s=/home/johnd/ec2-tools/tzm_ec2s
tzm_iName=/home/johnd/ec2-tools/tzm_iName
tzm_address=/home/johnd/ec2-tools/tzm_address

ec2-describe-instances --filter instance-state-name=running > $tzm_ec2s
# take instance id + instance name and instance ip
cat $tzm_ec2s | grep Name | awk '{print $3" "$5}' |tr '.' '-' > $tzm_iName
cat $tzm_ec2s | grep INSTANCE | awk '{print $2" "$4}' > $tzm_address
n=1

cat $tzm_address|while read line
    do
		# no we have the id and ip, split them
		IFS=' ' read -a idip <<< "$line"
		id=${idip[0]}
		address=${idip[1]}
		# if u first login to server ssh will ask you if it's ok to loging and will store it's ip and key and then if the ip changed it will not let
		# you login, as ip doesn't match the key... to avoid all this, tell ssh to always store the ip/key, but in /dev/null so it will be always new
        hostname_current=`ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -i /home/johnd/support/johnd/johnd-aws.pem ubuntu@$address "hostname"`
        # we know the id, find the correct name for the id
        instance_name=`cat $tzm_iName | grep $id | awk {'print $2'}`
            if [ "$hostname_current" != "$instance_name" ]
             then
				# tee thingy doesn't work good... it need also sudo and it just adds new line and not changes the hostname, sed will do the work
				#"sudo echo '127.0.0.1 $instance_name' | tee -a /etc/hosts; 
                ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -i /home/johnd/support/johnd/johnd-aws.pem ubuntu@$address \
                "sudo sed -i 's/127\.0\.0\.1 .*/127\.0\.0\.1 $instance_name/g' /etc/hosts; \
                sudo echo '$instance_name' > /etc/hostname; \
                sudo /etc/init.d/hostname restart"

                /usr/bin/sendEmail -f monitor@siq4you.com -t johnd@forthscale.com \
                -o message-charset=utf-8 -u "**Alert** $hostname_current Hostname Changed" \
                -m "Hostname changed name from $hostname_current to $instance_name"
              else
                echo "OK"
             fi
        n=`expr $n + 1`
     done
exit 0
