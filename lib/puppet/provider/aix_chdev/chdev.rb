Puppet::Type.type(:aix_chdev).provide(:chdev) do
  # This is the provider for the aix_chdev resource type.

  # This provider only supports AIX Operating System.
  confine :osfamily => :AIX

  # lsattr and chdev commands to view and modify device attributes in AIX.
  commands :chdev => "/usr/sbin/chdev"
  commands :lsattr => "/usr/sbin/lsattr"

  def value
    # Check the current value of the property to be modified.
    lsattr('-El', "#{resource[:device]}", '-a', "#{resource[:attribute]}").split(' ')[1].chomp
  end

  def value=(value)

    # chdev command flags are based in the 'dynamic' property.
    if "#{resource[:dynamic]}" == "no"
      chdev('-l', "#{resource[:device]}", '-a', "#{resource[:attribute]}=#{resource[:value]}", '-P')
    elsif "#{resource[:dynamic]}" == "yes"
      chdev('-l', "#{resource[:device]}", '-a', "#{resource[:attribute]}=#{resource[:value]}")
    elsif "#{resource[:dynamic]}" == "temporary"
      chdev('-l', "#{resource[:device]}", '-a', "#{resource[:attribute]}=#{resource[:value]}", '-T')
    end
  end
end
