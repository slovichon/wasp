package OF::Text;
# $Id$

use OF;
use strict;

our @ISA = qw(OF);

sub new
{
	my ($class,@args) = shift;
	my $this = $class->SUPER::new(@args);

	# Child-specific attributes
	$this->{__PACKAGE__} = {
				tablevel => 0,	# Indentation level
				tabwidth => 8,	# Indentation width
				width => 80,	# Terminal width
			};

	return $this;
}

sub _tabwidth
{
	my $this = shift;
	return $this->{__PACKAGE__}{tabwidth};
}

sub _width
{
	my $this = shift;
	return $this->{__PACKAGE__}{width};
}

sub _tablevel
{
	my $this = shift;
	return $this->{__PACKAGE__}{tablevel};
}

sub _inctablevel
{
	my $this = shift;
	$this->{__PACKAGE__}{tablevel}++;
	return;
}

sub _dectablevel
{
	my $this = shift;
	$this->{__PACKAGE__}{tablevel}--;
	return;
}

=comment
sub form;
sub form_start;
sub form_end;
sub fieldset;
sub _gen_rand_id;
sub input;
=cut

#sub table;
#sub table_end;
#sub table_start;
#sub table_row;
#sub table_head;

sub p
{
	my ($this,@data) = @_;
	return "\n".join('', @data)."\n";
}

#sub link;

sub hr
{
	return "--------------------------\n";
}

sub br
{
	return "\n";
}

sub list_start
{
	return "\n";
}

sub list_end
{
	return "\n";
}

sub list_item
{
	my ($this,$item) = @_;
	return "- $item\n";
}

#sub list;

sub header
{
	my ($this,$data) = @_;
	return "\U$header\n\n";
}

sub emph
{
	my ($this,@data) = @_;
	return join '', @data;
}

sub pre
{
	my ($this,@data) = @_;
	return join '', @data;
}

sub code
{
	my ($this,@data) = @_;
	return join '', @data;
}

sub strong
{
	my ($this,@data) = @_;
	return join '', @data;
}

sub div
{
	my ($this,@data) = @_;
	return "\n".join(@data)."\n";
}

#sub img;

sub email
{
	my ($this,$data) = @_;
	return $data;
}

return 1;
