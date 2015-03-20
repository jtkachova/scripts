class install_s3{
file { 'passwd-s3fs':
       path => '/etc/passwd-s3fs',
       ensure  => file,
       source => "puppet:///files/tranzmate/passwd-s3fs",
       mode    => 0600,
       owner   => 'root',
       group   => 'root'
}
$fuse = [ "build-essential", "libcurl4-openssl-dev", "libxml2-dev", "libfuse-dev", "comerr-dev", "libfuse2", "libidn11-dev", "libkrb5-dev", "libldap2-dev", "libselinux1-dev", "libsepol1-dev", "pkg-config", "fuse-utils", "sshfs", "mime-support" ]
package { $fuse: ensure => "installed" }
file { 'install_s3fs.sh':
       path => '/home/install_s3fs.sh',
       ensure  => file,
       source => "puppet:///files/tranzmate/install_s3fs.sh",
       mode    => 0777,
       owner   => 'root',
       group   => 'root'
}
exec { "/home/install_s3fs.sh":
  path   => "/usr/bin:/usr/sbin:/bin",
  require => File['passwd-s3fs']
}
}
