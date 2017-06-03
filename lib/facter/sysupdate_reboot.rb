# Fact: sysupdate_reboot
#
# Purpose: returns if system should be rebooted
#
# Resolution:
#
# Caveats:
#

Facter.add("sysupdate_reboot") do
  confine :osfamily => :debian

  setcode do
    if File.exist?('/var/run/reboot-required')
      true
    else
      false
    end
  end
end
