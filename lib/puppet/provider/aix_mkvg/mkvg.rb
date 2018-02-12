Puppet::Type.type(:aix_mkvg).provide(:mkvg) do

  confine :osfamily => :AIX

  commands :mkvg     => '/usr/sbin/mkvg',
           :lsvg     => '/usr/sbin/lsvg',
           :reducevg => '/usr/sbin/reducevg'

  def exists?
    begin
      lsvg("#{resource[:name]}")
    rescue Puppet::ExecutionFailure => e
      false
    end
  end

  def create
    disks = resource[:disks].join(', ').gsub(',', '')
    case resource[:force]
    when 'no'
      if "#{resource[:auto_on]}" == 'yes'
        if "#{resource[:type]}" == 'big'
          mkvg('-B', '-s', "#{resource[:pp_size]}", '-y', "#{resource[:name]}", "#{disks}")
        elsif "#{resource[:type]}" == 'scalable'
          mkvg('-S', '-s', "#{resource[:pp_size]}", '-y', "#{resource[:name]}", "#{disks}")
        else
          mkvg('-s', "#{resource[:pp_size]}", '-y', "#{resource[:name]}", "#{disks}")
        end
      elsif "#{resource[:auto_on]}" == 'no'
        if "#{resource[:type]}" == 'big'
          mkvg('-B', '-s', "#{resource[:pp_size]}", '-n', '-y', "#{resource[:name]}", "#{disks}")
        elsif "#{resource[:type]}" == 'scalable'
          mkvg('-S', '-s', "#{resource[:pp_size]}", '-n', '-y', "#{resource[:name]}", "#{disks}")
        else
          mkvg('-s', "#{resource[:pp_size]}", '-n', '-y', "#{resource[:name]}", "#{disks}")
        end
      end

    when 'yes'
      if "#{resource[:auto_on]}" == 'yes'
        if "#{resource[:type]}" == 'big'
          mkvg('-B', '-s', "#{resource[:pp_size]}", '-f', '-y', "#{resource[:name]}", "#{disks}")
        elsif "#{resource[:type]}" == 'scalable'
          mkvg('-S', '-s', "#{resource[:pp_size]}", '-f', '-y', "#{resource[:name]}", "#{disks}")
        else
          mkvg('-s', "#{resource[:pp_size]}", '-f', '-y', "#{resource[:name]}", "#{disks}")
        end
      elsif "#{resource[:auto_on]}" == 'no'
        if "#{resource[:type]}" == 'big'
          mkvg('-B', '-s', "#{resource[:pp_size]}", '-n', '-f', '-y', "#{resource[:name]}", "#{disks}")
        elsif "#{resource[:type]}" == 'scalable'
          mkvg('-S', '-s', "#{resource[:pp_size]}", '-n', '-f', '-y', "#{resource[:name]}", "#{disks}")
        else
          mkvg('-s', "#{resource[:pp_size]}", '-n', '-f', '-y', "#{resource[:name]}", "#{disks}")
        end
      end
    end
  end

  def destroy
    disks = resource[:disks].join(', ').gsub(',', '')
    reducevg("#{resource[:name]}", "#{disks}")
  end
end
