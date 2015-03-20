#!/bin/bash
mount=`df -h|grep s3`
if [ -z "$mount" ]
   then
       cd /home
       wget http://s3fs.googlecode.com/files/s3fs-1.61.tar.gz
       tar xvzf s3fs-1.61.tar.gz
       cd s3fs-1.61/
       ./configure --prefix=/usr
       make
       make install
       mkdir /s3
       s3fs tzm -o allow_other  /s3
       echo "s3fs#tzm /s3 fuse allow_other,url=https://s3.amazonaws.com 0 0" >> /etc/fstab
fi



