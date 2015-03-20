#!/usr/bin/python
import re
import subprocess
import shutil
def generate_host_definition(ip,instance_name,contact_group,hostgroup,template):
			string = 'define host{\n   use     		' + template + '\n   ' + \
			  	 'hostname     	' + instance_name + '\n   ' + \
				  'alias     		' + instance_name + '\n   ' + \
				  'address     		' + ip + '\n   '\
				  'hostgroups     	' + hostgroup + '\n   ' + \
				  'max_check_attempts     5\n   '\
				  'contact_groups     	' + contact_group + '\n   ' + \
				  'check_command     	check_host_ssh\n   }\n'
			return string 
def add_host_definition(host_file,string):
			f1 = open(host_file, "a")
			f1.write(string)
			f1.close
def add_host_services(config_file,tmp_file,instance_name,arg1='CPU',arg2='LOAD',arg3='Disk_Space'):
			f1 = open(config_file, "r")
		  	f2 = open(tmp_file, "w")
			arg_list = [ arg1, arg2, arg3]
			counter = 0
			lines = f1.read().splitlines() 
			for line in lines:
				for arg in arg_list: 
					pattern = re.findall(arg, line)
					if pattern:
						position = [counter-1]
						prev_line = lines[counter-1]
						lines[counter-1] =  prev_line + ',' + instance_name
				counter += 1
			text = '\n'.join(lines)
			f2.write(text)
			f2.close
			f1.close
			shutil.copy2(tmp_file, config_file)
ip = '10.20.35'
instance_name = 'test_name'
contact_group = 'admins'
hostgroup = 'admins'
config_file = "/home/july/test/service.cfg"
host_file = "/home/july/test/host.cfg"
tmp_file = "/home/july/test/icinga_test.cfg"
subprocess.os.environ['config_file'] = config_file
out  = subprocess.Popen("cat $config_file|grep use|awk '{print $2}'|sed -n 1p", shell=True, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
output = out.communicate()
template = output[0]
template =''.join(template)
template = template.strip()
string = generate_host_definition(ip,instance_name,contact_group,hostgroup,template)
add_host_definition(host_file,string)			
add_host_services(config_file,tmp_file,instance_name)						
