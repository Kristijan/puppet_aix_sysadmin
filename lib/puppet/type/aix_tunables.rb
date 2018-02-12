Puppet::Type.newtype(:aix_tunables) do
  @doc = %q{ A custom resource type to modify values for vmo tunable attributes in AIX.
          Available attributes for this resource type are 'tunable', 'value', 'permanent'

          tunable   => Name of the tunable to be modified.
                       Valid values are - 'schedo', 'vmo', 'ioo', 'lvmo', 'no', 'nfso'
          attribute => Name of the tunable attribute to be modified.
                       Valid values are the tunable attribute names, that are not 'Restricted Tunables'.
          value     => The new value to be assigned to the tunable attribute.
                       Valid values are accepted values for the tunable.
          permanent => Decides whether the change is to only the current kernel or a permanent change.
                       Accepts either 'yes' or 'no'.
                       If set to 'no', the tunable must be of dynamic type.

         -----------------------------------------------------------------------------------------------------------------
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
         -----------------------------------------------------------------------------------------------------------------

         Note: The resource type doesnt support modifying 'Restricted Tunables' in AIX. }

  newparam(:tunable) do
    desc "Specifies the tunable to be used.
          Valid values are 'schedo', 'vmo', 'ioo', 'lvmo', 'no', 'nfso'"
    newvalues(:schedo, :vmo, :ioo, :lvmo, :no, :nfso)
    munge do |value|
      String(value)
    end
  end

  newparam(:attribute, :namevar => true) do
    desc "Specifies the tunable attribute to be modified.
          Valid values are the attribute names, that are not 'Restricted Tunables'."
    munge do |value|
      String(value)
    end
  end

  newproperty(:value) do
    desc "Specifies the new value to be assigned for the tunable.
          It is the user's responsibility to specify accepted values for the tunable.
          We dont check if the provided value is acceptable for the tunable attribute."
    munge do |value|
      String(value)
    end
  end

  newparam(:permanent) do
    desc "Specifies if the new value is to be set on the current kernel only or make it a permanent setting too.
          yes - change the current kernel value and make it permanent setting.
          no  - change the current kernel value only.
          default is no. "
    defaultto :no
    newvalues(:yes, :no)
  end
end
