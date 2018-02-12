Puppet::Type.type(:aix_nim).provide(:nim) do

  confine :osfamily => :AIX

  commands :lsnim     => '/usr/sbin/lsnim',
           :nim     => '/usr/sbin/nim',
           :suma    => '/usr/sbin/suma'

  def exists?
    case resource[:action]
    when 'define'
      begin
        lsnim("#{resource[:name]}")
      rescue Puppet::ExecutionFailure => e
        false
      end
    when 'allocate','cust', 'maint_boot', 'updateios'
      begin
        attr_count = 0
        attr_array = resource[:attributes]
        attr_array = attr_array.map { |x| x.split('=')[1] }
        attr_array.each do |attrib|
          if lsnim('-a', 'Rstate', '-Z', "#{attrib}")
            attr_count += 1
          end
        end
        false if attr_array.count == attr_count
      rescue Puppet::ExecutionFailure => e
        false
      end
    when 'suma'
      false
    end
  end

  def create
    attr_array = resource[:attributes]
    attribs = attr_array.map{ |x| ['-a', x] }.flatten
    case resource[:action]
    when 'define'
      unless resource[:attributes].empty?
        nim_args = [['-o', 'define', '-t', "#{resource[:type]}"] + attribs + ["#{resource[:name]}"]]
        nim(*nim_args)
      else
        nim('-o', 'define', '-t', "#{resource[:type]}", "#{resource[:name]}")
      end
    when 'allocate','cust','maint_boot','updateios'
      action = resource[:action]
      nim_args = ['-o', "#{action}" ] + attribs + ["#{resource[:name]}"]
      nim(*nim_args)
    when 'suma'
      suma_args = ['-x'] + attribs
      suma(*suma_args)
    end
  end

  def destroy
    case resource[:action]
    when 'define'
      nim('-o', 'remove', "#{resource[:name]}")
    when 'allocate'
      attr_array = resource[:attributes]
      attribs = attr_array.map{ |x| '-a'+x }.flatten
      nim_args = [['-o', 'deallocate' ] + attribs + ["#{resource[:name]}"]]
      nim(*nim_args)
    when 'suma'
      puts "Please note there is really nothing to delete for 'suma' action."
    end
  end
end
