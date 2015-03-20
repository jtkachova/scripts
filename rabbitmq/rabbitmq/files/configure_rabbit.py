#!/usr/bin/python
import subprocess
import re
ip_list = open("/home/ip_list", "r")
pattern2 = 'inet addr'
#Replace 'masters ip address' to name and ip address master node, for example: rabbit1 10.25.36.1
subprocess.os.system('echo "masters ip adress" >> /etc/hosts')
ip_internal = 0
def get_ip (pattern):
		out = subprocess.Popen('ifconfig eth0', shell=True, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
		for line in out.stdout.readlines():
			ip_find = re.findall(pattern, line)
			if ip_find:
					list = line.split(":") 
					global ip_internal
					ip_internal2 = list[1]
					ip_internal = re.findall("\d+.", ip_internal2)
					ip_internal =''.join(ip_internal)
					ip_internal = ip_internal.strip()
					return ip_internal
get_ip(pattern2)
for line in ip_list.readlines():
	hostname_find = re.findall(ip_internal, line)
        if hostname_find:
			list = line.split(" ")
			hostname2 = list[0]
			subprocess.os.environ['hostname2'] = hostname2
			subprocess.os.system('hostname $hostname2')
