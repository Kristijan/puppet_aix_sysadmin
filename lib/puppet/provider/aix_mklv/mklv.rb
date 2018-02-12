Puppet::Type.type(:aix_mklv).provide(:mklv) do

  confine :osfamily => :AIX

  commands :mklv     => '/usr/sbin/mklv',
           :lslv     => '/usr/sbin/lslv',
           :rmlv     => '/usr/sbin/rmlv'

  def exists?
    begin
      lslv("#{resource[:name]}")
    rescue Puppet::ExecutionFailure => e
      false
    end
  end

  def create
    type = resource[:type]
    unless resource[:disks].empty?
      disks_arr = resource[:disks].join(', ').gsub(',', '')
    end
    case type
    when 'normal'
      mklv('-y', "#{resource[:name]}", '-t', "#{resource[:fstype]}", "#{resource[:vgname]}", "#{resource[:num_of_pps]}")
    when 'striped'
      if resource[:disks].empty?
        mklv('-y', "#{resource[:name]}", '-S', "#{resource[:strip_size]}", '-t', "#{resource[:fstype]}", '-u', "#{resource[:max_num_disks]}", "#{resource[:vgname]}", "#{resource[:num_of_pps]}")
      else
        mklv('-y', "#{resource[:name]}", '-S', "#{resource[:fstype]}", '-t', "#{resource[:fstype]}", "#{resource[:vgname]}", "#{resource[:num_of_pps]}", "#{disks_arr}")
      end

    when 'mirrored'
      if !resource[:disks].is_empty?
        mklv('-y', "#{resource[:name]}", '-t', "#{resource[:fstype]}", '-c', "#{resource[:copies]}", "#{resource[:vgname]}", "#{resource[:num_of_pps]}" "#{disks_arr}")
      elsif !resource[:max_num_disks].nil?
        mklv('-y', "#{resource[:name]}", '-t', "#{resource[:fstype]}", '-c', "#{resource[:copies]}", '-u', "#{resource[:max_num_disks]}", "#{resource[:vgname]}", "#{resource[:num_of_pps]}")
      else
        mklv('-y', "#{resource[:name]}", '-t', "#{resource[:fstype]}", '-c', "#{resource[:copies]}", '-u', "#{resource[:max_num_disks]}", "#{resource[:vgname]}", "#{resource[:num_of_pps]}")
      end

    when 'striped_mirrored'
      if resource[:disks].empty?
        mklv('-y', "#{resource[:name]}", '-S', "#{resource[:strip_size]}", '-c', "#{resource[:copies]}", '-t', "#{resource[:fstype]}", '-u', "#{resource[:max_num_disks]}", "#{resource[:vgname]}", "#{resource[:num_of_pps]}")
      else
        mklv('-y', "#{resource[:name]}", '-S', "#{resource[:fstype]}", '-c', "#{resource[:copies]}", '-t', "#{resource[:fstype]}", "#{resource[:vgname]}", "#{resource[:num_of_pps]}", "#{disks_arr}")
      end
    end
  end

  def destroy
    rmlv('-f', "#{resource[:name]}")
  end
end
