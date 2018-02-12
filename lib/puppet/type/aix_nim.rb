Puppet::Type.newtype(:aix_nim) do

  @doc = %q{ A custom resource type for managing NIM server.
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
  }

  ensurable

  newparam(:action) do
    newvalues(:allocate, :define, :cust, :maint_boot, :updateios, :suma)
    munge do |value|
      String(value)
    end
  end

  newparam(:name, :namevar => true) do
    munge do |value|
      String(value)
    end
  end

  newparam(:type) do
    munge do |value|
      String(value)
    end
  end

  newparam(:attributes, :array_matching => :all) do
    munge do |value|
      Array(value)
    end
  end
end
