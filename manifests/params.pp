class integrity::params {

  case $::osfamily {
    'redhat': {

      $basedir = "/opt/integrity/server"
      $package = 'ptc-integrity-server'
      $service = 'integrity-server'
      $distro  = "el${operatingsystemmajrelease}"

      if $::operatingsystemmajrelease != 6 {
        fail("Your operatingssystem ${operatingsystem} is supported only in version 6.")
      }

    }

    default: {
      fail("Your operatingssystem ${operatingsystem} is'nt supported.")
    }

  }

}
