class integrity::params {

  case $::osfamily {
    'redhat': {

      $basedir = '/opt/integrity/server'

    }

    default: {
      fail("Your operatingssystem ${operatingsystem} is'nt supported.")
    }

  }

  $default_properties = {
    "${basedir}/config/properties/is.properties" => {
      'mksis.clear.port'                         => '0',
      'mksis.secure.port'                        => '0',
      'mksis.url.protocol'                       => 'http',
      'mksis.rmi.maxExecutorThreads'             => '',
      'mksis.adminStagingServer'                 => 'false',
      'mksis.adminStagingServerDisplayName'      => '',
      'mksis.startup.si'                         => 'true',
      'mksis.startup.im'                         => 'true',
      'mksis.licensePath'                        => "${basedir}/../license.dat",
      'mksis.default.compressionEnabled'         => '',
      'mksis.proxyOnly'                          => 'true',
    },
  }

}
