aix_crfs { 'aix_crfs':
  ensure        => present,
  device        => 'vg_name',
  type          => 'jfs2',
  vg_name       => 'testvg',
  mount_point   => '/testfs2',
  auto_mount    => 'yes',
  size          => '2G',
}
