package DBH::MySQL;
# $Id$

use DBH;
use strict;

our $VERSION = 0.1;
our @ISA = qw(DBH);

sub last_insert_id
{
	my $this = shift;
	return $this->{dbh}->func("_InsertID");
}

return 1;
