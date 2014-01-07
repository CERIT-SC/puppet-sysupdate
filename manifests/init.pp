class sysupdate (
  $enabled   = $sysupdate::params::enabled,
  $on_reboot = $sysupdate::params::on_reboot,
  $packages  = $sysupdate::params::packages,
  $command   = $sysupdate::params::command,
  $period    = $sysupdate::params::period,
  $range     = $sysupdate::params::range,
) inherits sysupdate::params {

  validate_bool($enabled, $on_reboot)
  validate_array($packages, $environment)
  validate_string($command)

  Exec {
    logoutput => true,
    path      => '/bin:/usr/bin:/sbin:/usr/sbin'
  }

  if $enabled {
    $_ensure_cron = $on_reboot ? {
      true  => present,
      false => absent
    }

    schedule { 'sysupdate':
      period => $period,
      range  => $range,
    }

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
    $_ensure_cron = absent
    warning("sysupdate: Automatic system updates are disabled on ${::fqdn}!")
  }

  cron { 'sysupdate-on-reboot':
    ensure      => $_ensure_cron,
    user        => root,
    command     => $command,
    environment => $environment,
    special     => 'reboot',
  }
}
