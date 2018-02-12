Puppet::Type.newtype(:aix_niminit) do

  @doc = %q{ A custom resource to define an AIX system as a NIM client.
         Accepted valid for this resource type are -

         ensure         =>    Ensures the AIX node be configured as a nim client.
                              Accepted values are present, absent
                              if absent - the '/etc/niminfo' file will be removed from the client node.

         client_name    =>    Name for the client to be used. Usually its the short hostname

         nim_master     =>    Hostname of the NIM master to be used in the configuration

         pif_name       =>    Interface name to be used to communicate with the NIM server

         cable_type     =>    Cable type to be used for the connection
                              Valid values are 'bnc', 'dix', 'NA'

        ----------------------------------------------------------------------------------------------------
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
        ----------------------------------------------------------------------------------------------------
  }

  ensurable

  newparam(:client_name, :namevar => true) do
    munge do |value|
      String(value)
    end
  end

  newparam(:nim_master) do
    munge do |value|
      String(value)
    end
  end

  newparam(:pif_name) do
    munge do |value|
      String(value)
    end
  end

  newparam(:cable_type) do
    defaultto :bnc
    newvalues(:bnc, :dix, :NA)
    munge do |value|
      String(value)
    end
  end
end
