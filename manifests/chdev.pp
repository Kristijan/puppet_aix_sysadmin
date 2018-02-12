aix_chdev { 'chdev':
  device    => 'en0',
  attribute => 'mtu_bypass',
  value     => 'on',
  dynamic   => 'yes',
}
