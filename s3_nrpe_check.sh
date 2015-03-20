#!/bin/bash
mount=`df -h|grep s3`
if [ -z "$mount" ]
   then
       echo "s3 isn't availiable"
       exit 2
   else
       echo "ok"
       exit 0
fi
