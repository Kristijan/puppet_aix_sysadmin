aix_alt_clone { 'new_clone':
  ensure => present,
  disk  =>  'hdisk2',
  change_bootlist =>  'no',
}
