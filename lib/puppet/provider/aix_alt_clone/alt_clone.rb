Puppet::Type.type(:aix_alt_clone).provide(:aix_clone) do

  confine :osfamily => :AIX

  commands  :alt_disk_copy => '/usr/sbin/alt_disk_copy',
            :alt_rootvg_op => '/usr/sbin/alt_rootvg_op',
            :lspv          => '/usr/sbin/lspv',
            :lsvg          => '/usr/sbin/lsvg'


  def exists?
    begin
      system("lspv | grep altinst_rootvg", [:out, :err]=>"/dev/null")
    rescue Puppet::ExecutionFailure => e
      false
    end
  end

  def run_clone(bootlist)
    if bootlist == "yes"
      alt_disk_copy('-d', "#{resource[:disk]}")
    elsif bootlist == "no"
      alt_disk_copy('-B', '-d', "#{resource[:disk]}")
    end
  end

  def create
    pv_free = system("lspv | grep -w #{resource[:disk]} | grep None", [:out, :err]=>"/dev/null")
    unless pv_free
      raise Puppet::Error, "The provided disk is already in use. Provide a free disk."
    else
      run_clone("#{resource[:change_bootlist]}")
    end
  end

  def destroy
    alt_rootvg_op('-X')
  end
end
