aix_mkvg { 'oradatavg':
  ensure  => present,
  name    => 'oradatavg',
  type    => 'scalable',
  pp_size =>  '16',
  auto_on =>  'no',
  force   =>  'yes',
  disks   => ['hdisk1', 'hdisk2', 'hdisk3', 'hdisk4']
}

aix_mklv { 'datalv1':
  ensure         => present,
  name           => 'datalv1',
  type           => 'striped',
  fstype         => 'jfs2',
  strip_size     => '128K',
  max_num_disks  =>  '4',
  num_of_pps     =>  '8',
  vgname         =>  'oradatavg',
  require        =>  Aix_mkvg['oradatavg']
}

aix_mklv { 'datalv2':
  ensure         => present,
  name           => 'datalv2',
  type           => 'striped',
  fstype         => 'jfs2',
  strip_size     => '128K',
  max_num_disks  =>  '4',
  num_of_pps     =>  '8',
  vgname         =>  'oradatavg',
  require        =>  Aix_mkvg['oradatavg']
}

aix_crfs { 'oradata1':
  ensure        =>  present,
  type          => 'jfs2',
  device        =>  'lv_device',
  lv_device     =>  '/dev/datalv1',
  mount_point   =>  '/oradata1',
  auto_mount    =>  'no',
  require       =>  Aix_mklv['datalv1']
}

aix_crfs { 'oradata2':
  ensure        =>  present,
  type          => 'jfs2',
  device        =>  'lv_device',
  lv_device     =>  '/dev/datalv2',
  mount_point   =>  '/oradata2',
  auto_mount    =>  'no',
  require       =>  Aix_mklv['datalv2']
}

aix_mkvg { 'redologvg':
  ensure  => present,
  name    => 'redologvg',
  type    => 'scalable',
  pp_size =>  '16',
  auto_on =>  'no',
  force   =>  'yes',
  disks   => ['hdisk5', 'hdisk6', 'hdisk7', 'hdisk8']
}

aix_mklv { 'redolog1':
  ensure         => present,
  name           => 'redolog1',
  type           => 'striped',
  fstype         => 'jfs2',
  strip_size     => '128K',
  max_num_disks  =>  '4',
  num_of_pps     =>  '8',
  vgname         =>  'redologvg',
  require        =>  Aix_mkvg['redologvg']
}

aix_mklv { 'redolog2':
  ensure         => present,
  name           => 'redolog2',
  type           => 'striped',
  fstype         => 'jfs2',
  strip_size     => '128K',
  max_num_disks  =>  '4',
  num_of_pps     =>  '8',
  vgname         =>  'redologvg',
  require        =>  Aix_mkvg['redologvg']
}

aix_crfs { 'redolog1':
  ensure        =>  present,
  type          => 'jfs2',
  device        =>  'lv_device',
  lv_device     =>  '/dev/redolog1',
  mount_point   =>  '/redolog1',
  auto_mount    =>  'no',
  options       => ['cio', 'rbr'],
  require       =>  Aix_mklv['redolog1']
}

aix_crfs { 'redolog2':
  ensure        =>  present,
  type          => 'jfs2',
  device        =>  'lv_device',
  lv_device     =>  '/dev/redolog2',
  mount_point   =>  '/redolog2',
  auto_mount    =>  'no',
  options       => ['cio', 'rbr'],
  require       =>  Aix_mklv['redolog2']
}

aix_mkvg { 'orabkupvg':
  ensure  => present,
  name    => 'orabkupvg',
  type    => 'scalable',
  pp_size =>  '16',
  auto_on =>  'yes',
  force   =>  'yes',
  disks   => ['hdisk9', 'hdisk10']
}

aix_mklv { 'orabkuplv':
  ensure         => present,
  name           => 'orabkuplv',
  type           => 'striped',
  fstype         => 'jfs2',
  strip_size     => '128K',
  max_num_disks  =>  '2',
  num_of_pps     =>  '8',
  vgname         =>  'orabkupvg',
  require        =>  Aix_mkvg['orabkupvg']
}

aix_mklv { 'oradumplv':
  ensure          => present,
  name            => 'oradumplv',
  type            => 'striped',
  fstype          => 'jfs2',
  strip_size      => '128K',
  max_num_disks   =>  '2',
  num_of_pps      =>  '8',
  vgname          =>  'orabkupvg',
  require        =>  Aix_mkvg['orabkupvg']
}

aix_crfs { 'orabkup':
  ensure        =>  present,
  type          => 'jfs2',
  device        =>  'lv_device',
  lv_device     =>  '/dev/orabkuplv',
  mount_point   =>  '/orabkup',
  auto_mount    =>  'no',
  require       =>  Aix_mklv['orabkuplv']
}

aix_crfs { 'oradump':
  ensure        =>  present,
  type          => 'jfs2',
  device        =>  'lv_device',
  lv_device     =>  '/dev/oradumplv',
  mount_point   =>  '/oradump',
  auto_mount    =>  'no',
  require       =>  Aix_mklv['oradumplv']
}
