$vmo_hash = {
  'minperm%' => '10',
  'maxpin%'  => '80',
}

$vmo_hash.each() |$attr, $val| {
  aix_tunables { "$attr-change":
    tunable   => 'vmo',
    attribute => "$attr",
    value     => "$val",
    permanent => 'yes',
  }
}
