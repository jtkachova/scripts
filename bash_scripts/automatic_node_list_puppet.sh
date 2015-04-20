#!/bin/bash
/usr/local/rvm/gems/ruby-2.1.1/gems/puppet-3.5.1/bin/puppet cert list|awk '{print $1}'|sed 's,",,g' >> /opt/list.txt
exit 0

