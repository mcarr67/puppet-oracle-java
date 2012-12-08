class oracle-java {
  $arch = $architecture ? {
    'amd64' => 'x64',
    default => 'i586',
  }
  $package_name = "${java_distrib}-${java_version}-linux-${arch}.tar.gz"
  file { "${java_base_dir}/java":
    ensure => directory,
  }
  file { "${java_base_dir}/java/${package_name}":
    ensure  => present,
    source  => "puppet:///modules/oracle-java/${package_name}",
    require => File["${java_base_dir}/java"],
    notify  => Exec['unpack-java'],
  }
  exec { 'unpack-java':
    command     => "tar zxf ${package_name}",
    cwd         => "${java_base_dir}/java/",
    path        => '/bin',
    refreshonly => true,
    notify      => Exec['rename-java-dir'],
  }
  exec { 'rename-java-dir':
    command     => "mv jre1.* ${java_version}",
    cwd         => "${java_base_dir}/java/",
    path        => '/bin',
    refreshonly => true,
  }
}
