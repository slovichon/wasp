package OF;

use Exporter;
use WASP;
use strict;

# List types
use constant LIST_OD => 1;
use constant LIST_UN => 2;

our @ISA = qw(Exporter);
our @EXPORT_OK = ();
push @EXPORT_OK, qw(LIST_OD LIST_UN);	# List types
our %EXPORT_OK = (
			list => [qw(LIST_OD LIST_UN)],
		);

sub new
{
	my ($class, $r_prefs) = shift;
	my $this = bless $r_prefs, ref($class) || $class;
	
#	my $this = bless {}, ref($class) || $class;
=comment
	my ($elem, $r_vals, $name, $val);

	$r_prefs = {} unless ref $r_prefs eq "HASH";
	
	while (($elem, $r_vals) = each %$r_prefs)
	{
		$r_vals = {} unless ref $r_vals eq "HASH";

		while (($name, $val) = each %$r_vals)
		{
			$this->_loadpref($elem, $name, $val);
		}
	}
=cut	
	return $this;
}

sub _getprefs
{
	my ($this,$elem,$r_prefs) = @_;

	if (exists $this->{$elem} && ref $this->{$elem} eq "HASH")
	{
#		$prefs{keys %{$this->{$elem}} = values %{$this->{$elem};

		my ($key,$val);
		while (($key,$val) = each %{ $this->{$elem} })
		{
			$r_prefs->{$key} = $val;
		}
	}

	return $r_prefs;
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
	my ($this,$r_prefs,@data) = @_;
	return	$this->form_start(%$r_prefs) .
		join('',@data) .
		$this->form_end(%$r_prefs);
}

sub form_start;
sub form_end;
sub fieldset;

sub table
{
	my ($this,$r_prefs,@data) = @_;
	
	# First pref arg is optional
	unshift @data, $r_prefs unless ref $r_prefs eq "HASH";
	
	return	$this->table_start(%$r_prefs) .
		join('',@data) .
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
	my ($this,$type,@data) = @_;
	
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

exit 0;
