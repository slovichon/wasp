package OF;
# $Id$

use Exporter;
use WASP;
use strict;

# List types
use constant LIST_OD => 1;
use constant LIST_UN => 2;

our $VERSION = 0.1;
our @ISA = qw(Exporter);
our @EXPORT_OK = ();
push @EXPORT_OK, qw(LIST_OD LIST_UN);	# List types
our %EXPORT_OK = (
			list => [qw(LIST_OD LIST_UN)],
		);

sub new
{
	my ($class, $wasp, $r_prefs) = @_;
	$r_prefs = {} unless ref $r_prefs eq "HASH";
	return bless {
			wasp  => $wasp,
			prefs => $r_prefs,
		}, ref($class) || $class;
}

sub _getprefs
{
	my ($this, $elem, $r_prefs) = @_;

	if (exists $this->{prefs}{$elem})
	{
# We can't assign:
#
#		%$r_prefs = $this->{prefs}{$elem};
#
# because it will wipe out %$r_prefs, and the values
# must be preserved.

# This:
#
#		@$r_prefs->{keys %{ $this->{prefs}{$elem} }} = values %{ $this->{prefs}{$elem} };
#
# can't be used either, since it will overwrite presented
# preferences.

		my ($key, $val);
		while (($key, $val) = each %{ $this->{prefs}{$elem} })
		{
			$r_prefs->{$key} = $val unless defined $r_prefs->{$key};
		}
	}

	return;
}

=comment
sub _loadpref
{
	my ($this, $key, $val) = @_;



	return;
}
=cut

# Abstract methods
sub form
{
	my ($this, $r_prefs, @data) = @_;
	return	$this->form_start(%$r_prefs) .
		join('', @data) .
		$this->form_end(%$r_prefs);
}

sub form_start;
sub form_end;
sub fieldset;

sub table
{
	my ($this, $r_prefs, @data) = @_;

	# First pref arg is optional
	unshift @data, $r_prefs unless ref $r_prefs eq "HASH";

	return	$this->table_start(%$r_prefs) .
		join('', @data) .
		$this->table_end(%$r_prefs);
}

sub table_end;
sub table_start;
sub table_row;
sub table_head;
sub p;
sub link;
sub hr;
sub input;
sub br;

sub list
{
	my ($this, $type, @data) = @_;

	# First pref arg is optional
#	unshift @data, $r_prefs unless ref $r_prefs eq "HASH";

	my $out = $this->list_start($type);
	$out .= $this->list_item($_) foreach @data;
	$out .= $this->list_end($type);

	return $out;
}

sub list_start;
sub list_end;
sub list_item;
sub header;
sub emph;
sub pre;
sub code;
sub strong;
sub div;
sub img;
sub email;

return 1;
