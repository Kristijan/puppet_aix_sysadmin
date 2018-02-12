Puppet::Type.type(:aix_niminit).provide(:niminit) do

  confine :osfamily => :AIX

  commands :niminit     => '/usr/sbin/niminit',
           :ls          => '/usr/bin/ls',
           :rm          => '/usr/bin/rm'
  def exists?
    begin
      ls('/etc/niminfo')
    rescue Puppet::ExecutionFailure => e
      false
    end
  end

  def create
    niminit('-a', "name=#{resource[:client_name]}", '-a', "pif_name=#{resource[:pif_name]}", '-a', "cable_type=#{resource[:cable_type]}", '-a', "master=#{resource[:nim_master]}")
  end

  def destroy
    rm('/etc/niminfo')
  end
end
