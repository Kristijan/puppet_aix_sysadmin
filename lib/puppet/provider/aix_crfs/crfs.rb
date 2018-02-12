Puppet::Type.type(:aix_crfs).provide(:crfs) do

  confine :osfamily => :AIX

  commands :crfs     => '/usr/sbin/crfs',
           :lsfs     => '/usr/sbin/lsfs',
           :rmfs     => '/usr/sbin/rmfs'

  def exists?
    begin
      lsfs("#{resource[:mount_point]}")
    rescue Puppet::ExecutionFailure => e
      false
    end
  end

  def create

    if "#{resource[:device]}" == "lv_device"
      if resource[:options].empty?
        crfs('-v', "#{resource[:type]}", '-d', "#{resource[:lv_device]}", '-m', "#{resource[:mount_point]}", '-A', "#{resource[:auto_mount]}", '-a', "agblksize=#{resource[:agblksize]}", '-a', "logname=#{resource[:logname]}" )
      else
        options = resource[:options].join(',').gsub(' ', '')
        crfs('-v', "#{resource[:type]}", '-d', "#{resource[:lv_device]}", '-m', "#{resource[:mount_point]}", '-A', "#{resource[:auto_mount]}", '-a', "agblksize=#{resource[:agblksize]}", '-a', "logname=#{resource[:logname]}", '-a', "options=#{options}")
      end
    elsif "#{resource[:device]}" == "vg_name"
      if resource[:options].empty?
        crfs('-v', "#{resource[:type]}", '-g', "#{resource[:vg_name]}", '-m', "#{resource[:mount_point]}", '-A', "#{resource[:auto_mount]}", '-a', "agblksize=#{resource[:agblksize]}", '-a', "size=#{resource[:size]}", '-a', "logname=#{resource[:logname]}")
      else
        options = resource[:options].join(',').gsub(' ', '')
        crfs('-v', "#{resource[:type]}", '-g', "#{resource[:vg_name]}", '-m', "#{resource[:mount_point]}", '-A', "#{resource[:auto_mount]}", '-a', "agblksize=#{resource[:agblksize]}", '-a', "size=#{resource[:size]}",'-a', "logname=#{resource[:logname]}", '-a', "options=#{options}")
      end
    end
  end

  def destroy
    rmfs("resource[:mount_point]")
  end
end
