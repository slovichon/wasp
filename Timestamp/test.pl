#!/usr/bin/perl -W

use strict;
use Timestamp;

my $tz = Timestamp->new();

$tz->set_now();

print $tz->format("%c"), "\n";

exit 0;
