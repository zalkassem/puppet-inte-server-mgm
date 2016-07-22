class integrity::server::install inherits integrity::params {

  $version = $integrity::server::version

  package { $package:
    ensure => "${version}.${distro}",
  }

}
