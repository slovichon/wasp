package DBH;
# $Id$

use Exporter;
use DBI;
use strict;

our $VERSION = 0.1;
our @ISA = qw(Exporter);

our @EXPORT_OK = ();
push @EXPORT_OK, qw(DB_COL DB_ROW DB_ROWS DB_NULL);	# Result types
push @EXPORT_OK, qw(SQL_REG SQL_WILD SQL_REGEX);	# Escape types

our %EXPORT_TAGS = (
	all	=> [qw(DB_COL DB_ROW DB_ROWS DB_NULL
			SQL_REG SQL_WILD SQL_REGEX)],
	result	=> [qw(DB_COL DB_ROW DB_ROWS DB_NULL)],
	escape	=> [qw(SQL_REG SQL_WILD SQL_REGEX)],
);

use strict;

# Result types
use constant DB_COL	=> 1;
use constant DB_ROW	=> 2;
use constant DB_ROWS	=> 3;
use constant DB_NULL	=> 4;

# Not exported; good for DBH::COL, etc
use constant COL	=> 1;
use constant ROW	=> 2;
use constant ROWS	=> 3;
use constant NULL	=> 4;

# Escape types
use constant SQL_REG	=> 1;
use constant SQL_WILD	=> 2;
use constant SQL_REGEX	=> 3;

use constant TRUE	=> 1;
use constant FALSE	=> "";

sub new
{
	my ($class, %prefs) = @_;

	my $this = bless \%prefs, ref($class) || $class;

	if (exists $this->{user})
	{
		$this->{username} = $this->{pass};
		delete $this->{pass};
	}

	if (exists $this->{pass})
	{
		$this->{password} = $this->{pass};
		delete $this->{pass};
	}

	$this->throw("No DBI driver specified")		unless exists $this->{driver};
	$this->throw("No database specified")		unless exists $this->{database};
	$this->throw("No WASP instance specified")	unless exists $this->{wasp};

	# Build DSN
	my $dsn = "dbi:$this->{driver}:$this->{database}";

	$dsn .= "\@$this->{host}" if exists $this->{host};
	$dsn .=  ":$this->{port}" if exists $this->{port};

	# Build DBI::connect argument list
	my @args = ($dsn);
	if (exists $this->{username})
	{
		push @args, $this->{username};
		push @args, $this->{password} if exists $this->{password};
	}

	$this->{dbh} = DBI->connect(@args) or $this->throw("Cannot connect to database");

	return $this;
}

sub throw
{
	my ($this, $err) = @_;

	$err .=	"; DBI error: " . ($this->{dbh} && $DBI::err ? $DBI::errstr : "(none)") .
		"; Username: " . (exists $this->{username} && defined $this->{username} ? $this->{username} : "NONE") .
		"; Using a password? " . (exists $this->{password} ? "yes" : "no") .
		"; Host: " .     (exists $this->{host}     && defined $this->{host}     ? $this->{host}     : "NONE") .
		"; Port: " .     (exists $this->{port}     && defined $this->{port}     ? $this->{port}     : "(default)") .
		"; Driver: " .   (exists $this->{driver}   && defined $this->{driver}   ? $this->{driver}   : "NONE") .
		"; Database: " . (exists $this->{database} && defined $this->{database} ? $this->{database} : "NONE") .
		"; Available drivers: @{[ DBI->available_drivers(TRUE) ]}\n";

	# Infinite loop?
#	$this->{dbh}->disconnect();

	# We may not have been given a WASP object
	$this->{wasp}->throw($err) if $this->{wasp};
	die($err);
}

sub query
{
	my ($this, $sql, $type) = @_;

	$this->{sth} = $this->{dbh}->prepare($sql)	or $this->throw("Cannot prepare query; SQL: $sql");
	$this->{sth}->execute()				or $this->throw("Cannot execute query; SQL: $sql");

	if ($type == DBH::DB_COL)
	{
		my $field = ($this->{sth}->fetchrow)[0];
		$this->{sth}->finish();
		return $field;

	} elsif ($type == DBH::DB_ROW) {

		my %row = ();
		@row{@{ $this->{sth}->{NAME} }} = $this->{sth}->fetchrow;
		$this->{sth}->finish();
		return %row;

	} elsif ($type == DBH::DB_ROWS) {

		$this->{rows} = $DBI::rows;
		return $DBI::rows;

	} elsif ($type == DBH::DB_NULL) {

		my $rows = $DBI::rows;
		$this->{sth}->finish();
		return $rows;
	} else {
		$this->throw("Invalid query type; type: $type");
	}
}

sub fetch_row
{
	my $obj = shift;
	my %row = ();

	unless ($obj->{"rows"}--)
	{
		$obj->{"sth"}->finish();
		return;
	}

	@row{@{$obj->{"sth"}->{"NAME"}}} = $obj->{"sth"}->fetchrow;

	return %row;
}

sub prepare_str
{
	my ($this, $str, $type) = @_;

	if ($type == DBH::SQL_REG)
	{
		$str =~ s/['"\\]/\\$0/g;

	} elsif ($type == DBH::SQL_WILD) {

		$str =~ s/['"\\_%]/\\$0/g;

	} elsif ($type == DBH::SQL_REGEX) {

		#$str =~ s/['"\\^\$()\[\]{}+*?.]/\\$0/g;
		$str = quotemeta($str);
	} else {
		$this->throw("Invalid escape type; type: $type");
	}

	return $str;
}

=comment
sub DESTROY
{
	my $this = shift;
	$this->{dbh}->disconnect();
	return;
}
=cut

sub last_insert_id
{
	my $this = shift;
	return $this->{sth}->{insertid};
}

return 1;
