#!/usr/bin/perl -W

use strict;
use WASP;
use constant TRUE => 1;

print "Running die test\n";
eval
{
	my $w = WASP->new();
	$w->die(TRUE);
	$w->throw("test error message 1");
};

print "eval'd and got: $@\n";

print "Running log test\n";
system("cat /dev/null > errlog");

my $w = WASP->new();
$w->log("errlog");
$w->throw("test error message 2");
print "Log contains: ";
system("cat errlog");

print "\nRunning display test: ";
$w = WASP->new();
$w->display(TRUE);
$w->throw("test error message 3");

print "\nRunning handler test: ";

sub customerr
{
	my $msg = shift;
	print "Received error: $msg\n";
}

$w = WASP->new();
$w->handler(\&customerr);
$w->throw("test error message 4");

exit 0;
