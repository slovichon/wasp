package DBH::MySQL;
# $Id$

use DBH qw(:all);
use strict;

our $VERSION = 0.1;
our @ISA = qw(DBH);
our @EXPORT_OK = @DBH::EXPORT_OK;
our %EXPORT_TAGS = %DBH::EXPORT_TAGS;

sub new
{
	my ($class, %prefs) = @_;
	$prefs{driver} = "mysql";
	# Set default port if unspecified
	$prefs{port} = 3306 if !exists $prefs{port} && exists $prefs{host};
	my $this = $class->SUPER::new(%prefs);
}

return 1;
