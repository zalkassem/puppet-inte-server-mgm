define integrity::property(
  $property = $title,
  $value,
  $target,
) {

  notice("${property}=${value}, (${target})")

  file_line { "${target}_${property}":
    path  => $target,
    line  => "${property}=${value}",
    match => "^#*\s*${property}\s*=",
  }

  #concat::fragment { "${target}_${property}":
  #  target  => $target,
  #  content => "${property}=${value}\n",
  #  order   => '10',
  #}

}

define integrity::property::file(
  $file       = $title,
  $properties = {},
) {

  #concat { $file:
  #  ensure => present,
  #}

  create_resources('integrity::property', parseyaml(inline_template(
      '<%= @properties.inject({}) {|h, (x,y)| h[x] = { "property" => x, "value" => y}; h}.to_yaml %>')), {'target' => $file})
}
