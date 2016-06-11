mksgroup { 'Netways':
  ensure  => present,
  members => ['lbetz','tredel','tgelf'],
} ->

mksgroup { 'Administration':
  ensure => present,
  members => ['fsaadmin'],
  #groups => ['Netways'],
  groups => [],
}
