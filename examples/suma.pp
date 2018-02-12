aix_nim { 'download_tl':
  action => 'suma',
  name => '11',
  ensure => present,
  attributes => ['RqType=TL', 'RqName=6100-06-00-1036', 'FilterML=6100-05' ]
}
