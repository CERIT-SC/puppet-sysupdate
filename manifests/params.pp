class sysupdate::params {
  $enabled   = true
  $on_reboot = true
  $force     = false
  $period    = daily
  $range     = '8-18'

  case $::operatingsystem {
    redhat,centos,scientific,oraclelinux,fedora: {
      $packages    = []
      $command     = 'yum -y update'
      $environment = undef
    }

    debian,ubuntu: {
      $packages    = ['update-notifier-common']
      $command     = 'apt-get -qq update && apt-get -y -o Dpkg::Options::="--force-confdef" -o DPkg::Options::="--force-confold" upgrade'
      $environment = ['DEBIAN_FRONTEND=noninteractive']
    }

    sles,sled: {
      $packages    = []
      $command     = 'zypper --non-interactive update'
      $environment = undef
    }

    default: {
      fail("Unsupported OS: ${::operatingsystem}")
    }
  }
}
