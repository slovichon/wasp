package WASP;

use strict;

our $VERSION = "0.1";

sub throw
{
	my $err = shift;
	my ($pkg, $file, $line) = caller;

	my ($modpkg,$modline) = ($pkg,$line);

	for (my $i = 0; $pkg ne "main" || !defined $pkg; $i++)
	{
		($pkg, $file, $line) = caller $i;
	}

	my $errmsg = "WASP Error: $err";
	
	unless ($modpkg eq "main")
	{
		$errmsg .= "; Module: $modpkg:$modline";
	}

	$errmsg .=	"; Backtrace: $file:$line" .
			"; Date: " . localtime(time) .
			"; OS Error: $!\n";
	
	die($errmsg);
}

return 1;
