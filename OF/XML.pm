package OF::XML;
# $Id$

use OF;
use XML::Element;
use strict;

our @ISA = qw(OF);

#form

sub form_start
{
	my ($this, %prefs) = @_;

	# Get prefs
	$this->_getprefs('form', \%prefs);

	my ($key, $val);
	my $attr = "";
	while (($key, $val) = each %prefs)
	{
		$attr .= qq( $key="$val");
	}

	return "<form$attr>";
}

sub form_end
{
	return "</form>";
}

sub fieldset
{
	my ($this, $r_prefs, @data) = @_;

	unless (ref $r_prefs eq "HASH")
	{
		# Oops, that first arg is actually more data
		unshift @data, $r_prefs;
		$r_prefs = {};
	}

	# Get prefs
	$this->_getprefs('fieldset', $r_prefs);

	my $el = XML::Element->new('fieldset', join '', @data);

	my ($key, $val);
	while (($key, $val) = each %$r_prefs)
	{
		$el->set_attribute($key, $val);
	}

	return $el->build();
}

#table

sub table_start
{
	my ($this, %prefs) = @_;
	my ($key, $val);

	# Get prefs
	$this->_getprefs('table', \%prefs);

	# Column attributes
	my @cols = ();
	my $cols_output = "";
	if (exists $prefs{cols} && ref $prefs{cols} eq "ARRAY")
	{
		@cols = @{ $prefs{cols} };
		delete $prefs{cols};
	}
	if (@cols)
	{
		my $cols_el = XML::Element->new('cols');
		my ($col_prefs, $col);

		foreach $col_prefs (@cols)
		{
			$col_el = XML::Element->new('col');

			$this->_getprefs('col', $col_prefs);

			while (($key, $val) = each %$col_prefs)
			{
				$col_el->set_attribute($key, $val);
			}

			$cols_el->append_value($col_el->build());
		}

		$cols_output = $cols_el->build();
	}

	my $prefs = "";
	while (($key,$val) = each %prefs)
	{
		$prefs .= qq( $key="$val");
	}

	return "<table$prefs>$cols_output";
}

sub table_end
{
	return "</table>";
}

sub table_row
{
	my ($this,@cols) = @_;

	my $el = XML::Element->new('table_row');

	my ($r_col_prefs,$col);
	my ($key,$val);
	foreach $r_col_prefs (@cols)
	{
		$r_col_prefs = {value => $r_col_prefs} unless ref $r_col_prefs eq "HASH";

		$this->_getprefs('table_col', $r_col_prefs);

		$col = XML::Element->new('table_col');

		if (exists $r_col_prefs->{value})
		{
			$col->set_value($r_col_prefs->{value});
			delete $r_col_prefs->{value};
		}

		while (($key,$val) = each %$r_col_prefs)
		{
			$col->set_attribute($key,$val);
		}

		$el->append_value($col->build());
	}

	return $el->build();
}

sub table_head
{
	my ($this ,@cols) = @_;

	my $el = XML::Element->new('table_head_row');

	my ($r_col_prefs, $col);
	my ($key, $val);
	foreach $r_col_prefs (@cols)
	{
		$r_col_prefs = {value => $r_col_prefs} unless ref $r_col_prefs eq "HASH";

		$this->_getprefs('table_head_col', $r_col_prefs);

		$col = XML::Element->new('table_head_col');

		if (exists $r_col_prefs->{value})
		{
			$col->set_value($r_col_prefs->{value});
			delete $r_col_prefs->{value};
		}

		while (($key,$val) = each %$r_col_prefs)
		{
			$col->set_attribute($key, $val);
		}

		$el->append_value($col->build());
	}

	return $el->build();
}

sub p
{
	my ($this, $r_prefs, @data) = @_;

	unless (ref $r_prefs eq "HASH")
	{
		# Oops, the first arg was actually more data
		unshift @data, $r_prefs;
		$r_prefs = {};
	}

	$this->_getprefs('p', $r_prefs);

	my $el = XML::Element->new('p',join '', @data);

	my ($key, $val);
	while (($key, $val) = each %$r_prefs)
	{
		$el->set_attribute($key, $val);
	}

	return $el->build();
}

sub link
{
	my ($this, %prefs) = @_;

	$this->_getprefs('link', \%prefs);

	my $el = XML::Element->new('link');

	if (exists $prefs{value})
	{
		$el->set_value($prefs{value});
		delete $prefs{value};
	}

	my ($key, $val);
	while (($key, $val) = each %prefs)
	{
		$el->set_attribute($key, $val);
	}

	return $el->build();
}

sub hr
{
	my ($this, %prefs) = @_;

	$this->_getprefs('hr', \%prefs);

	my $el = XML::Element->new('hr');

	my ($key, $val);
	while (($key, $val) = each %prefs)
	{
		$el->set_attribute($key, $val);
	}

	return $el->build();
}

