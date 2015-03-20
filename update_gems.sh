#!/bin/bash
/bin/mkdir -p /opt/app
#/usr/bin/curl -L https://get.rvm.io | bash -x
#/usr/local/rvm/scripts/rvm reload
#/usr/local/rvm/scripts/rvm install ruby-2.0.0-p353
#exit 0


#!/bin/bash
/usr/bin/gem update --system
#/bin/mkdir /opt/app
#/usr/bin/curl -L https://get.rvm.io | bash -s stable
curl -L get.rvm.io | bash -s stable
# Load RVM into a shell session *as a function*
#if [[ -s "$HOME/.rvm/scripts/rvm" ]] ; then
#
#  # First try to load from a user install
#  source "$HOME/.rvm/scripts/rvm"

#elif [[ -s "/usr/local/rvm/scripts/rvm" ]] ; then
#
  # Then try to load from a root install
#  source "/usr/local/rvm/scripts/rvm"

#else

#  printf "ERROR: An RVM installation was not found.\n"

#fi

#source $(rvm ruby-2.0.0-p353 do rvm env --path)
#/usr/local/rvm/bin/rvm reload
source "/usr/local/rvm/bin/rvm reload"
bash -lc "/usr/local/rvm/bin/rvm install ruby-2.0.0-p353"
bash -lc "source "/usr/local/rvm/bin/rvm reload""
bash -lc "source "/usr/local/rvm/scripts/rvm""
echo "using root install /usr/local/rvm/scripts/rvm"
bash -lc "/usr/local/rvm/bin/rvm use ruby-2.0.0-p353"
/usr/bin/gem install capistrano


exit 0

