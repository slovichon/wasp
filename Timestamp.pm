package Timestamp;
# $Id$

use POSIX qw();
#use Timestamp::Diff;
use strict;

our $VERSION = 0.1;

#use overload
#	'+'	=> \&op_add,
#	'+='	=> \&op_addeq,
#	'-'	=> \&op_sub,
#	'-='	=> \&op_subeq,
#	'<'	=> \&op_lt,
#	'>'	=> \&op_gt,
#	'<='	=> \&op_le,
#	'>='	=> \&op_ge,
#	'=='	=> \&op_eq,
#	'<=>'	=> \&op_cmp,
#	'cmp'	=> \&op_cmp,
#	'""'	=> \&op_str,
#	'='	=> \&op_dup;

sub new
{
	my $class = shift;

	# Create new object
	my $this = bless {
			usec	=> undef,
			sec	=> undef,
			min	=> undef,
			hr	=> undef,
			mon	=> undef,
			day	=> undef,
			yr	=> undef,
			tz	=> undef,
		}, ref($class) || $class;

	# Clone from previous object
	if (ref($class))
	{
		#my ($k, $v);
		#while (($k, $v) = each(%$class))
		#{
		#	$this->{$k} = $v;
		#}
		%$this = %$class;
	} elsif (defined($_[0])) {
		# YYYY MM DD HH MM SS (14)
		if ($_[0] =~ /^\d{14}$/)
		{
			$this->set_string($_[0]);

		# Unix timestamp
		} elsif ($_[0] =~ /^\d+$/) {
			$this->set_unix($_[0]);

		# Verbose form
		} elsif (@_ > 1) {
			$this->set(@_);
		}
	} else {
		# Unrecognized; set to current time
		$this->set_now;
	}

	return $this;
}

sub set_string
{
	my ($this, $string) = @_;
	return undef unless $string && $string =~ /^(\d\d\d\d)(\d\d)(\d\d)(\d\d)(\d\d)(\d\d)$/;
	$this->set(
		year	=> $1,
		month	=> $2,
		day	=> $3,
		hour	=> $4,
		min	=> $5,
		sec	=> $6,
	);
	return $this;
}

sub set_unix
{
	my ($this, $ts) = @_;
	return undef unless $ts && $ts =~ /^\d+$/;
	my ($sec, $min, $hr, $day, $mon, $yr) = localtime($ts);
	$this->set(
		sec	=> $sec,
		min	=> $min,
		hr	=> $hr,
		day	=> $day,
		mon	=> $mon,
		yr	=> $yr,
	);
	return $this;
}

=comment
$ts = Timestamp->new();
$ts->set(month=>4);
=cut
sub set
{
	my ($this, %parts) = @_;

	my %aliases = (
		usecs		=> "usec",	ms		=> "usec",
		millisec	=> "usec",	millisecs	=> "usec",
		milliseconds	=> "usec",
		secs		=> "sec",	second		=> "sec",
		mins		=> "min",	minute		=> "min",
		hrs		=> "hr",	hours		=> "hr",
		hour		=> "hr",
		days		=> "day",
		month		=> "mon",
		yrs		=> "yr",	years		=> "yr",
		year		=> "yr",
		timezone	=> "tz",
	);

	# Expand aliases
	my ($k, $v);
	while (($k, $v) = each(%aliases))
	{
		if (exists $parts{$k})
		{
			$parts{$v} = $parts{$k};
			delete $parts{$k};
		}
	}

	#$this->{$_} = $parts{$_} foreach qw(usec sec min hr mon day yr tz);
	#%$this = %parts;
	$this->usec($parts{usec}) if exists $parts{usec};
	$this->sec ($parts{sec})  if exists $parts{sec};
	$this->min ($parts{min})  if exists $parts{min};
	$this->hr  ($parts{hr})	  if exists $parts{hr};
	$this->day ($parts{day})  if exists $parts{day};
	$this->mon ($parts{mon})  if exists $parts{mon};
	$this->yr  ($parts{yr})	  if exists $parts{yr};
	$this->tz  ($parts{tz})	  if exists $parts{tz};

	return;
}
=comment
sub _fix
{
	my $this = shift;

	$this->{min}	+= int($this->{sec}/60);
	$this->{sec}	%= 60;

	$this->{hr}	+= int($this->{min}/60);
	$this->{min}	%= 60;

	$this->{day}	+= int($this->{hr}/24);
	$this->{hr}	%= 24;

	my ($days,$isleap);
	my @dpm = (
		[31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31],
		[31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31],
	);

	do
	{
		$this->{yr}	+= int($this->{mon}/12);
		$this->{mon}	%= 12;

		$isleap = $this->{yr};

		$days = $dpm[$isleap][$this->{mon}];

		$this->{mon}++ if $this->{day} > $days;
		$this->{day}	-= $days;

	} while ($this->{day} > $days);

	return;
}
=cut
sub format
{
	my ($this, $fmt) = @_;

	$fmt = "%F %r" unless $fmt;

	return POSIX::strftime($fmt,
		$this->{sec}, $this->{min}, $this->{hr},
		$this->{day}, $this->{mon} - 1, $this->{yr} - 1900);
}

