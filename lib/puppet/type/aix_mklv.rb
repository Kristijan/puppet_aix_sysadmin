Puppet::Type.newtype(:aix_mklv) do
  @doc = %q{ A custom resource type to create Logical Volumes in AIX.
            The available attributes for the resource type are -

          ensure        =>    Logical Volume to be ensured present or absent in the system
                              Accepted values are present, absent

          name          =>    Name for the new logical volume to be created
                              Accepted values are String values for the name

          type          =>    Specifies the type of LV to be created
                              Accepted values are normal, striped, mirrored, striped_mirrored

          fstype        =>    Type of the Logical volume to be used for creation
                              Accepted values are 'jfs', 'jfs2', 'jfslog', 'jfs2log', 'paging', 'sysdump'

          copies        =>    The number of copies if it is a mirrored logical volume
                              Accepted values are 1, 2, 3
                              Defaults to 1 (no mirror)

          strip_size    =>    Defines the strip size for striped LVs.
                              Accepted values are 4K, 8K, 16K, 32K, 64K, 128K, 256K, 512K, 1M, 2M, 4M, 8M, 16M, 32M, 64M, 128M

          max_num_disks =>    Maxinum number of disks the LV should span across

          num_of_pps    =>    Defines the number of PPs to be used for the new LV
                              Accepted values are any Integer

          vg_name       =>    Name of the Volume group in which the new LV should be created
                              The VG must be present in the system

          disks         =>    If a set of specific disks to be used, provide the disk names in an array
                              Defaults to []
        ----------------------------------------------------------------------------------------------------
        Examples:

        1) Below example will create a new Logical Volume named 'applv', in the Volume Group 'appvg'.
           The type of the LV is jfs2, and the LV will be created with 8 PPs, with no mirroring.

        aix_mklv { 'aix_mklv':
          ensure      => present,
          name        => 'applv',
          type        => 'jfs2',
          vgname      => 'appvg',
          copies      => '1',
          num_of_pps  => '8',
        }

        2) Below example will create a new Logical Volume named 'db2lv', in the Volume Group 'db2vg'.
           The type of the LV is jfs2, and the LV will be created with 80 PPs, with no mirroring.

        aix_mklv { 'aix_mklv':
          ensure      => present,
          name        => 'db2lv',
          type        => 'jfs2',
          vgname      => 'db2vg',
          copies      => '1',
          num_of_pps  => '80',
        }
        ----------------------------------------------------------------------------------------------------
  }

  ensurable

  newparam(:name, :namevar => true) do
    desc 'Name of the new LV to be created.'
    munge do |value|
      String(value)
    end
  end

  newparam(:type) do
    newvalues(:normal, :striped, :mirrored, :striped_mirrored)
    munge do |value|
      String(value)
    end
  end

  newparam(:fstype) do
    desc 'Defines the type of LV for the new LV to be created.'
    newvalues(:jfs, :jfslog, :jfs2, :jfs2log, :paging, :sysdump)
    munge do |value|
      String(value)
    end
  end

  newparam(:copies) do
    desc 'Defines the number of mirror copies to be created for the new LV.'
    defaultto 1
    validate do |value|
      if value.to_i > 0 && value.to_i < 4
        value
      else
        raise ArgumentError,
        "The number of copies must be between 1 to 3."
      end
    end
    munge do |value|
      Integer(value)
    end
  end

  newparam(:strip_size) do
    desc 'Defines the strip size for striped LVs.'
    newvalues(:'4K', :'8K', :'16K', :'32K', :'64K', :'128K', :'256K', :'512K', :'1M', :'2M', :'4M', :'8M', :'16M', :'32M', :'64M', :'128M')
    munge do |value|
      String(value)
    end

  end

  newparam(:max_num_disks) do
    desc 'Maxinum number of disks the LV should span across'
    munge do |value|
      Integer(value)
    end
  end

  newparam(:num_of_pps) do
    desc 'Defines the number of PPs to be used for the LV.'
    munge do |value|
      Integer(value)
    end
  end

  newparam(:vgname) do
    desc 'Defines the Volume Group in which to create the new LV.'
    munge do |value|
      String(value)
    end
  end

  newparam(:disks, :array_matching => :all) do
    desc 'Defines the disk(s) to be used for the new LV in an array format.'
    defaultto []
    munge do |value|
      Array(value)
    end
  end
end
