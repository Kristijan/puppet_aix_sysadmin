$inputs_hash = {
  attribute => 'queue_depth',
  value => '3',
  dynamic => 'no',
}

$devices_array = [ 'hdisk0', 'hdisk1' ]

$devices_array.each() |$dev| { 
  aix_chdev { "$dev-chdev":
    device => "$dev",
    * => $inputs_hash
  }
}
