class sysupdate::params {
  $enabled = true
  $on_reboot = true
  $force = false
  $schedule = 'sysupdate'
  $period = daily
  $range = '8-18'
  $timeout = 300

  case $::operatingsystem {
    redhat,centos,scientific,oraclelinux,fedora: {
      $packages = []
      $command = 'yum -y update'
      $environment = undef
    }

    debian: {
      case $::operatingsystemmajrelease {
        6,7:      { $packages = ['update-notifier-common'] }
        default:  { $packages = [] }
      }

      $command = 'apt-get -qq update && apt-get -y -o Dpkg::Options::="--force-confdef" -o DPkg::Options::="--force-confold" upgrade'
      $environment = ['DEBIAN_FRONTEND=noninteractive']
    }

    ubuntu: {
      $packages = []
      $command = 'apt-get -qq update && apt-get -y -o Dpkg::Options::="--force-confdef" -o DPkg::Options::="--force-confold" upgrade'
      $environment = ['DEBIAN_FRONTEND=noninteractive']
    }

    sles,sled: {
      $packages = []
      $command = 'zypper --non-interactive update'
      $environment = undef
    }

    default: {
      fail("Unsupported OS: ${::operatingsystem}")
    }
  }
}
