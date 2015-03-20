#!/usr/bin/python
import os
import sys
import re
import subprocess
def unzip(folder,users_file,tmp_file):
	 				for root, dirs, files in os.walk(folder):
						for file in files:
							file_path = os.path.join(root, file)
							#print(file_path)
							subprocess.os.environ['file_path'] = file_path
							#subprocess.Popen("gunzip $file_path", shell=True, stdout=subprocess.PIPE)
							f1 = open(users_file, "r")
							f2 = open(tmp_file, "w")
							for line in f1.readlines():
											line=line.strip()
											subprocess.os.environ['users'] = line
											
											out,err = subprocess.Popen("cd /home/july/mail/;grep -rn $users *|grep from", shell=True, stdout=subprocess.PIPE).communicate()									

											if len(out) > 0:
														f2.write(line +'\n')
							f2.close()
							f1.close()
							#subprocess.Popen("cd ..;rm $file_path", shell=True, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
def create_final_file(tmp_file,users_file,final_file):
							f1 = open(tmp_file, "r")
							f2 = open(users_file, "r")
							f3 = open(final_file, "w")
							user_list = f2.read()
							for line2 in f2.readlines():
										list_users = re.findall(line2, user_list)
										if list_users:
												print("User is active")
										else:
											f3.write(line)
							f1.close()
							f2.close()
							f3.close()

											

folder = "/home/july/mail"
users_file = "/home/july/python/mailb1.txt"
final_file = "/home/july/python/final_users_file.txt"
tmp_file = "/home/july/python/tmp_file.txt"
unzip(folder,users_file,tmp_file)
#create_final_file(tmp_file,users_file,final_file)														
														
														
