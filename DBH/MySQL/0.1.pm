package DBH::MySQL;
# $Id$

use DBH;
use strict;

our $VERSION = 0.1;
our @ISA = qw(DBH);
our @EXPORT_OK = @DBH::EXPORT_OK;
our @EXPORT_TAGS = @DBH::EXPORT_TAGS;

sub last_insert_id
{
	my $this = shift;
	return $this->{dbh}->func("_InsertID");
}

return 1;
