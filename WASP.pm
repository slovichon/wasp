package WASP;
# $Id$

use strict;
use constant FALSE => 0;

our $VERSION = 0.1;

sub new
{
	my $class = shift;

	return bless {
		"die"		=> FALSE,
		"log"		=> undef,
		display		=> FALSE,
		handler		=> undef,
		}, ref($class) || $class;
}

sub die
{
	my ($this, $die) = @_;
	$this->{"die"} = $die if defined $die;
	return $this->{"die"};
}

sub log
{
	my ($this, $log) = @_;
	$this->{"log"} = $log if defined $log;
	return $this->{"log"};
}

sub display
{
	my ($this, $display) = @_;
	$this->{display} = $display if defined $display;
	return $this->{display};
}

sub handler
{
	my ($this, $handler) = @_;
	$this->{handler} = $handler if defined $handler;
	return $this->{handler};
}

sub throw
{
	my ($this, $err) = @_;
	my ($pkg, $file, $line) = caller;

	my ($modpkg,$modline) = ($pkg,$line);

	# Backtrace through subs/modules/files
	for (my $i = 0; $pkg ne "main" || !defined $pkg; $i++)
	{
		($pkg, $file, $line) = caller $i;
	}

	my $errmsg = "WASP Error: " . ($err || "(empty)");

	unless ($modpkg eq "main")
	{
		$errmsg .= "; Module: $modpkg:$modline";
	}

	$errmsg .=	"; OS Error: $!" if $!;
	$errmsg .=	"; Backtrace: $file:$line" .
			"; Date: " . localtime(time) .
			"\n";

	if (defined $this->{"log"})
	{
		local *F;
		if (open F, ">> " . $this->{"log"})
		{
			print F $errmsg;
			close F;
		} else {
			$errmsg .= "Could not log error; file: " . $this->{"log"} . "; OS Error: $!\n";
		}
	}

	print $errmsg if $this->{display};

	# Error message complete, now figure out
	# what to do with it
	if ($this->{"die"})
	{
		# Perhaps they want to catch die() in an eval?
		# Who knows
		CORE::die($errmsg);
	} elsif (defined $this->{handler}) {
		@_ = ($errmsg);
		goto &{$this->{handler}};
	}

	return;
}

return 1;
