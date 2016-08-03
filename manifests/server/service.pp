# == private Class: integrity::server::service
#
# Full description of class integrity::server::service here.
#
#
# === Authors
#
# Author Lennart Betz <lennart.betz@netways.de>
#
class integrity::server::service inherits integrity::params {

  $ensure = $integrity::server::ensure
  $enable = $integrity::server::enable

  service { $service:
    ensure     => $ensure,
    enable     => $enable,
    hasrestart => true,
    hasstatus  => false,
    pattern    => '-Dwrapper.native_library=mksservice'
  }

}