sub set_now
{
	my $this = shift;
	my ($sec, $min, $hr, $day, $mon, $yr) = localtime(time());

	# We should be able to trust localtime()...
#	$this->sec($sec);
#	$this->min($min);
#	$this->hr($hr);
#	$this->day($day);
#	$this->mon($mon);
#	$this->yr($yr);

	$this->{sec} = $sec;
	$this->{min} = $min;
	$this->{hr}  = $hr;
	$this->{day} = $day;
	$this->{mon} = $mon + 1;
	$this->{yr}  = $yr + 1900;

	# Do previous timezone translation?
	$this->{tz}  = POSIX::strftime("%Z", localtime(time()));

	return $this;
}

*set_current = \&set_now;

# Accessors
sub usec { @_ == 2 ? $_[0]->{usec} = $_[1] : $_[0]->{usec} }
sub sec	 { @_ == 2 ? $_[0]->{sec}  = $_[1] : $_[0]->{sec}  }
sub min	 { @_ == 2 ? $_[0]->{min}  = $_[1] : $_[0]->{min}  }
sub hr	 { @_ == 2 ? $_[0]->{hr}   = $_[1] : $_[0]->{hr}   }
sub day	 { @_ == 2 ? $_[0]->{day}  = $_[1] : $_[0]->{day}  }
sub mon	 { @_ == 2 ? $_[0]->{mon}  = $_[1] : $_[0]->{mon}  }
sub yr	 { @_ == 2 ? $_[0]->{yr}   = $_[1] : $_[0]->{yr}   }
sub tz	 { @_ == 2 ? $_[0]->{tz}   = $_[1] : $_[0]->{tz}   }

# Aliases
*usecs		= \&usec;
*ms		= \&usec;
*millisec	= \&usec;
*millisecs	= \&usec;
*milliseconds 	= \&usec;
*secs		= \&sec;
*second		= \&sec;
*mins		= \&min;
*minute		= \&min;
*hrs		= \&hr;
*hours		= \&hr;
*hour		= \&hr;
*days		= \&day;
*month		= \&mon;
*yrs		= \&yr;
*years		= \&yr;
*year	 	= \&yr;
*timezone	= \&tz;

sub get_string
{
	my $this = shift;

	return sprintf("%04d" . "%02d" x 5,
			$this->yr, $this->mon, $this->day,
			$this->hr, $this->min, $this->sec);
}

sub get_unix
{
	my $this = shift;

	return POSIX::mktime(
		$this->sec, $this->min, $this->hr-1,
		$this->day, $this->mon-1, $this->yr-1900);
}

=comment
my $ts = Timestamp->new(sec=>4, min=>6, ...);
$ts += Timestamp::Diff->new(day=>1);
=cut

=comment
	sub op_add
	{
		my ($obj,$arg) = @_;

		if (ref($arg) eq ref($obj))
		{
			$obj->{$_} += $arg->{$_} foreach (@_fields);
		} else {
			# Else treat it as seconds
			$obj->{second} += $arg;
		}

		return;
	}

	sub op_addeq
	{
	}

	sub op_lt
	{
		my ($obj,$arg)	= @_;
		my $op		= $obj->new($arg);

		foreach (@_fields)
		{
			return $obj->$_ - $op->$_ < 0 ? 1 : 0 if $obj->$_ - $op->$_;
		}

		# Must be equal, so $obj is not less than $op
		return 0;
	}

	sub op_le
	{
		return &less_than or &eq;
	}

	sub op_eq
	{
		my ($obj,$arg)	= @_;
		my $op		= $obj->new($arg);
		my $ret		= 0;

		# Tally up how many are the same
		foreach (@_fields)
		{
			$ret .= $obj->$_ == $op->$_ ? 1 : 0;
		}

		# They're equal if all are the same
		return $ret == @_fields;
	}

	sub op_gt
	{
		my ($obj,$arg) = @_;

		return $arg->less_than($obj);
	}

	sub op_ge
	{
		return &greater_than or &eq;
	}
}
=cut
return 1;
