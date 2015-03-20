class deploy_monitoring{
include class nrpe_deploy, munin-plugins
}
class add_to_monitoring{
service { "icinga":
    ensure => running,
    enable  => true
}
file { 'add_to_icinga.py':
    path => '/tmp/add_to_icinga.py',
    ensure  => file,
    source => "puppet:///files/plugins/add_to_icinga.py",
    mode    => 0777,
    owner   => 'root',
    group   => 'root'
}
exec {"backup_icinga":
        path   => "/usr/bin:/usr/sbin:/bin",
	command => "set $(date);tar cfz /home/julyb/backup/icinga_backup_$6-$2-$3.tgz /etc/icinga/objects"
}
exec { "/tmp/add_to_icinga.py":
  path   => "/usr/bin:/usr/sbin:/bin",
  subscribe => File["add_to_icinga.py"],
  refreshonly => true,
  require => Exec["backup_icinga"],
  notify => Service["icinga"]
}
