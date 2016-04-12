class integrity::server::service inherits integrity::params {

  $ensure = $integrity::server::ensure
  $enable = $integrity::server::enable

  service { 'integrity-server':
    ensure     => $ensure,
    enable     => $enable,
    hasrestart => true,
  }

}
