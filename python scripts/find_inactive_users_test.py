#!/usr/bin/python
import os
import sys
import re
import subprocess
def unzip(folder,users_file,tmp_file):
	 				for root, dirs, files in os.walk(folder):
						for file in files:
							file_path = os.path.join(root, file)
							subprocess.os.environ['file_path'] = file_path
							subprocess.Popen("gunzip $file_path", shell=True, stdout=subprocess.PIPE)
							f1 = open(users_file, "r")
							f2 = open(tmp_file, "w")
							for line in f1.readlines():
											line=line.strip()
											subprocess.os.environ['users'] = line
											
											out,err = subprocess.Popen("cd /home/july/mail/;grep -rn $users *|grep from", shell=True, stdout=subprocess.PIPE).communicate()									

											if len(out) > 0:
														f2.write(line +'\n')
														continue
							f2.close()
							f1.close()
							#subprocess.Popen("cd /home/july/mail/; rm maillog.0", shell=True, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
											

folder = "/home/july/mail"
users_file = "/home/july/python/mailb1.txt"
tmp_file = "/home/july/python/tmp_file.txt"
unzip(folder,users_file,tmp_file)
														
														
														
