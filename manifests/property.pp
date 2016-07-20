define integrity::property(
  $property = $title,
  $value,
  $target,
) {

  include integrity::params

  $confdir = $integrity::params::confdir

  file_line { "${target}_${property}":
    path    => "${confdir}/properties/${target}",
    line    => "${property}=${value}",
    replace => true
    match   => "^#*${property}\s*=",
  }

}

define integrity::property::file(
  $file       = $title,
  $properties = {},
) {

  create_resources('integrity::property', parseyaml(inline_template(
      '<%= @properties.inject({}) {|h, (x,y)| h[x] = { "property" => x, "value" => y}; h}.to_yaml %>')), {'target' => $file})
}
