#The following class will install the Yubikey PAM module from the 
#right repository in each $operatingsystem.
#Debian and Windows are unsupported so far.
class yubikey::install (
  $pkgname,
  $managedeps,
) {
  # validate_string($pkgname)
  # validate_bool($managedeps)
  if $::kernel =='Linux' {
    if $facts['os']['family'] == 'RedHat' and $facts['os']['name'] !~ /Fedora|Amazon/ {
      if $managedeps {
        include ::epel
      }
      package { $pkgname :
        ensure  => installed,
        require => Class['epel'],
      }
    } elsif $facts['os']['family'] == 'RedHat' and $facts['os']['name'] =~ /Amazon/ {
      package { $pkgname :
        ensure => installed,
      }
    } elsif $facts['os']['family'] == 'RedHat' and $facts['os']['name'] =~ /Fedora/ {
      package { $pkgname :
        ensure => installed,
      }
    } elsif $facts['os']['family'] == 'Debian' and $facts['os']['name'] =~ /Ubuntu/ {
      if $managedeps {
        include ::apt
      }
      apt::ppa { 'ppa:yubico/stable' :}
      package { $pkgname :
        ensure  => installed,
        require => Apt::Ppa['ppa:yubico/stable'],
      }
    }
    #  else {
    #   fail ("Yubikey Install: OS ${facts['os']['name']} is not supported")
    # }
  }
  #  else {
  #   fail ("Yubikey Install: Kernel ${$::kernel} and ${facts['os']['name']} is not supported")
  # }
}
