Puppet::Type.type(:aix_tunables).provide(:tunables) do
  # This is the provider for aix_vmo resource type.

  # This provider is supported for AIX systems only.
  confine :osfamily => :AIX

  # vmo command for AIX
  commands  :schedo => '/usr/sbin/schedo',
            :vmo    => '/usr/sbin/vmo',
            :ioo    => '/usr/sbin/ioo',
            :lvmo   => '/usr/sbin/lvmo',
            :no     => '/usr/sbin/no',
            :nfso   => '/usr/sbin/nfso'

  # Check the current value of the vmo tunable attribute to be modified.
  def value
    cmd = "#{resource[:tunable]}"
    case cmd
    when 'schedo'
      schedo('-x', "#{resource[:attribute]}").split(',')[1].chomp
    when 'vmo'
      vmo('-x', "#{resource[:attribute]}").split(',')[1].chomp
    when 'ioo'
      ioo('-x', "#{resource[:attribute]}").split(',')[1].chomp
    when 'lvmo'
      lvmo('-x', "#{resource[:attribute]}").split(',')[1].chomp
    when 'no'
      no('-x', "#{resource[:attribute]}").split(',')[1].chomp
    when 'nfso'
      nfso('-x', "#{resource[:attribute]}").split(',')[1].chomp
    end
  end

  def value=(value)
    cmd = "#{resource[:tunable]}"
    case cmd
    when 'schedo'
      if "#{resource[:permanent]}" == "yes"
        schedo('-p', '-o', "#{resource[:attribute]}=#{resource[:value]}")
      elsif "#{resource[:permanent]}" == "no"
        schedo('-o', "#{resource[:attribute]}=#{resource[:value]}")
      end
    when 'vmo'
      if "#{resource[:permanent]}" == "yes"
        vmo('-p', '-o', "#{resource[:attribute]}=#{resource[:value]}")
      elsif "#{resource[:permanent]}" == "no"
        vmo('-o', "#{resource[:attribute]}=#{resource[:value]}")
      end
    when 'ioo'
      if "#{resource[:permanent]}" == "yes"
        ioo('-p', '-o', "#{resource[:attribute]}=#{resource[:value]}")
      elsif "#{resource[:permanent]}" == "no"
        ioo('-o', "#{resource[:attribute]}=#{resource[:value]}")
      end
    when "lvmo"
      if "#{resource[:permanent]}" == "yes"
        lvmo('-p', '-o', "#{resource[:attribute]}=#{resource[:value]}")
      elsif "#{resource[:permanent]}" == "no"
        lvmo('-o', "#{resource[:attribute]}=#{resource[:value]}")
      end
    when "no"
      if "#{resource[:permanent]}" == "yes"
        no('-p', '-o', "#{resource[:attribute]}=#{resource[:value]}")
      elsif "#{resource[:permanent]}" == "no"
        no('-o', "#{resource[:attribute]}=#{resource[:value]}")
      end

    when "nfso"
      if "#{resource[:permanent]}" == "yes"
        nfso('-p', '-o', "#{resource[:attribute]}=#{resource[:value]}")
      elsif "#{resource[:permanent]}" == "no"
        nfso('-o', "#{resource[:attribute]}=#{resource[:value]}")
      end
    end
  end
end
