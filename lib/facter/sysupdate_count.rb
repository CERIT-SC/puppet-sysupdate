# Fact: sysupdate_count
#
# Purpose: return number of packages with updates
#
# Resolution:
#   Supported platforms/package managers:
#     * RedHat:    yum
#     * Debian:    apt-get
#     * SLES/SLED: zypper
#
# Caveats:
#

Facter.add("sysupdate_count", :timeout => 30) do
  confine :osfamily => :redhat 
  setcode do
    count = nil
    output = Facter::Util::Resolution.exec('yum -q check-update')
    if not output.nil?
      count = 0
      output.each_line { |line|
        break if line =~ /^Obsolet/i
        count+=1 if line =~ /^\w/
      }
    end
    count
  end
end

Facter.add("sysupdate_count", :timeout => 30) do
  confine :osfamily => :debian

  setcode do
    count = nil
    if output = Facter::Util::Resolution.exec('apt-get -s upgrade')
      if output =~ /^(\d+) upgraded,/
        count = $1
      end
    end     
    count
  end 
end

Facter.add("sysupdate_count", :timeout => 120) do
  confine :osfamily => :suse

  setcode do
    count = nil
    output = Facter::Util::Resolution.exec('zypper --xmlout --quiet list-updates')
    if not output.nil?
      xml = REXML::Document.new(output)
      count = 0
      xml.elements.each('update-list/update') do |e|
        count +=1 if e.attribute('kind') == 'package'
      end
    end     
    count
  end 
end
