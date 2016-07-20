class integrity::params {

  case $::osfamily {
    'redhat': {

      $basedir = "/opt/integrity/server/${integrity_version}"
      $confdir = "${basedir}/config"

    }

    default: {
      fail("Your operatingssystem ${operatingsystem} is'nt supported.")
    }

  }

}
