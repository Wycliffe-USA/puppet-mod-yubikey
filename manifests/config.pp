#The following class loads PAM. Variables have sane defaults. 
class yubikey::config (
  $arguments=$yubikey::params::arguments,
  $service=$yubikey::params::service,
  $control=$yubikey::params::control,
  $beforemod=$yubikey::params::beforemod,
) inherits yubikey::params {
  require ::yubikey::install
  # validate_legacy($control, $yubikey::params::validcontrol)
  # validate_array($arguments)
  # validate_array($service)
  # validate_string($beforemod)
  if $::kernel =='Linux' and
  ($facts['os']['family'] == 'RedHat' or $facts['os']['family'] == 'Debian') {
    if 'debug' in $arguments {
      file { '/var/run/pam-debug.log' :
        ensure => present,
        mode   => '0777'
      }
    }
    yubikey::addauthyubico { $service :
    arguments => $arguments,
    control   => $control,
    beforemod => $beforemod,
    }

  } else {
    notice ("Yubikey Config: OS ${facts['os']['name']} is not supported")
  }
}