sub input
{
	my ($this, %prefs) = @_;
	my ($key, $val);

	my $type = $prefs{type} eq "select" || $prefs{type} eq "textarea" ?
			$prefs{type} : "input";

	$this->_getprefs($type, \%prefs);

	my $el = XML::Element->new('input');

	if ($prefs{type} eq "textarea" && exists $prefs{value})
	{
		$el->set_value($prefs{value});
		delete $prefs{value}
	}

	if ($prefs{type} eq "select")
	{
		my %options = %{ $prefs{options} };
		delete $prefs{options};
		my $opt_el;

		while (($key, $val) = each %options)
		{
			$opt_el = XML::Element->new('option', $val);
			$opt_el->set_attribute('value', $key);
			$el->append_value($opt_el->build());
		}
	}

	while (($key, $val) = each %prefs)
	{
		$el->set_attribute($key, $val);
	}

	return $el->build();
}

sub br
{
	return XML::Element->new('br')->build();
}

sub list_start
{
	my ($this, $type) = @_;

	my %types =
	(
		OF::LIST_UN() => "unordered",
		OF::LIST_OD() => "ordered",
	);

	$this->{wasp}->throw("Unknown list type; type: $type") unless exists $types{$type};

	return qq(<list type="$types{$type}">);
}

sub list_end
{
	return "</list>";
}

sub list_item
{
	my ($this, $item) = @_;
	return XML::Element->new('list_item', $item)->build();
}

#list

sub header
{
	my ($this, $r_prefs, @data) = @_;

	unless (ref $r_prefs eq "HASH")
	{
		# Oops, the first arg was actually more data
		unshift @data, $r_prefs;
		$r_prefs = {};
	}

	$this->_getprefs('header', $r_prefs);

	my $el = XML::Element->new('header', join '', @data);

	if (exists $r_prefs->{value})
	{
		$el->set_value($r_prefs->{value});
		delete $r_prefs->{value};
	}

	my ($key, $val);
	while (($key, $val) = each %$r_prefs)
	{
		$el->set_attribute($key, $val);
	}

	return $el->build();
}

sub emph
{
	my ($this, $r_prefs, @data) = @_;

	unless (ref $r_prefs eq "HASH")
	{
		# Oops, the first arg was actually more data
		unshift @data, $r_prefs;
		$r_prefs = {};
	}

	$this->_getprefs('emph', $r_prefs);

	my $el = XML::Element->new('emph', join '', @data);

	my ($key, $val);
	while (($key, $val) = each %$r_prefs)
	{
		$el->set_attribute($key, $val);
	}

	return $el->build();
}

sub pre
{
	my ($this, $r_prefs, @data) = @_;

	unless (ref $r_prefs eq "HASH")
	{
		# Oops, the first arg was actually more data
		unshift @data, $r_prefs;
		$r_prefs = {};
	}

	$this->_getprefs('pre', $r_prefs);

	my $el = XML::Element->new('pre', join '', @data);

	my ($key, $val);
	while (($key, $val) = each %$r_prefs)
	{
		$el->set_attribute($key, $val);
	}

	return $el->build();
}

sub code
{
	my ($this, $r_prefs, @data) = @_;

	unless (ref $r_prefs eq "HASH")
	{
		# Oops, the first arg was actually more data
		unshift @data, $r_prefs;
		$r_prefs = {};
	}

	$this->_getprefs('code', $r_prefs);

	my $el = XML::Element->new('code', join '', @data);

	my ($key, $val);
	while (($key, $val) = each %$r_prefs)
	{
		$el->set_attribute($key, $val);
	}

	return $el->build();
}

sub strong
{
	my ($this, $r_prefs, @data) = @_;

	unless (ref $r_prefs eq "HASH")
	{
		# Oops, the first arg was actually more data
		unshift @data, $r_prefs;
		$r_prefs = {};
	}

	$this->_getprefs('strong', $r_prefs);

	my $el = XML::Element->new('strong', join '', @data);

	my ($key, $val);
	while (($key, $val) = each %$r_prefs)
	{
		$el->set_attribute($key, $val);
	}

	return $el->build();
}

sub div
{
	my ($this, $r_prefs, @data) = @_;

	unless (ref $r_prefs eq "HASH")
	{
		# Oops, the first arg was actually more data
		unshift @data, $r_prefs;
		$r_prefs = {};
	}

	$this->_getprefs('div', $r_prefs);

	my $el = XML::Element->new('div', join '', @data);

	my ($key, $val);
	while (($key, $val) = each %$r_prefs)
	{
		$el->set_attribute($key, $val);
	}

	return $el->build();
}

sub img
{
	my ($this, %prefs) = @_;

	$this->_getprefs('img', \%prefs);

	my $el = XML::Element->new('img');

	my ($key, $val);
	while (($key, $val) = each %prefs)
	{
		$el->set_attribute($key, $val);
	}

	return $el->build();
}

sub email
{
	my ($this,$email) = shift;
	return XML::Element->new('email', $email)->build();
}

return 1;
