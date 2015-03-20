#!/usr/bin/python
import re
#Function adds new allowed hosts to config
def allowed_hosts(config,test_file,arg,ip_allow):
		f1 = open(config, "r")
		f2 = open(test_file, "w")
		for line in f1.readlines():
				ip= re.findall(arg, line)
				if ip:
					ip_new= re.findall(ip_allow, line)
					if len(ip_new) > 0 :
						f2.write(line)
					else:
						line=line.strip()
                     				string= line + ',' + ip_allow + '\n'
						print(string)
                    				f2.write(string)
               			else:
                        		f2.write(line)	
		f2.close()
		f1.close()
#Function adds new command definition to config
def commands_def(config,test_file,arg_commands,commands):
	f1 = open(config, "r")
	f2 = open(test_file, "w")
       
	for line in f1.readlines():
				definition= re.findall(commands, line)
				if definition:
						f2.write(line)
				else:
						commands_block = re.findall(arg_commands, line)
						if commands_block:
							print(commands)
							f2.write(commands +'\n')
						else:
							f2.write(line)
	f2.close()
	f1.close()			
#Parametres for functions: open files, commands definitions, new ip etc
config = "/home/july/nrpe.cfg"
test_file = "/home/july/test.cfg"
file_final="/home/july/test2.cfg"
arg_commands= 'hardcoded'
arg= 'allowed_hosts'
ip_add='78.47.86.153'
commands = 'test=ghgh'
#Call functions with needed parameters, you can do it many times if we are talking about adding new commands definitions
allowed_hosts(config,test_file,arg,ip_add)
commands_def(test_file,file_final,arg_commands,commands)
