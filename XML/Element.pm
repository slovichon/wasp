package XML::Element;
# $Id$

use strict;

our $VERSION = 0.1;

sub new
{
	my ($class,$name,$value) = @_;
	return bless {
			name => $name,
			value => $value,
			attrs => {},
		}, ref($class) || $class;
}

sub set_value
{
	my ($this,$value) = @_;
	$this->{value} = $value;
	return;
}

sub append_value
{
	my ($this,$value) = @_;
	if (defined $this->{value})
	{
		$this->{value} .= $value;
	} else {
		$this->{value} = $value;
	}
	return;
}

sub get_value
{
	my $this = shift;
	return $this->{value}
}

sub build
{
	my $this = shift;
	my $out = "<$this->{name}";

	my ($key,$val);
	while (($key,$val) = each %{$this->{attrs}})
	{
		$out .= qq( $key="$val");
	}

	if (defined $this->{value})
	{
		$out .= ">$this->{value}</$this->{name}>";
	} else {
		$out .= " />";
	}

	return $out;
}

sub set_attribute
{
	my ($this,$name,$value) = @_;
	$this->{attrs}{$name} = $value;
	return;
}

sub get_attribute
{
	my ($this,$name) = @_;
	return $this->{attrs}{$name};
}

return 1;
