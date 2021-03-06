class sysupdate (
  $enabled           = $sysupdate::params::enabled,
  $on_reboot         = $sysupdate::params::on_reboot,
  $force             = $sysupdate::params::force,
  $packages          = $sysupdate::params::packages,
  $command           = $sysupdate::params::command,
  $command_on_reboot = $sysupdate::params::command,
  $schedule          = $sysupdate::params::sysupdate,
  $period            = $sysupdate::params::period,
  $range             = $sysupdate::params::range,
  $timeout           = $sysupdate::params::timeout
) inherits sysupdate::params {

  validate_bool($enabled, $on_reboot, $force)
  validate_array($packages)
  validate_string($command, $command_on_reboot)

  if $enabled {
    $_ensure_cron = $on_reboot ? {
      true  => present,
      false => absent
    }

    schedule { 'sysupdate':
      period => $period,
      range  => $range,
    }

    # run update:
    # 1. if forced or
    # 2. pending updates is unknown or
    # 3. have any pending updates
    if $force or empty("${::sysupdate_count}") or ($::sysupdate_count>0) {
      if size($packages)>0 {
        package { $packages:
          ensure => present,
          before => Exec['sysupdate'],
        }
      }

      exec { 'sysupdate':
        command     => $command,
        logoutput   => true,
        path        => '/bin:/usr/bin:/sbin:/usr/sbin',
        environment => $environment,
        schedule    => $schedule,
        timeout     => $timeout,
      }
    }

  } else {
    $_ensure_cron = absent
    warning("sysupdate: Automatic system updates are disabled on ${::fqdn}!")
  }

  cron { 'sysupdate-on-reboot':
    ensure      => $_ensure_cron,
    user        => root,
    command     => $command_on_reboot,
    environment => $environment,
    special     => 'reboot',
  }
}
