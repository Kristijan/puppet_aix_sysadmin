aix_nim { 'add-lpar11':
  ensure  => present,
  action => 'define',
  name => 'lpar11',
  type => 'standalone',
  attributes => [ 'if1=master_net lpar11 0', 'cable_type1=bnc' ]
}
