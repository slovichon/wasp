#!/usr/bin/perl -W
# $Id$

use strict;
use Timestamp;

my $tz = Timestamp->new();

$tz->set_now();

print $tz->format("%c"), "\n";

exit 0;
