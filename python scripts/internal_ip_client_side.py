#!/usr/bin/python
import re
import shutil
hosts = open("/etc/hosts", "r")
temp = open("/home/ip_tzm_tmp", "w")
filename=open("/home/graph_builder", "r")
pattern= 'prod-graph-builder.eu-west-1.compute.internal'
ip_h=0
def ip(file):
                 for line in file.readlines():
                     if line:
                          global ip_h
                          line=line.strip()
                          ip_h= line      
                 file.close()
ip(filename)
def host_file(file,dest,word):
                 for line in file.readlines():
                     ip= re.findall(word, line)
                     if ip:
                          list=line.split(" ")
                          list[0]=ip_h
                          print(list)
                          str=' '.join(list)
                          dest.write(str)
                     else:
                          dest.write(line)        
                 file.close()
                 dest.close()
 
host_file(hosts,temp,pattern)
shutil.copy2('/home/ip_tzm_tmp', '/etc/hosts')

