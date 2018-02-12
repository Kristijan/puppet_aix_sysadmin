Puppet::Type.newtype(:aix_mkvg) do
  @doc = %q{ A custom resource type to create Volume Groups in AIX.
         Available attributes for this resource type are -

            ensure    =>  Volume Group to be ensured present or absent
                          Accepted values are present, absent
            name      =>  Name of the Volume Group to be created
                          Accepted values are any string
            type      =>  type of the Volume Group to be used
                          Accepted values are 'normal', 'big', 'scalable'
                          Defaults to 'normal'
            pp_size   =>  physical partition size for the new VG to be created
                          Accepted values are any Integer
            auto_on   =>  defines whether the VG has to be auto varied on during boot
                          Accepted values are 'yes' or 'no'
                          Defaults to 'yes'
            force     =>  Force creation of the Volume Group
                          Accepted values are 'yes' or 'no'
            disks     =>  an array specifying the disk(s) to be used in the VG
                          Accepted value is an array of disk names

        ----------------------------------------------------------------------------------------------------
        Examples:

        1) Below example creates a scalable volume group named 'appvg' with PP size of 128MB,
           using two hdisks - hdisk1, hdisk2. Sets the VG to auto vary-on at boot time.

        aix_mkvg { 'aix_mkvg':
          ensure      => present,
          name        => 'appvg',
          type        => 'normal',
          disks       => ['hdisk1', 'hdisk2'],
          pp_size     => '128',
          auto_on     => 'yes'
        }

        2) Below example creates a scalable volume group named 'db2vg' with PP size of 256MB,
           using four hdisks - hdisk4, hdisk5, hdisk6, hdisk7. Sets the VG not to auto vary-on at boot time.

        aix_mkvg { 'aix_mkvg':
          ensure      => present,
          name        => 'db2vg',
          type        => 'scalable',
          disks       => ['hdisk4', 'hdisk5', 'hdisk6', 'hdisk7'],
          pp_size     => '256',
          auto_on     => 'no'
        }

        ----------------------------------------------------------------------------------------------------
  }

  ensurable

  newparam(:name, :namevar => true) do
    desc 'Name of the new VG to be created.'
    munge do |value|
      String(value)
    end
  end

  newparam(:type) do
    desc 'Type of the VG to be used.'
    newvalues(:normal, :scalable, :big)
    defaultto :normal
    munge do |value|
      String(value)
    end
  end

  newparam(:pp_size) do
    desc 'The PP size for the new VG.'
    munge do |value|
      Integer(value)
    end
  end

  newparam(:auto_on) do
    desc 'To define if the VG must auto vary-on at boot time.'
    newvalues(:yes, :no)
    defaultto :yes
    munge do |value|
      String(value)
    end
  end

  newparam(:force) do
    desc 'Force the creation of the Volume Group'
    newvalues(:yes, :no)
    munge do |value|
      String(value)
    end
  end

  newparam(:disks, :array_matching => :all) do
    desc 'The disks to be used in the VG, must provide an array containing the disk(s).'
    munge do |value|
      Array(value)
    end
  end
end
