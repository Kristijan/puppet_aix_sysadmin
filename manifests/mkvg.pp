aix_mkvg { 'aix_mkvg':
  ensure      => present,
  name        => 'db2vg',
  type        => 'scalable',
  disks       => ['hdisk1'],
  pp_size     => '256',
  auto_on     => 'no'
}
