#!/usr/bin/python
import re
import shutil
f1 = open("/etc/puppet/puppet.conf", "r")
f2 = open("/tmp/puppet_tmp", "w")
pattern= 'main'
append = 'server = puppet.forthscale.com'
for line in f1.readlines():
	definition = re.findall(pattern, line)
	if definition:			
			f2.write(line +'\n' + append + '\n')
	else:
			f2.write(line)
f1.close()
f2.close()
shutil.copy2('/tmp/puppet_tmp', '/etc/puppet/puppet.conf')

