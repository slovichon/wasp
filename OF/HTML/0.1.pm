package OF::HTML;

use OF;
use XMLNode;
use strict;

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

		my $cols_node = XMLNode->new('colgroup');

		my ($r_col_prefs, $col_node);
		foreach $r_col_prefs (@cols)
		{
			$col_node = XMLNode->new('col');

			while (($key, $val) = each %{ $r_col_prefs })
			{
				$col_node->set_attribute($key, $val);
			}

			$cols_node->append_value($col_node->build());
		}

		$cols_output = $cols_node->build();
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

	my $row_node = XMLNode->new('tr');

	my ($r_col_prefs,$col_node);
	foreach $r_col_prefs (@cols)
	{
		$r_col_prefs = {value => $r_col_prefs} unless ref $r_col_prefs eq "HASH";

		$col_node = XMLNode->new('td');

		if (exists $r_col_prefs->{value})
		{
			$col_node->set_value($r_col_prefs->{value});
			delete $r_col_prefs->{value};
		}

		while (($key, $val) = each %$r_col_prefs)
		{
			$col_node->set_attribute($key, $val);
		}

		$row_node->append_value($col_node->build());
	}

	return $row_node->build();
}

sub table_head
{
	my ($this, @cols) = @_;
	my ($key, $val);

	my $row_node = XMLNode->new('tr');

	my ($r_col_prefs,$col_node);
	foreach $r_col_prefs (@cols)
	{
		$r_col_prefs = {value => $r_col_prefs} unless ref $r_col_prefs eq "HASH";

		$col_node = XMLNode->new('th');

		if (exists $r_col_prefs->{value})
		{
			$col_node->set_value($r_col_prefs->{value});
			delete $r_col_prefs->{value};
		}

		while (($key, $val) = each %$r_col_prefs)
		{
			$col_node->set_attribute($key, $val);
		}

		$row_node->append_value($col_node->build());
	}

	return $row_node->build();
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

	my $node = XMLNode->new('p', join '', @data);

	my ($key, $val);
	while (($key, $val) = each %$r_prefs)
	{
		$node->set_attribute($key, $val);
	}

	return $node->build();
}

sub link
{
	my ($this, %prefs) = @_;

	$this->_getprefs('a', \%prefs);

	my $node = XMLNode->new('a');

	if (exists $prefs{value})
	{
		$node->set_value($prefs{value});
		delete $prefs{value};
	}

	my ($key, $val);
	while (($key, $val) = each %prefs)
	{
		$node->set_attribute($key, $val);
	}

	return $node->build();
}

sub hr
{
	my ($this, %prefs) = @_;
	
	$this->_getprefs('hr', \%prefs);
	
	my $node = XMLNode->new('hr');
	
	my ($key, $val);
	while (($key, $val) = each %prefs)
	{
		$node->set_attribute($key, $val);
	}
	
	return $node->build();
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

	my $node = XMLNode->new('fieldset', join '', @data);

	my ($key, $val);
	while (($key, $val) = each %$r_prefs)
	{
		$node->set_attribute($key, $val);
	}

	return $node->build();
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
	
		my $sel_node = XMLNode->new('select');
		
		my $opt_node;
		while (($key, $val) = each %options)
		{
			$opt_node = XMLNode->new('option', $val);
			$opt_node->set_attribute('value', $key);

			if (exists $prefs{value} && $prefs{value} eq $key)
			{
				$opt_node->set_attribute('selected', 'selected');
				delete $prefs{value};
			}

			$sel_node->append_value($opt_node->build());
		}
		
		while (($key, $val) = each %prefs)
		{
			$sel_node->set_attribute($key, $val);
		}
		
		return $sel_node->build;
		
	} elsif ($prefs{type} eq "textarea") {

		delete $prefs{type};

		my $node = XMLNode->new('textarea');

		if (exists $prefs{value})
		{
#			$node->set_value(escapeHTML($prefs{value}));
			$node->set_value($prefs{value});
			delete $prefs{value};
		}

		while (($key, $val) = each %prefs)
		{
			$node->set_attribute($key, $val);
		}
		
		return $node->build();
	} else {
		my $node = XMLNode->new('input');

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
			$node->set_value($prefs{value});
			delete $prefs{value};
		}
=cut
		while (($key, $val) = each %prefs)
		{
			$node->set_attribute($key, $val);
		}

		if (defined $label)
		{
			$node = XMLNode->new('label', $node->build() . " $label");
			$node->set_attribute('for', $prefs{id});
		}

		return $node->build();
	}
}

sub _gen_rand_id
{
	# This should be good enough...
	return "WaspOFInput".int rand 1e9;
}

sub br
{
	return XMLNode->new('br')->build();
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

	return XMLNode->new('li', $item)->build();
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

	my $node = XMLNode->new($tag, join '', @data);

	my ($key, $val);
	while (($key, $val) = each %$r_prefs)
	{
		$node->set_attribute($key, $val);
	}

	return $node->build();
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

	my $node = XMLNode->new('em', join '', @data);

	my ($key, $val);
	while (($key, $val) = each %$r_prefs)
	{
		$node->set_attribute($key, $val);
	}

	return $node->build();
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

	my $node = XMLNode->new('pre', join '', @data);

	my ($key, $val);
	while (($key, $val) = each %$r_prefs)
	{
		$node->set_attribute($key, $val);
	}

	return $node->build();
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

	my $node = XMLNode->new('code', join '', @data);

	my ($key, $val);
	while (($key, $val) = each %$r_prefs)
	{
		$node->set_attribute($key, $val);
	}

	return $node->build();
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

	my $node = XMLNode->new('strong', join '', @data);

	my ($key, $val);
	while (($key, $val) = each %$r_prefs)
	{
		$node->set_attribute($key, $val);
	}

	return $node->build();
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

	my $node = XMLNode->new('div', join '', @data);

	my ($key, $val);
	while (($key, $val) = each %$r_prefs)
	{
		$node->set_attribute($key, $val);
	}

	return $node->build();
}

sub img
{
	my ($this, %prefs) = @_;

	$this->_getprefs('img', \%prefs);

	my $node = XMLNode->new('img');

	my ($key, $val);
	while (($key, $val) = each %prefs)
	{
		$node->set_attribute($key, $val);
	}

	return $node->build();
}

sub email
{
	my ($this, $email) = @_;

	$email =~ s/@/<!-- \nbleh\n -->(at)<!-- \nbleh\n -->/;
	$email =~ s/\./<!-- \nbleh\n -->[dot]<!-- \nbleh\n -->/g;

	return $email;
}

return 1;
