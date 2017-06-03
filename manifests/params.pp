class sysupdate::params {
  $enabled = true
  $on_reboot = true
  $force = false
  $schedule = 'sysupdate'
  $period = daily
  $range = '8-18'
  $timeout = 300

  case $::operatingsystem {
    'RedHat','CentOS','Scientific','OracleLinux','Fedora': {
      $packages = []
      $command = 'yum -y update --skip-broken'
      $environment = undef
    }

    'Debian': {
      $packages = $::operatingsystemmajrelease ? {
        '6'     => ['update-notifier-common'],
        '7'     => ['update-notifier-common'],
        default => []
      }

      $command = 'apt-get -qq update && apt-get -y -o Dpkg::Options::="--force-confdef" -o DPkg::Options::="--force-confold" upgrade'
      $environment = ['DEBIAN_FRONTEND=noninteractive']
    }

    'Ubuntu': {
      $packages = []
      $command = 'apt-get -qq update && apt-get -y -o Dpkg::Options::="--force-confdef" -o DPkg::Options::="--force-confold" upgrade'
      $environment = ['DEBIAN_FRONTEND=noninteractive']
    }

    'SLES','SLED': {
      $packages = []
      $command = 'zypper --non-interactive update'
      $environment = undef
    }

    default: {
      fail("Unsupported OS: ${::operatingsystem}")
    }
  }
}
