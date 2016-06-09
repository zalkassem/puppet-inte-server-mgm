define integrity::mksdomainuser(
  $ensure = 'present',
) {
  exec { "mksdomainuser-$name":
    path    => '/opt/integrity/client/bin:/usr/bin:/bin',
    command => "integrity connect --hostname=localhost --port=7001 --user=fsaadmin --password=200MKS9",
  }
}
