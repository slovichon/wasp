package PHP::Serialize;
# $Id$

use Exporter;
use strict;
use warnings;

our @ISA = qw(Exporter);
our @EXPORT = qw(serialize unserialize);
our @EXPORT_OK = qw(serialize unserialize);
our %EXPORT_TAGS = (
	all => [qw(serialize unserialize)],
);

sub serialize {
	my $str = shift;
	my $ref = ref($str);
	my $serialized;
	my $temp = "";

	if ($ref eq "SCALAR") {
		$temp = $$str;
		$temp =~ s/"/\\"/g;
		$serialized = "s:" . length($temp) . qq!:"$temp"!;
	} elsif ($ref eq "ARRAY") {
		my ($count) = 0;
		$serialized = "a:" . scalar(@$str) . ":{";
		foreach (@$str)
		{
			$serialized .= "i:$count;" . serialize(\$_) . ";";
			$count++;
		}
		$serialized .= "}";
	} elsif ($ref eq "HASH") {
		my ($count) = 0;
		$serialized = "a:" . scalar(keys(%$str)) . ":{";
		foreach (keys %$str) {
			$serialized .= serialize(\$_) . ";" . serialize(\$str->{$_}) . ";";
		}
		$serialized .= "}";
	} else {
		my $msg = "Unable to serialize object of type $ref";
		$msg .= " (did you forget to pass a reference?)\n" unless $ref;
		warn $msg;
	}
	return $serialized;
}

sub unserialize {
	my $serialized = shift;
	my $length = 0;
	my $unserialized = "";
	my @parts = ();
	my $i = 0;
	if ($serialized =~ /^i:(\d+)$/)
	{
		$unserialized = $1;
		return \$unserialized;
	} elsif ($serialized =~ /^s:\d+:"(.*[^\\]|)"$/) {
		$unserialized = $1;
		$unserialized =~ s/\\"/"/;
		return \$unserialized;
	} elsif ($serialized =~ /^a:(\d+):{(.*)}$/s) {
		$serialized = $2;
		$length = $1;
		@$unserialized = ();
		@parts = split ";",$serialized;
		$i = -1;
		foreach (@parts) {
			$i++;
			next if (/^i:\d+$/ || /^s:\d+:"(.*[^\\]|)"$/);
#			if (//)
		}
		$i = 0;
		foreach (@parts) {
			$unserialized->[$i++] = unserialize($_);
		}
		return $unserialized;
	}
}

1;
