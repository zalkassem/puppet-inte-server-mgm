class integrity::server::service inherits integrity::params {

  $ensure = $integrity::server::ensure
  $enable = $integrity::server::enable

  service { $service:
    ensure     => $ensure,
    enable     => $enable,
    hasrestart => true,
  }

}
