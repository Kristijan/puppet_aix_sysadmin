This module consists of custom resource types to perform AIX system administration using puppet.
It provides the below documented resource types.

Available Resource Types:
1) aix_tunables
2) aix_chdev
3) aix_mkvg
4) aix_mklv
5) aix_crfs
6) aix_alt_clone
7) aix_niminit
8) aix_nimclient
9) aix_nim




1) aix_tunables

A custom resource type to modify values for attributes in AIX tunables.

       Attributes:

       tunable   => Name of the tunable to be modified.
                    Valid values are - 'schedo', 'vmo', 'ioo', 'lvmo', 'no', 'nfso'
       attribute => Name of the tunable attribute to be modified.
                    Valid values are the tunable attribute names, that are not 'Restricted Tunables'.
       value     => The new value to be assigned to the tunable attribute.
                    Valid values are accepted values for the tunable.
       permanent => Decides whether the change is to only the current kernel or a permanent change.
                    Accepts either 'yes' or 'no'.
                    If set to 'no', the tunable must be of dynamic type.

       Examples:

       1) The below example will change the 'vpm_xvcpus' attribute value to '1' and will make it a temporary setting.

       aix_tunables { 'xvcpus':
         tunable => 'schedo',
         attribute => 'vpm_xvcpus',
         value => '1',
         permanent => 'no',
       }

       2) Below is an example of using a hash to apply changes to multiple vmo attributes, making them permanent.

       $vmo_hash = {
         'minperm%' => '10',
         'maxpin%'  => '80',
       }

       $vmo_hash.each() |$attr, $val| {
         aix_tunables { "vmo-$attr-change":
           tunable   => 'vmo',
           attribute => "$attr",
           value     => "$val",
           permanent => 'yes',
         }
       }

       Note: The resource type doesn't support modifying 'Restricted Tunables' in AIX.

-----------------------------------------------------------------------------------------------------------------------------

2) aix_chdev

A custom resource type for changing AIX device attributes.

       Attributes:

       The resource type takes four attributes -
       device    => Name of the device to be tuned.
       attribute => The device attribute to be modified.
       value     => The new value to be set for the attribute.
       dynamic   => This attribute helps to decide if the change is dynamic or requires reboot.
                    Accepted values are 'yes', 'no', 'temporary'
                    'yes'       -> the chdev command will be run without '-P' flag
                    'no'        -> the chdev command will be run with '-P' flag
                    'temporary' -> the chdev command will be run with '-T' flag

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

       Note: We don't check if the attribute supports dynamic change, its user's responsibility.

-----------------------------------------------------------------------------------------------------------------------------

3) aix_mkvg

A custom resource type to create Volume Groups in AIX.

          Attributes:

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

-----------------------------------------------------------------------------------------------------------------------------

4) aix_mklv

A custom resource type to create Logical Volumes in AIX.

        Attributes:

        ensure      =>    Logical Volume to be ensured present or absent in the system
                          Accepted values are present, absent
        name        =>    Name for the new logical volume to be created
                          Accepted values are String values for the name
        type          =>  Specifies the type of LV to be created
                          Accepted values are normal, striped, mirrored, striped_mirrored
        fstype        =>  Filesystem Type of the Logical volume to be used for creation
                          Accepted values are 'jfs', 'jfs2', 'jfslog', 'jfs2log', 'paging', 'sysdump'
        copies      =>    The number of copies if it is a mirrored logical volume
                          Accepted values are 1, 2, 3
                          Defaults to 1 (no mirror)
        strip_size    =>  Defines the strip size for striped LVs.
                          Accepted values are 4K, 8K, 16K, 32K, 64K, 128K, 256K, 512K, 1M, 2M, 4M, 8M, 16M, 32M, 64M, 128M

        max_num_disks =>   Maximum number of disks the LV should span across
        num_of_pps  =>    Defines the number of PPs to be used for the new LV
                          Accepted values are any Integer
        vg_name     =>    Name of the Volume group in which the new LV should be created
                          The VG must be present in the system
        disks       =>    If a set of specific disks to be used, provide the disk names in an array
                          Defaults to []

       Examples:

       1) Below example will create a new Logical Volume named 'applv', in the Volume Group 'appvg'.
          The type of the LV is jfs2, and the LV will be created with 8 PPs, with no mirroring.

       aix_mklv { 'aix_mklv':
         ensure      => present,
         name        => 'applv',
         type        => 'normal'
         fstype      => 'jfs2',
         vgname      => 'appvg',
         copies      => '1',
         num_of_pps  => '8',
       }

       2) Below example will create a new Logical Volume named 'db2lv', in the Volume Group 'db2vg'.
          The type of the LV is jfs2, and the LV will be created with 80 PPs, with no mirroring.

       aix_mklv { 'aix_mklv':
         ensure      => present,
         name        => 'db2lv',
         type        => 'normal'
         fstype      => 'jfs2',
         vgname      => 'db2vg',
         copies      => '1',
         num_of_pps  => '80',
       }
