#!/bin/bash
cat /root/.ssh/key.pub >> /root/.ssh/authorized_keys
cd /opt/app/mega-store/current; 
export "GEM_HOME=/usr/local/rvm/gems/ruby-2.0.0-p353"
export "IRBRC=/usr/local/rvm/rubies/ruby-2.0.0-p353/.irbrc"
export "OLDPWD=/usr/local/rvm/gems/ruby-2.0.0-p353/bin"
export "MY_RUBY_HOME=/usr/local/rvm/rubies/ruby-2.0.0-p353"
export "rvm_path=/usr/local/rvm"
export "rvm_prefix=/usr/local"
export "PATH=/usr/local/rvm/gems/ruby-2.0.0-p353/bin:/usr/local/rvm/gems/ruby-2.0.0-p353@global/bin:/usr/local/rvm/rubies/ruby-2.0.0-p353/bin:/usr/local/rvm/bin:/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/root/bin"
export "rvm_ruby_string=ruby-2.0.0-p353"
export "GEM_PATH=/usr/local/rvm/gems/ruby-2.0.0-p353:/usr/local/rvm/gems/ruby-2.0.0-p353@global"
export "rvm_is_not_a_shell_function=1"
export "RUBY_VERSION=ruby-2.0.0-p353"
#bash -lc "/usr/local/rvm/bin/rvm use ruby-2.0.0-p353"
bash -lc "/usr/local/rvm/gems/ruby-2.0.0-p353/wrappers/bundle install"
secret=`/usr/local/rvm/rubies/ruby-2.0.0-p353/bin/rake secret`
echo "Mega::Application.config.secret_key_base = '$secret'" > /opt/app/mega-store/config/initializers/secret_token.rb
bash -lc "/usr/local/rvm/gems/ruby-2.0.0-p353/bin/unicorn_rails -c /opt/app/mega-store/shared/unicorn.rb -D -E production -p 8080 > /dev/null 2>&1"
/usr/bin/gem install -f puppet
#/etc/init.d/puppet restart
exit 0

