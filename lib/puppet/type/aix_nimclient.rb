Puppet::Type.newtype(:aix_nimclient) do

  @doc = %q{ A custom resource to perform AIX patching.
          Available attributes are -

          fixes         =>    Name of the fixes to be installed.
                              'update_all' for all the fixes contained in the lpp_source to be installed

          desired_level =>    Desired OS level to be installed.
                              Valid format is 7100-04-04
                              This expects the lpp_source to be named '7100-04-04_lppsrc'

          ----------------------------------------------------------------------------------------------------
          Examples:

          1) The below example will update the system to OSLEVEL '7100-04-04'
             This will search for lpp_source resource with name '7100-04-04_lppsrc' in the nim server.

          aix_nimclient { 'update':
            fixes         => 'update_all',
            desired_level => '7100-04-04',
          }
          ----------------------------------------------------------------------------------------------------
  }

  newparam(:fixes, :namevar => true) do
    munge do |value|
      String(value)
    end
  end

  newproperty(:desired_level) do
    munge do |value|
      String(value)
    end
  end
end