-----------------------------------------------------------------------------------------------------------------------------

5) aix_crfs

A custom resource type to create Filesystems in AIX.

       Attributes:

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
-----------------------------------------------------------------------------------------------------------------------------

6) aix_alt_clone

A custom resource to create alt_disk_copy in AIX.

Available attributes for this resource type are -

      ensure          =>  Altinst_rootvg to be ensured present or absent
                          Valid values are present, absent
      disk            =>  name of the disk to be used for the altinst_rootvg
                          valid values are disk names (eg: 'hdisk1' )
                          The disk should not be in use for other VGs
      change_bootlist =>  Instructs the alt_disk_copy command to change the bootlist or no
                          Accepted values are 'yes' or 'no'

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

-----------------------------------------------------------------------------------------------------------------------------

7) aix_niminit

A custom resource to define an AIX system as a NIM client.

Accepted valid for this resource type are -

       ensure         =>    Ensures the AIX node be configured as a nim client.
                            Accepted values are present, absent
                            if absent - the '/etc/niminfo' file will be removed from the client node.

       client_name    =>    Name for the client to be used. Usually its the short hostname

       nim_master     =>    Hostname of the NIM master to be used in the configuration

       pif_name       =>    Interface name to be used to communicate with the NIM server

       cable_type     =>    Cable type to be used for the connection
                            Valid values are 'bnc', 'dix', 'NA'

      Examples:

      1) The below example will create the NIM client with hostname 'lpar10', in NIM Master 'prodnim',
         uses en0 interface, with cable_type as 'bnc'.

      aix_niminit { 'niminit':
        ensure      => present,
        client_name => 'lpar10',
        pif_name    => 'en0',
        cable_type  => 'bnc',
        nim_master  => 'prodnim',
      }

-----------------------------------------------------------------------------------------------------------------------------

8) aix_nimclient

A custom resource to perform AIX patching.

Available attributes are -

        fixes         =>    Name of the fixes to be installed.
                            'update_all' for all the fixes contained in the lpp_source to be installed

        desired_level =>    Desired OS level to be installed.
                            Valid format is 7100-04-04
                            This expects the lpp_source to be named '7100-04-04_lppsrc'


        Examples:

        1) The below example will update the system to OSLEVEL '7100-04-04'
           This will search for lpp_source resource with name '7100-04-04_lppsrc' in the nim server.

        aix_nimclient { 'update':
          fixes         => 'update_all',
          desired_level => '7100-04-04',
        }

-----------------------------------------------------------------------------------------------------------------------------
9) aix_nim

A custom resource type for managing NIM server.

The following attributes are available with this resource type -

     ensure       =>  Ensures the item is present or absent
                      Valid values are present or absent
                      Though the absent doesnt really do anything for some 'action's
                       example: it doesnt do anything if it is set to absent for suma action
     action       =>  Defines the action to be performed
                      Valid values are: 'define', 'allocate', 'cust', 'suma', 'maint_boot', 'updateios'
     name         =>  Name of the resource to be action performed
     type         =>  Type of the resource to be defined
                      This is required for the define action only
     attributes   =>  The attributes that are to be used based on what action is being performed.

  aix_nim { 'define-lpar11':
    ensure  => present,
    name => 'lpar11',
    action => 'define'
    attributes => [ 'if1=master_net lpar11 0', 'cable_type1=bnc' ]
  }

  aix_nim { 'allocate-lpar11':
    action => 'allocate',
    ensure  => present,
    name => 'lpar11',
    attributes => [ 'mksysb=7100-03master_sysb', 'spot=7100-03master_spot' ]
  }

  aix_nim { 'tl-update-lpar10':
    action => 'cust',
    ensure => present,
    name => 'lpar10',
    attributes => [ 'lpp_source=7100-04-04_lppsrc', 'fixes=update_all', 'accept_licenses=yes' ]
  }

  aix_suma { 'download_tl':
    ensure => present,
    display_name => 'download_new_tl'
    action => 'immediate',
    attributes => ['RqType=TL', 'RqName=6100-06-00-1036', 'FilterML=6100-05' ]
  }

-----------------------------------------------------------------------------------------------------------------------------
