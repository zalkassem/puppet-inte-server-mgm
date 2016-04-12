class integrity::server(
  $ensure     = running,
  $enable     = true,
  $admin_user = 'fsaadmin',
  $admin_pass = '200MKS9',
  $properties = {},
) inherits integrity::params {

  include integrity::server::install
  include integrity::server::config
  include integrity::server::service

  anchor { 'integrity::server::begin':
    notify => Class['integrity::server::service'],
  }
  -> Class['integrity::server::install']
  -> Class['integrity::server::config']
  ~> Class['integrity::server::service']
  -> anchor { 'integrity::server::end': }

}
