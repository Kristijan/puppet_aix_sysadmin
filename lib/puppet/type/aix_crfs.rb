Puppet::Type.newtype(:aix_crfs) do
  @doc = %q{ A custom resource type to create Filesystems in AIX.
         Available attributes for this resource type are -

          ensure       =>     To define to ensure the Filesystem to be present or absent in the system
                              Accepted values are present, absent
          type         =>     Defines the type of the Filesystem to be created
                              Accepted values are 'jfs', 'jfs2'
                              Defaults to 'jfs2'
          device       =>     Defines whether the Filesystem should use an existing LV or create a new LV
                              Accepted values are 'lv_device', or 'vg_name'
                              Use either one of the values only for each filesystem
                              lv_device means the filesystem should use an existing LV
                              vg_name means the filesystem will be created on a system created LV
          lv_device     =>    Name of the existing LV device to be used for the new Filesystem
                              The LV device should already be existing
          vg_name       =>    Name of the Volume Group to be used in which the new LV to be created
                              The VG must already be existing
          mount_point   =>    The directory to be used as the mount point for the new filesystem
          auto_mount    =>    Defines whether the filesystem should be auto mounted during the boot
                              Accepted values are 'yes', 'no'
                              Defaults to 'yes'
          size          =>    Defines the size for the Filesystem to be created
                              This attribute is valid only when the 'device' attribute is defined with 'lv_device'
                              Accepted values are strings, examples - '10G', '100M', '100G'
          agblksize     =>    The Filesystem block size to be used for the new filesystem
                              Accepted values are integers - 512, 1024, 2048, 4096
                              Defaults to '4096'
          logname       =>    The log device to be used for the new filesystem
                              Accepted values are 'INLINE', or 'log_device_name'
                              If set to 'INLINE' - the filesystem is set to INLINE logging
                              If set to a log device name - filesystem will be set to that device for logging
                              Defaults to 'INLINE'
          options       =>    Filesystem mount options can be specified as an array

          ---------------------------------------------------------------------------------------------------------------------
          Examples:


          1) The below example will create a new jfs2 filesystem. A new LV will be created in 'appvg' with 2GB as
             size. The filesystem will be mounted on a directory '/appfs1', and be set for auto_mount during boot.

          aix_crfs { 'aix_crfs':
            ensure        =>  present,
            type          =>  'jfs2',
            device        =>  'vg_name',
            vg_name       =>  'appvg',
            mount_point   =>  '/appfs1',
            auto_mount    =>  'yes',
            size          =>  '2G',
          }

          2) The below example will create a new jfs2 filesystem on an exisitng LV 'db2lv'. The filesystem will be mounted
          on the directory '/db2data', and be set to not auto_mount during boot. The mount options cio and rbr will be applied.

          aix_crfs { 'aix_crfs':
            ensure        =>  present,
            type          =>  'jfs2',
            device        =>  'lv_device',
            lv_device     =>  '/dev/db2lv',
            mount_point   =>  '/db2data',
            auto_mount    =>  'no',
            options       =>  ['cio', 'rbr']
          }
          ---------------------------------------------------------------------------------------------------------------------
  }

  ensurable

  newparam(:type) do
    desc 'Defines the filesystem type for the new filesystem.'
    newvalues(:jfs, :jfs2)
    defaultto :jfs2
    munge do |value|
      String(value)
    end
  end

  newparam(:device) do
    desc 'Defines the device to be used for the new filesystem.'
    newvalues(:lv_device, :vg_name)
    munge do |value|
      String(value)
    end
  end

  newparam(:lv_device) do
    desc 'Name of the LV device to be used.'
    munge do |value|
      String(value)
    end
  end

  newparam(:vg_name) do
    desc 'Name of the VG in which the new LV to be created for the filesystem.'
    munge do |value|
      String(value)
    end
  end

  newparam(:mount_point, :namevar => true) do
    desc 'Defines the mount point to be used for the filesystem.'
    munge do |value|
      String(value)
    end
  end

  newparam(:auto_mount) do
    desc 'Defines whether the filesystem should be set to auto mount at boot.'
    defaultto :yes
    newvalues(:yes, :no)
    munge do |value|
      String(value)
    end
  end

  newparam(:size) do
    desc 'Defines the size for the new filesystem.'
    munge do |value|
      String(value)
    end
  end

  newparam(:agblksize) do
    desc 'Defines the filesystem block size.'
    defaultto 4096
    munge do |value|
      Integer(value)
    end
  end

  newparam(:logname) do
    desc 'Defines the log device name for the new filesystem.'
    defaultto :INLINE
    munge do |value|
      String(value)
    end
  end

  newparam(:options, :array_matching => :all) do
    desc 'Defines the filesystem mount options as an array.'
    defaultto []
    munge do |value|
      Array(value)
    end
  end
end
