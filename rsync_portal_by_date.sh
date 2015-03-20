#!/bin/sh

dir="/storage2/portal/backup"
log_file="/storage2/portal/backup/rsync.log"
log_file2="/storage2/portal/backup/rsync2.log"
dt=`date "+%Y%m%d"`
find $dir/dates/ -maxdepth 1 -type d -mtime +30 -exec rm -rf {} \;

/usr/bin/rsync --archive --dry-run -u -t -v -e "ssh -i /opt/keys/portal_rsa" 10.3.11.50:/home/httpd/ $dir/httpd/ >> $log_file
cat $log_file|grep -v '\/$'|sed '1d'|sed 'N;$!P;$!D;$d' >> $log_file2
mkdir $dir/dates/$dt
cd $dir/httpd/
cat $log_file2|while read line
    do
if [ -n "$line" ]
   then
       /usr/bin/rsync -axv -R $line $dir/dates/$dt/
fi
done
/usr/bin/rsync -avx  -e "ssh -i /opt/keys/portal_rsa" 10.2.60.50:/home/httpd $dir/
files_number=`wc $log_file2| awk '{print $1}'`
message_text=` echo "Backup was finished, sinced $files_number new files"`
echo $message_text|mail -s "portal backup" Yuliya.Barabash@avk.ua
rm $log_file
rm $log_file2

