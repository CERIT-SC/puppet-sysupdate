class sysupdate::params {
  $enabled = true
  $period  = daily
  $range   = '8-18'

  case $::operatingsystem {
    redhat,centos,scientific,oraclelinux,fedora: {
      $packages    = []
      $command     = 'yum -y update'
      $environment = []
    }

    debian,ubuntu: {
      $packages    = ['update-notifier-common']
      $command     = 'apt-get -qq update && apt-get -y -o Dpkg::Options::="--force-confdef" -o DPkg::Options::="--force-confold" upgrade'
      $environment = ['DEBIAN_FRONTEND=noninteractive']
    }

    sles,sled: {
      $packages    = []
      $command     = 'zypper --non-interactive update'
      $environment = []
    }

    default: {
      fail("Unsupported OS: ${::operatingsystem}")
    }
  }
}
