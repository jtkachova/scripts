#!/usr/bin/python
import re
f1 = open("/home/july/rothem", "r")
f2 = open("/home/july/rothem2", "w")
pattern= 'http://www.rothemcollection.com'
for line in f1.readlines():
     ip= re.findall(pattern, line)
     if ip: 
           list=line.split("/")
           del list[0:3]
           list.insert(0, 'Disallow: ')
           line='/'.join(list)
           f2.write(line)
f2.close()
f1.close()
