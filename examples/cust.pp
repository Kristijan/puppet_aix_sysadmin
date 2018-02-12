nim_define { 'cust':
  action => 'cust',
  ensure => present,
  name => 'lpar10',
  attributes => [ 'lpp_source=7100-04-04_lppsrc', 'fixes=update_all', 'accept_licenses=yes' ]
}
