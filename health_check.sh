#!/bin/bash
ok=PASSED
result=`smartctl -H /dev/sda|grep health|awk '{print $6}'`
if [ "$result" = "$ok" ]
   then
       echo "ok"
       exit 0
   else
       echo $result
       exit 2
fi

