#!/bin/bash
File=/home/tmp.txt
iptables -L FORWARD --line-numbers|grep monitor2|grep DROP >> $File
cat $File|while read line
    do
if [ -n "$line" ]
   then
       line_number=`echo $line |awk '{print $1}'`
       iptables -D FORWARD $line_number
fi
done

