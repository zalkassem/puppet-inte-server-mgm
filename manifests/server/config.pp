class integrity::server::config inherits integrity::params {

  $properties = $integrity::server::properties

  create_resources('integrity::property::file', parseyaml(inline_template(
      '<%= @properties.inject({}) {|h, (x,y)| h[x] = { "file" => x, "properties" => y}; h}.to_yaml %>')))

}
