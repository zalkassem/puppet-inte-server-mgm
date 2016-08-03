define integrity::property(
  $property = $title,
  $value,
  $target,
) {

  include integrity::params

  $confdir = "${integrity::params::basedir}/${integrity::server::_version}/config/properties"

  if $value != 'absent' {
    file_line { "${target}_${property}":
      path    => "${confdir}/${target}",
      line    => "${property}=${value}",
      replace => true,
      match   => "^#*${property}\s*=",
    }
  } else {
    file_line { "${target}_${property}":
      path    => "${confdir}/${target}",
      line    => "#${property}=",
      replace => true,
      match   => "^${property}\s*=",
    }
  }

}


define integrity::property::file(
  $file       = $title,
  $properties = {},
) {

  create_resources('integrity::property', parseyaml(inline_template(
      '<%= @properties.inject({}) {|h, (x,y)| h[x] = { "property" => x, "value" => y}; h}.to_yaml %>')), {'target' => $file})
}
