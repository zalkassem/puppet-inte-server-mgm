# == class: integrity::server
#
# Full description of define integrity::server here.
#
# === Parameters
#
# Document parameters here.
#
# [*ensure*]
#   running (default) or stopped
#
# [*enable*]
#   Enables (true, default) or disables (false) the service to start at boot.
#
# [*properties*]
#   Hash of hashes for properties
#
# [*version*]
#   Version of the integrity server to use, i.e. 10.6-1
#
#
# Note: Config changes do'nt trigger a service refresh!
#
# Examples:
#
#   class { 'integrity::server':
#     version               => '10.6-1',
#     properties            => {
#       'is.properties'     => {
#         'mksis.proxyOnly' => true,
#         'mksis.proxyList' => [ 'ims-SMS-7001', 'ims-SMS-7002' ],
#         ...
#       },
#       'im.properties' => {
#         ...
#       },
#       ...
#     }
#   }
#
#
# === Authors
#
# Author Lennart Betz <lennart.betz@netways.de>
#
class integrity::server(
  $ensure     = running,
  $enable     = true,
  $properties = {},
  $version,
) inherits integrity::params {

  validate_re($ensure, '^(running|stopped)$', 'ensure must be running or stopped')
  validate_bool($enable)
  validate_re($version, '^[0-9]+\.[0-9]+\-[0-9]+$', 'version has to be a form of a.b-n')

  # Helper variable for the path, i.e. /opt/integrity/server/10.6/bin
  $_version = regsubst($version, '^(.*)-[0-9]+$', '\1')

  # Downgrades do not work.
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
