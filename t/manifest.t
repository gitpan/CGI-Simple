use strict;
use warnings;
use Test::More;
 
eval 'use Test::DistManifest 1.012';
plan skip_all => 'Test::DistManifest 1.012 required to test MANIFEST' if $@;
manifest_ok();

# vim:ts=2:sw=2:et:ft=perl

