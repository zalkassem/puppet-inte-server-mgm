# == private class: integrity::params
#
# Full description of class integrity::params here.
#
# === Authors
#
# Author Lennart Betz <lennart.betz@netways.de>
#
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
