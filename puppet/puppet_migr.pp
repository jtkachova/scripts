class puppet_migr{
  service { "puppet":
  ensure => running,
  enable  => true
  }
file { 'puppet_migrate.py':
    path => '/tmp/puppet_migrate.py',
    ensure  => file,
    source => "puppet:///files/scripts/puppet_migrate.py",
    mode    => 0777,
    owner   => 'root',
    group   => 'root'
}
exec { "/tmp/puppet_migrate.py":
  notify => Service["puppet"],
  path   => "/usr/bin:/usr/sbin:/bin",
  subscribe => File["puppet_migrate.py"],
  refreshonly => true
}
