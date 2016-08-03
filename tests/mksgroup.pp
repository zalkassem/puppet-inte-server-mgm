mksgroup { 'Administration':
  ensure => present,
  members => ['fsaadmin'],
  groups => ['NETWAYS'],
}

mksgroup { 'NETWAYS':
  ensure  => present,
  members => ['lbetz', 'tredel', 'twidhalm'],
}

