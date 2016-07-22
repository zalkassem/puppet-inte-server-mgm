mksgroup { 'Administration':
  ensure => present,
  members => ['fsaadmin'],
  groups => ['Netways'],
}

mksgroup { 'Netways':
  ensure  => present,
  members => ['lbetz', 'tredel', 'tgelf'],
}

