class integrity::server::install inherits integrity::params {

  package { 'ptc-integrity-server':
    ensure => installed,
  }

}
