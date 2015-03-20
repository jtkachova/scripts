#!/usr/bin/python
import re
import shutil
fact = open("/var/lib/puppet/yaml/facts/prod-graph-builder.eu-west-1.compute.internal.yaml", "r")
hosts = open("/etc/puppet/files/graph_builder", "r")
temp = open("/home/julyb/ip_tzm_tmp", "w")
pattern= 'ec2_local_ipv4'
ip_h=0
def ip(file,word):
                 for line in file.readlines():
                     ip= re.findall(word, line)
                     if ip:
                          list=line.split("\"")
                          global ip_h
                          ip_h= list[1]         
                 file.close()
ip(fact,pattern)
ip_c=0
def hosts2(file):
                 for line in file.readlines():
                     if line:
                          global ip_c
                          ip_c= line         
                 file.close() 
hosts2(hosts)
if ip_h != ip_c:
               temp.write(ip_h)
               temp.close()
               shutil.copy2('/home/julyb/ip_tzm_tmp', '/etc/puppet/files/graph_builder')

                          
                                       
               
