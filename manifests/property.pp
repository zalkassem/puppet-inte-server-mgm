# == private Define Resource: integrity::property
#
# Full description of define integrity::property here.
#
# [*property*]
#   Property to handle, default is the title of the define resource.
#
# [*value*]
#   Value to assign to the property. Use absent as value to remove the property.
#
# [*target*]
#   Target property file, has to be in /opt/integrity/server/<version>/config/properties.
#
#
# === Authors
#
# Author Lennart Betz <lennart.betz@netways.de>
#
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

# == private Define Resource: integrity::property::file
#
# Full description of define integrity::property::file here.
#
# [*file*]
#   The target file, default to the title.
#
# [*properties*]
#   Hash of properties for this target.
#
#
# === Authors
#
# Author Lennart Betz <lennart.betz@netways.de>
#
define integrity::property::file(
  $file       = $title,
  $properties = {},
) {

  create_resources('integrity::property', parseyaml(inline_template(
      '<%= @properties.inject({}) {|h, (x,y)| h[x] = { "property" => x, "value" => y}; h}.to_yaml %>')), {'target' => $file})
}
