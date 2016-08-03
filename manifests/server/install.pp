# == private Class: integrity::server::install
#
# Full description of define integrity::server::install here.
#
#
# === Authors
#
# Author Lennart Betz <lennart.betz@netways.de>
#
class integrity::server::install inherits integrity::params {

  $version = $integrity::server::version

  package { $package:
    ensure => "${version}.${distro}",
  }

}
