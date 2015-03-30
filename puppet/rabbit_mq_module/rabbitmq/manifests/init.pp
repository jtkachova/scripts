class rabbitmq{
file { 'install_rabbit.sh':
       path => '/home/install_rabbit.sh',
       ensure  => file,
       source => "puppet:///modules/rabbitmq/install_rabbit.sh",
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


