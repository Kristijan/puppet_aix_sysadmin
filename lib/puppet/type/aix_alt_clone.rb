Puppet::Type.newtype(:aix_alt_clone) do

  @doc = %q{ A custom resource to create alt_disk_copy in AIX.
          Available attributes for this resource type are -

        ensure          =>  Altinst_rootvg to be ensured present or absent
                            Valid values are present, absent
        disk            =>  name of the disk to be used for the altinst_rootvg
                            valid values are disk names (eg: 'hdisk1' )
                            The disk should not be in use for other VGs
        change_bootlist =>  Instructs the alt_disk_copy command to change the bootlist or no
                            Accepted values are 'yes' or 'no'
        ----------------------------------------------------------------------------------------------------
        Examples:

        1) The below example creates a rootvg clone to the disk 'hdisk2', and altering the bootlist to hdisk2

        aix_alt_clone { 'new_clone':
          ensure          =>  present,
          disk            =>  'hdisk2',
          change_bootlist =>  'yes',
        }

        2) Same as above example but without altering the bootlist to hdisk2

        aix_alt_clone { 'new_clone':
          ensure          =>  present,
          disk            =>  'hdisk2',
          change_bootlist =>  'no',
        }

        3) Removes the altinst_rootvg from the system.

        aix_alt_clone { 'remove_clone':
          ensure  =>  absent,
        }

        ----------------------------------------------------------------------------------------------------
}

  ensurable

  newparam(:disk, :namevar => true) do
    desc "Specifies the disk name to be used for the clone."
    munge do |value|
      String(value)
    end
  end

  newparam(:change_bootlist) do
    desc "Specifies whether the bootlist must be changed after alt_disk_copy operation completes."
    defaultto :no
    newvalues(:yes, :no)
  end
end
