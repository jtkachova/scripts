class install_app{
$web = [ "ruby", "rubygems", "ImageMagick", "git" "expect" ]
package { $web: ensure => "installed" }
exec {"update_gem":
        path   => "/usr/bin:/usr/sbin:/bin",
        command => "gem update --system; ",
        subscribe => Package[$web]
}
exec {"install_rvm":
     path   => "/usr/bin:/usr/sbin:/bin",
     command => "curl -L https://get.rvm.io | bash -s stable --ruby; /usr/local/rvm/scripts/rvm reload; gem install puppet",
     #require => Exec["update_gem"],
     subscribe => Exec["update_gem"]
}
file { 'id_rsa':
       path => '/root/.ssh/id_rsa',
       ensure  => file,
       source => "puppet:///files/id_rsa",
       mode    => 0600,
       owner   => 'root',
       group   => 'root',
       subscribe => Exec["install_rvm"],
       replace => false
}
file { 'id_rsa.pub':
       path => '/root/.ssh/id_rsa.pub',
       ensure  => file,
       source => "puppet:///files/id_rsa.pub",
       mode    => 0644,
       owner   => 'root',
       group   => 'root',
       subscribe => File['id_rsa'],
       replace => false
       
}
file { 'login.sh':
       path => '/home/login.sh',
       ensure  => file,
       source => "puppet:///files/login.sh",
       mode    => 0777,
       owner   => 'root',
       group   => 'root',
       subscribe => File['id_rsa.pub'],
       replace => false
}
exec { "/home/login.sh":
  path   => "/usr/bin:/usr/sbin:/bin",
  onlyif => "-N /home/login.sh"
  #subscribe => File['login.sh']
}
exec {"install_gems":
       path   => "/usr/bin:/usr/sbin:/bin",
       command => "cd /opt/app/mega-store; /usr/local/rvm/gems/ruby-2.1.1/wrappers/bundle install",
       onlyif => "-N /home/login.sh"
       #subscribe => Exec["/home/login.sh"]
}

file { 'auth.yml':
    path => '/opt/app/mega-store/config/auth.yml',
    ensure  => file,
    source => "puppet:///files/plugins/auth.yml",
    mode    => 0777,
    owner   => 'root',
    group   => 'root',
    require => Exec["install_gems"],
    replace => true
}
file { 'config.yml':
    path => '/opt/app/mega-store/config/config.yml',
    ensure  => file,
    source => "puppet:///files/plugins/config.yml",
    mode    => 0777,
    owner   => 'root',
    group   => 'root',
    require => File['auth.yml'],
    replace => true
}
exec {"run_app":
       path   => "/usr/bin:/usr/sbin:/bin",
       command => "cd opt/app/mega-store; unicorn_rails",
       require => File['config.yml']
}
}

