class munin-plugins-custom{
 package { "munin-node":
  ensure => installed
  }
  service { "munin-node":
  ensure => running,
  enable  => true,
  require => Package["munin-node"],
  }
exec { "mkdir /usr/share/munin/plugins/customs":
  path   => "/usr/bin:/usr/sbin:/bin",
}
file { "/usr/share/munin/plugins/customs":
  source => "puppet://munin-plugins",
  recurse => true,
  require => Exec["mkdir /usr/share/munin/plugins/customs"]
}
exec { "ln -s /usr/share/munin/plugins/customs/* /etc/munin/plugins/":
  path   => "/usr/bin:/usr/sbin:/bin",
  require => File["/tmp/munin-plugins"],
  notify => Service["munin-node"]
}
}
