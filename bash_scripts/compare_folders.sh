#!/bin/bash
local_dir="/otp/"
s3_dir="/mnt/s3/prod_otp/"
file="/home/ubuntu/test"
if [ -z "diff -rq $local_dir $s3_dir" ];then
echo "ok"
else
    diff -rq $local_dir $s3_dir>>$file
    cat $file|while read line
        do
          file1=`echo $line|awk '{print $2}'`
          file2=`echo $line|awk '{print $4}'`
            if [ $file1 -nt $file2 ]
            then
               echo "copy $file1 to $file2"
               cp -p $file1 $file2
            else
               cp -p $file2 $file1
               echo "copy $file2 to $file1"
            fi
        done
fi
rm $file
touch $file
exit 0