Puppet::Type.type(:aix_nimclient).provide(:nimclient) do

  confine :osfamily => :AIX

  commands :nimclient     => '/usr/sbin/nimclient',
           :oslevel       => '/usr/bin/oslevel'

  def desired_level
    oslevel('-s').split('-')[0..2].join('-').to_s
  end
  def desired_level=(value)
    nimclient('-o', "cust", '-a', "lpp_source="+"#{resource[:desired_level]}"+"_lppsrc", '-a', "accept_licenses=yes", '-a', "fixes=#{fixes}")
  end
end
