aix_nim { 'allocate':
  action => 'allocate',
  ensure  => present,
  name => 'lpar11',
  attributes => [ 'mksysb=7100-03master_sysb', 'spot=7100-03master_spot' ]
}
