# Puppet sysupdate module

This module provides mechanism for automatic system updates
initiated by Puppet.

### Requirements

Module has been tested on:

* Puppet 3.4
* Debian and Red Hat family systems

Required modules:

* stdlib (https://github.com/puppetlabs/puppetlabs-stdlib)

# Quick Start

Enable system updates

```puppet
include sysupdate
```

Full configuration options:

```puppet
class { 'sysupdate':
  enabled           => false|true,                        # enable automatic updates
  on_reboot         => false|true,                        # enable updates on reboot
  force             => false|true,                        # force run update regularly
  packages          => array,                             # packages override
  command           => '...',                             # update command override
  command_on_reboot => '...',                             # update command on reboot
  schedule          => 'sysupdate',                       # override exec's schedule name
  period            => hourly|daily|weekly|monthly|never, # schedule period
  range             => '...',                             # schedule range
  timeout           => 300,                               # update command timeout
}
```

# Facts

* sysupdate\_reboot (e.g. *false*, *true* if machine should be rebooted now)
* sysupdate\_count (number of pending updates)

***

CERIT Scientific Cloud, <support@cerit-sc.cz>
