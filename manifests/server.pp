class integrity::server(
  $ensure     = running,
  $enable     = true,
  $properties = {},
  $version,
) inherits integrity::params {

  validate_re($ensure, '^(running|stopped)$', 'ensure must be running or stopped')
  validate_bool($enable)
  validate_re($version, '^[0-9]+\.[0-9]+\-[0-9]+$', 'version has to be a form of a.b-n') 

  $_version = regsubst($version, '^(.*)-[0-9]+$', '\1')

  if $::integrity_version != 'unknown' and versioncmp($::integrity_version, $_version) > 0 {
    fail("downgrade to ${_version} is not allowed")
  }

  include integrity::server::install
  include integrity::server::config
  include integrity::server::service

  anchor { 'integrity::server::begin':
    notify => Class['integrity::server::service'],
  }
  -> Class['integrity::server::install']
  -> Class['integrity::server::config']
  -> Class['integrity::server::service']
  -> anchor { 'integrity::server::end': }

}
