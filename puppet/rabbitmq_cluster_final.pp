class rabbitmq{
file { 'install_rabbit.sh':
       path => '/home/install_rabbit.sh',
       ensure  => file,
       source => "puppet:///files/install_rabbit.sh",
       mode    => 0777,
       owner   => 'root',
       group   => 'root'
}
exec { "/home/install_rabbit.sh":
  path   => "/usr/bin:/usr/sbin:/bin",
  require => File['install_rabbit.sh']
}
package { "rabbitmq-server":
  ensure => installed
  require => Exec["/home/install_rabbit.sh"]
  }
  service { "rabbitmq-server":
  ensure => running,
  enable  => true,
  require => Package["rabbitmq-server"],
  }
}
class rabbitmq-master{
file { 'ip_list':
       path => '/home/ip_list',
       ensure  => file,
       source => "puppet:///files/ip_list",
       mode    => 0655,
       owner   => 'root',
       group   => 'root'
}
file { 'configure_rabbit.py':
       path => '/home/configure_rabbit.py',
       ensure  => file,
       source => "puppet:///files/configure_rabbit.py",
       mode    => 0777,
       owner   => 'root',
       group   => 'root'
}
file { 'erlang.cookie':
       path => '/var/lib/rabbitmq/.erlang.cookie',
       ensure  => file,
       replace => yes,
       source => "puppet:///files/erlang.cookie",
       mode    => 0400,
       owner   => 'rabbitmq',
       group   => 'rabbitmq'
}
exec { "/home/configure_rabbit.py":
  path   => "/usr/bin:/usr/sbin:/bin",
  require => File['ip_list']
}
}
class rabbitmq-node{
file { 'ip_list':
       path => '/home/ip_list',
       ensure  => file,
       source => "puppet:///files/ip_list",
       mode    => 0655,
       owner   => 'root',
       group   => 'root'
}
file { 'configure_rabbit.py':
       path => '/home/configure_rabbit.py',
       ensure  => file,
       source => "puppet:///files/configure_rabbit.py",
       mode    => 0777,
       owner   => 'root',
       group   => 'root'
}
file { 'erlang.cookie':
       path => '/var/lib/rabbitmq/.erlang.cookie',
       ensure  => file,
       replace => yes,
       source => "puppet:///files/erlang.cookie",
       mode    => 0400,
       owner   => 'rabbitmq',
       group   => 'rabbitmq'
}
file { 'cluster.sh':
       path => '/home/cluster.sh',
       ensure  => file,
       source => "puppet:///files/cluster.sh",
       mode    => 0777,
       owner   => 'root',
       group   => 'root'
}
exec { "/home/configure_rabbit.py":
  path   => "/usr/bin:/usr/sbin:/bin",
  require => File['ip_list']
}
exec { "/home/cluster.sh":
  path   => "/usr/bin:/usr/sbin:/bin",
  require => Exec["/home/configure_rabbit.py"]
}
}
