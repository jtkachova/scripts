class nrpe_
{
  package { "nagios-nrpe-server":
  ensure => installed,
  options => norecommended
  }
  package { "nagios-nrpe-plugin":
  ensure => installed,
  options => norecommended
  }
  service { "nagios-nrpe-server":
  ensure => running,
  enable  => true,
  require => Packge[nagios-nrpe-server]
  }
file { 'check_disk2':
    path => '/usr/lib/nagios/plugins/check_disk2',
    ensure  => file,
    source => "puppet:///files/plugins/check_disk2",
    mode    => 0755,
    owner   => 'root',
    group   => 'root'
}

file { 'nrpe_web.py':
    path => '/tmp/nrpe_web.py',
    ensure  => file,
    source => "puppet:///files/plugins/nrpe_web.py",
    mode    => 0777,
    owner   => 'root',
    group   => 'root'
}
file { 'sudoers.sh':
   path => '/tmp/sudoers.sh',
   ensure  => file,
   source => "puppet:///files/plugins/sudoers.sh",
   mode    => 0777,
   owner   => 'root',
   group   => 'root'
}
file { 'check_nginx_status.pl':
    path => '/usr/lib/nagios/plugins/check_nginx_status.pl',
    ensure  => file,
    source => "puppet:///files/plugins/check_nginx_status.pl",
    mode    => 0755,
    owner   => 'root',
    group   => 'root'
}
file { 'check_cpu.sh':
    path => '/usr/lib/nagios/plugins/check_cpu.sh',
    ensure  => file,
    source => "puppet:///files/plugins/check_cpu.sh",
    mode    => 0755,
    owner   => 'root',
    group   => 'root'
}
exec { "/tmp/nrpe_web.py":
  path   => "/usr/bin:/usr/sbin:/bin",
  subscribe => File["nrpe_web.py"],
  refreshonly => true,
  #creates => "/tmp/test_nrpe.cfg"
}
exec { "/tmp/sudoers.sh":
  path   => "/usr/bin:/usr/sbin:/bin",
  subscribe => File["nrpe_web.py"],
  refreshonly => true,
  require => Exec["/tmp/nrpe_web.py"]
}
exec {"cp -p /tmp/test2.cfg /etc/nagios/nrpe.cfg":
     path   => "/usr/bin:/usr/sbin:/bin",
     notify  => Service["nagios-nrpe-server"],
     subscribe => File["nrpe_web.py"],
     refreshonly => true,
     require => Exec["/tmp/nrpe_web.py"]
}
}

