class sysupdate (
  $enabled  = $sysupdate::params::enabled,
  $packages = $sysupdate::params::packages,
  $command  = $sysupdate::params::command,
  $period   = $sysupdate::params::period,
  $range    = $sysupdate::params::range
) inherits sysupdate::params {

  validate_bool($enabled)
  validate_array($packages, $environment)
  validate_string($command)

  Exec {
    logoutput => true,
    path      => '/bin:/usr/bin:/sbin:/usr/sbin'
  }

  # schedules
  schedule { 'sysupdate':
    period => $period,
    range  => $range,
  }

  if $enabled {
    if size($packages)>0 {
      package { $packages:
        ensure => present,
        before => Exec['sysupdate'],
      }
    }

    exec { 'sysupdate':
      command     => $command,
      environment => $environment,
      schedule    => 'sysupdate',
    }

  } else {
    warning("sysupdate: Automatic system updates are disabled on ${::fqdn}!")
  }
}
