#!/usr/bin/python
import re
#Change config
f1 = open("/etc/init.d/denyhosts", "r")
f2 = open("/home/test_deny", "w")
pattern= '--purge'
pattern_old= '--noemail'
for line in f1.readlines():
     conf= re.findall(pattern, line)
     if conf:
           conf_old= re.findall(pattern_old, line)
           if conf_old:
                       f2.write(line)
           else:
                list=line.split(" ")
                list.insert(1, '--noemail')
                line=' '.join(list)
                f2.write(line)
     else:
                f2.write(line)
f2.close()
f1.close()
#Add lines to hosts.allow
f3 = open("/etc/hosts.allow", "a")
f3.write("sshd: 85.10.208.153\nsshd: 178.79.184.11\nsshd: 199.203.62.102\nsshd: 82.166.141.45\n")
f3.close()
