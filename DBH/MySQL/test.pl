#!/usr/bin/perl -W
# $Id$

use strict;
use WASP;
use DBH::MySQL qw(:all);

my $w = WASP->new();
my $dbh = DBH::MySQL->new(wasp=>$w, host=>"12.226.98.118", database=>"test");

$dbh->query("CREATE TABLE foo (a INT)", DB_NULL);
$dbh->query("INSERT INTO foo (5)", DB_NULL);

print "This should be 5: ", $dbh->query("SELECT FROM foo", DB_COL), "\n";

exit 0;
