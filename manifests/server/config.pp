class integrity::server::config inherits integrity::params {

#  if $::integrity_version == 'unknown' {
#    $integrity_version = $integrity::server::_version
#  }

#  $properties = hiera_hash(integrity::server::properties, {})

  $properties = $integrity::server::properties

  create_resources('integrity::property::file', parseyaml(inline_template(
      '<%= @properties.inject({}) {|h, (x,y)| h[x] = { "file" => x, "properties" => y}; h}.to_yaml %>')))

}
