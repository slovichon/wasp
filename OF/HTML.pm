package OF::HTML;
# $Id$

use OF;
use XML::Element;
use strict;

use constant TRUE  => 1;
use constant FALSE => 0;

our @ISA = qw(OF);

#form

sub form_start
{
	my ($this, %prefs) = @_;
	my $attr = "";

	$this->_getprefs('form', \%prefs);

	my ($key, $val);
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

#table

sub table_end
{
	return "</table>";
}

sub table_start
{
	my ($this, %prefs) = @_;
	my ($key, $val);
	my $attr = "";
	my $cols_output = "";

	$this->_getprefs('table', \%prefs);

	if (exists $prefs{cols} && ref $prefs{cols} eq "ARRAY")
	{
		my @cols = @{ $prefs{cols} };
		delete $prefs{cols};

		my $cols_el = XML::Element->new('colgroup');

		my ($r_col_prefs, $col_el);
		foreach $r_col_prefs (@cols)
		{
			$col_el = XML::Element->new('col');

			while (($key, $val) = each %{ $r_col_prefs })
			{
				$col_el->set_attribute($key, $val);
			}

			$cols_el->append_value($col_el->build());
		}

		$cols_output = $cols_el->build();
	}

	while (($key, $val) = each %prefs)
	{
		$attr .= qq( $key="$val");
	}

	return "<table$attr>$cols_output";
}

sub table_row
{
	my ($this, @cols) = @_;
	my ($key, $val);

	my $row_el = XML::Element->new('tr');

	my ($r_col_prefs,$col_el);
	foreach $r_col_prefs (@cols)
	{
		$r_col_prefs = {value => $r_col_prefs} unless ref $r_col_prefs eq "HASH";

		$col_el = XML::Element->new('td');

		if (exists $r_col_prefs->{value})
		{
			$col_el->set_value($r_col_prefs->{value});
			delete $r_col_prefs->{value};
		}

		while (($key, $val) = each %$r_col_prefs)
		{
			$col_el->set_attribute($key, $val);
		}

		$row_el->append_value($col_el->build());
	}

	return $row_el->build();
}

sub table_head
{
	my ($this, @cols) = @_;
	my ($key, $val);

	my $row_el = XML::Element->new('tr');

	my ($r_col_prefs,$col_el);
	foreach $r_col_prefs (@cols)
	{
		$r_col_prefs = {value => $r_col_prefs} unless ref $r_col_prefs eq "HASH";

		$col_el = XML::Element->new('th');

		if (exists $r_col_prefs->{value})
		{
			$col_el->set_value($r_col_prefs->{value});
			delete $r_col_prefs->{value};
		}

		while (($key, $val) = each %$r_col_prefs)
		{
			$col_el->set_attribute($key, $val);
		}

		$row_el->append_value($col_el->build());
	}

	return $row_el->build();
}

sub p
{
	my ($this, $r_prefs, @data) = @_;

	unless (ref $r_prefs eq "HASH")
	{
		# Oops, first arg was actually more data
		unshift @data, $r_prefs;
		$r_prefs = {};
	}

	$this->_getprefs('p', $r_prefs);

	my $el = XML::Element->new('p', join '', @data);

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

	$this->_getprefs('a', \%prefs);

	my $el = XML::Element->new('a');

	my @test = %prefs;
	if (@test == 2 && $test[0] ne "name")
	{
		%prefs = (
			value => $test[0],
			href  => $test[1],
		);
	}

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

sub fieldset
{
	my ($this, $r_prefs, @data) = @_;

	unless (ref $r_prefs eq "HASH")
	{
		unshift @data, $r_prefs;
		$r_prefs = {};
	}

	$this->_getprefs('fieldset', $r_prefs);

	my $el = XML::Element->new('fieldset', join '', @data);

	my ($key, $val);
	while (($key, $val) = each %$r_prefs)
	{
		$el->set_attribute($key, $val);
	}

	return $el->build();
}

sub _in_array
{
	my ($needle, $hay) = @_;
	foreach (@$hay)
	{
		return TRUE if $needle eq $_;
	}
	return FALSE;
}

sub input
{
	my ($this, %prefs) = @_;
	my ($key, $val);

	$this->{wasp}->throw("Invalid input type") unless exists $prefs{type};

	if ($prefs{type} eq "select")
	{
		delete $prefs{type};

		my %options = %{ $prefs{options} };
		delete $prefs{options};

		my $sel_el = XML::Element->new('select');

		my $opt_el;
		while (($key, $val) = each %options)
		{
			$opt_el = XML::Element->new('option', $val);
			$opt_el->set_attribute('value', $key);

			if (exists $prefs{value})
			{
				if (ref $prefs{value} eq "ARRAY" && _in_array($key, $prefs{value})
					|| $prefs{value} eq $key)
				{
					$opt_el->set_attribute('selected', 'selected');
					delete $prefs{value};
				}
			}

			$sel_el->append_value($opt_el->build());
		}

		while (($key, $val) = each %prefs)
		{
			$sel_el->set_attribute($key, $val);
		}

		return $sel_el->build;

	} elsif ($prefs{type} eq "textarea") {

		delete $prefs{type};

		my $el = XML::Element->new('textarea');

		if (exists $prefs{value})
		{
#			$el->set_value(escapeHTML($prefs{value}));
			$el->set_value($prefs{value});
			delete $prefs{value};
		}

		while (($key, $val) = each %prefs)
		{
			$el->set_attribute($key, $val);
		}

		return $el->build();
	} else {
		my $el = XML::Element->new('input');

		my $label;
		if (exists $prefs{label})
		{
			$label = $prefs{label};
			delete $prefs{label};
		}

		if (defined $label && !exists $prefs{id})
		{
			$prefs{id} = $this->_gen_rand_id();
		}

=comment
		if (exists $prefs{checked} && $prefs{checked})
		{
			$prefs{checked} = "checked";
		} else {
			delete $prefs{checked}
		}
=cut
=comment
		if (exists $prefs{value})
		{
			$el->set_value($prefs{value});
			delete $prefs{value};
		}
=cut
		while (($key, $val) = each %prefs)
		{
			$el->set_attribute($key, $val);
		}

		if (defined $label)
		{
			$el = XML::Element->new('label', $el->build() . " $label");
			$el->set_attribute('for', $prefs{id});
		}

		return $el->build();
	}
}

sub _gen_rand_id
{
	# This should be good enough...
	return "WaspOFInput".int rand 1e9;
}

sub br
{
	return XML::Element->new('br')->build();
}

#list

sub list_start
{
	my ($this, $type) = @_;

	my %types =
	(
		OF::LIST_OD() => "ol",
		OF::LIST_UN() => "ul",
	);

	$this->{wasp}->throw("Unknown list type; type: $type") unless exists $types{$type};

	return "<$types{$type}>";
}

sub list_end
{
	my ($this, $type) = @_;

	my %types =
	(
		OF::LIST_OD() => "ol",
		OF::LIST_UN() => "ul",
	);

	$this->{wasp}->throw("Unknown list type; type: $type") unless exists $types{$type};

	return "</$types{$type}>";
}

sub list_item
{
	my ($this, $item) = @_;

	return XML::Element->new('li', $item)->build();
}

sub header
{
	my ($this, $r_prefs, @data) = @_;

	unless (ref $r_prefs eq "HASH")
	{
		# Oops, first arg was actually more data
		unshift @data, $r_prefs;
		$r_prefs = {};
	}

	$this->_getprefs('header', $r_prefs);

	$this->{wasp}->throw("Unknown header size") unless exists $r_prefs->{size};

	my $tag = "h" . $r_prefs->{size};
	delete $r_prefs->{size};

	my $el = XML::Element->new($tag, join '', @data);

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
		# Oops, first arg was actually more data
		unshift @data, $r_prefs;
		$r_prefs = {};
	}

	$this->_getprefs('emph', $r_prefs);

	my $el = XML::Element->new('em', join '', @data);

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
		# Oops, first arg was actually more data
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
		# Oops, first arg was actually more data
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
		# Oops, first arg was actually more data
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
		# Oops, first arg was actually more data
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
	my ($this, $email) = @_;

	$email =~ s/[a-zA-Z0-9]/"&#".ord($&).";"/eg;
	$email =~ s/@/<!-- \nbleh\n -->(at)<!-- \nbleh\n -->/;
	$email =~ s/\./<!-- \nbleh\n -->[dot]<!-- \nbleh\n -->/g;

	return $email;
}

return 1;