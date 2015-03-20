class remount_s3{
file { 'tomcat6_default':
       path => '/home/tomcat6_default',
       ensure  => file,
       source => "puppet:///files/tranzmate/tomcat6_default",
       mode    => 0644,
       owner   => 'root',
       group   => 'root'
}
file { 'tomcatlog_default':
       path => '/home/tomcatlog_default',
       ensure  => file,
       source => "puppet:///files/tranzmate/tomcatlog_default",
       mode    => 0644,
       owner   => 'root',
       group   => 'root'
}
file { 's3_remount.py':
       path => '/home/s3_remount.py',
       ensure  => file,
       source => "puppet:///files/tranzmate/s3_remount.py",
       mode    => 0777,
       owner   => 'root',
       group   => 'root'
}
file { 'passwd-s3fs':
       path => '/etc/passwd-s3fs',
       ensure  => file,
       source => "puppet:///files/tranzmate/passwd-s3fs",
       mode    => 0600,
       owner   => 'root',
       group   => 'root'
}
exec { "/home/s3_remount.py":
  path   => "/usr/bin:/usr/sbin:/bin",
  require => File['s3_remount.py']
}
}
