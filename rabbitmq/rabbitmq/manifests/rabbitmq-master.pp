class rabbitmq::rabbitmq-master{
file { 'ip_list':
       path => '/home/ip_list',
       ensure  => file,
       source => "puppet:///modules/rabbitmq/ip_list",
       mode    => 0655,
       owner   => 'root',
       group   => 'root'
}
file { 'configure_rabbit.py':
       path => '/home/configure_rabbit.py',
       ensure  => file,
       source => "puppet:///modules/rabbitmq/configure_rabbit.py",
       mode    => 0777,
       owner   => 'root',
       group   => 'root'
}
file { 'erlang.cookie':
       path => '/var/lib/rabbitmq/.erlang.cookie',
       ensure  => file,
       replace => yes,
       source => "puppet:///modules/rabbitmq/erlang.cookie",
       mode    => 0400,
       owner   => 'rabbitmq',
       group   => 'rabbitmq'
}
exec { "/home/configure_rabbit.py":
  path   => "/usr/bin:/usr/sbin:/bin",
  require => File['ip_list']
}
}
