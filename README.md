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
  enabled  => false|true,                        # enable automatic updates
  packages => array,                             # packages override
  command  => '...',                             # update command override
  period   => hourly|daily|weekly|monthly|never, # schedule period
  range    => '...',                             # schedule range
}
```

# Facts

* sysupdate\_reboot (e.g. *false*, *true* if machine should be rebooted now)
* sysupdate\_count (number of pending updates)

***

CERIT Scientific Cloud, <support@cerit-sc.cz>
