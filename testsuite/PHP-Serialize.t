#!/usr/bin/perl -W

use strict;
use warnings;
use common;

use PHP::Serialize qw(serialize unserialize);

test "Testing scalar abilities...";
my $test = "this is a test string.";
print "Serialized: ", serialize(\$test), "\n";
my $copy = unserialize(serialize(\$test));
print "Unserialized: $$copy\n";
_ $$copy eq $test;

exit 0;
