aix_niminit { 'niminit':
  ensure      => present,
  client_name => 'lpar10',
  pif_name    => 'en0',
  cable_type  => 'bnc',
  nim_master  => 'p57a01',
}
