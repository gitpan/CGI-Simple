open F, './Simple.pm';
while (<F>) {
  next unless /^(sub\s+\w+)/;
  print "$1;\n";
}
  