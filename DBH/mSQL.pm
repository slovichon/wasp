package DBH::mSQL;
# $Id$

use DBH qw(:all);
use strict;

our $VERSION = 0.1;
our @ISA = qw(DBH);
our @EXPORT_OK = @DBH::EXPORT_OK;
our %EXPORT_TAGS = %DBH::EXPORT_TAGS;

sub new {
	my ($class, %prefs) = @_;
	$prefs{driver} = "mSQL";
	# Set default mSQL port if unspecified
	$prefs{port} = 1114 if !exists $prefs{port} && exists $prefs{host};
	my $this = $class->SUPER::new(%prefs);
}

=comment
sub last_insert_id {
	my ($this) = @_;
	return $this->{dbh}->{mysql_insertid};
}
=cut

sub last_insert_id {
	my ($this) = @_;
	$this->throw("Cannot call last_insert_id() on mSQL database");
}

return 1;
