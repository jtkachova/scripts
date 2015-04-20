#!/bin/bash
#db_file=/mnt/backups/db_file.txt
#N=`cat $db_file`
curl -X POST http://127.0.0.1:5984/_replicate -d '{"source":"af-apps", "target":"http://ec2-46-51-129-209.eu-west-1.compute.amazonaws.com:5984/alg_20", "create_target": true, "continuous": true }' -H "Content-Type: application/json"
#N=`expr $N + 1`
#echo $N > $db_file
