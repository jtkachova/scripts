#!/bin/bash
set $(date)
curl -X GET http://localhost:5984/af-apps/_all_docs?include_docs=true > /mnt/backups/af-apps_$6-$2-$3.txt
gzip /mnt/backups/af-apps_$6-$2-$3.txt
mv /mnt/backups/af-apps_$6-$2-$3.txt.gz /mnt/s3/backups/aff-apps/
