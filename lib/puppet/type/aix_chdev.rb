Puppet::Type.newtype(:aix_chdev) do
  @doc = %q{ A custom resource type for changing AIX device attributes.
         The resource type takes four attributes -
         device    => Name of the device to be tuned.
         attribute => The device attribute to be modified.
         value     => The new value to be set for the attribute.
         dynamic   => This attribute helps to decide if the change is dynamic or requires reboot.
                      Accepted values are 'yes', 'no', 'temporary'
                      'yes'       -> the chdev command will be run without '-P' flag
                      'no'        -> the chdev command will be run with '-P' flag
                      'temporary' -> the chdev command will be run with '-T' flag
        -----------------------------------------------------------------------------------------
        Examples:

        1) Below example will modify the mtu_bypass attribute to on for en0 temporarily, which
        means it wont change the ODM.

        aix_chdev { 'chdev':
          device    => 'en0',
          attribute => 'mtu_bypass',
          value     => 'on',
          dynamic   => 'temporary',
        }

        2) # Below example applies a set of attribute values to a list of disks given as an array

        $hdisk_array = ['hdisk1', 'hdisk2', 'hdisk3', 'hdisk4', 'hdisk5']

        $hdisk_array.each() |$hdisk| {
          aix_chdev { '$hdisk-qd-change':
            device      => '$hdisk',
            attribute   => 'queue_depth',
            value       => '64',
            dynamic     => 'no',
          }

          aix_chdev { '$hdisk-rp-change':
            device      => '$hdisk',
            attribute   => 'reserve_policy',
            value       => 'no_reserve',
            dynamic     => 'no',
          }
        }

        3) # Below example applies a set of attribute values to a list of disks given as an array
           # The set of attributes are given as a hash

        $inputs_hash = {
          attribute => 'queue_depth',
          value     => '32',
          dynamic   => 'no',
        }

        $device_array = [ 'hdisk0', 'hdisk1', 'hdisk2', 'hdisk3', 'hdisk4' ]

        $device_array.each() |$dev| {
          aix_chdev { '$dev-chdev':
            device => '$dev',
            *      => '$inputs_hash'
          }
        }
        --------------------------------------------------------------------------------------------
        Note: We dont check if the attribute supports dynamic change, its user's responsibility. }

  newparam(:device, :namevar => true) do
    desc 'name of the device to be modified'
    validate do |value|
      dev_array = %x[lsdev].split("\n").map { |line| line.split(' ')[0] }
      if dev_array.include?(value)
        value
      else
        raise ArgumentError,
        "Provided device is not present in this system."
      end
    end
    munge do |value|
      String(value)
    end
  end
  newparam(:attribute) do
    desc 'the device attribute to be modified'
    munge do |value|
      String(value)
    end
  end
  newproperty(:value) do
    desc 'the value for the attribute to be set'
    munge do |value|
      String(value)
    end
  end
  newparam(:dynamic) do
    desc 'do you want to apply the change as dynamic change'
    defaultto :no
    newvalues(:yes, :no, :temporary)
  end
end
