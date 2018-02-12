aix_suma { 'download_sp':
  ensure => present,
  display_name => 'download_new_sp',
  action => 'schedule',
  sched => '0 3 * * 4',
  attributes => ['RqType=SP', 'RqName=6100-06-03-1048', 'FilterML=6100-06' ]
}
