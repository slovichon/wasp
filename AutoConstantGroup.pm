# $Id$
package AutoConstantGroup;

use strict;
our $VERSION = 0.1;

sub new
{
	my ($class) = @_;
	return bless {
		start 	=> 0,
		pkg	=> scalar caller,
	}, ref($class) || $class;
}

sub add
{
	no strict 'refs';
	my ($this, $name) = @_;
	
	*{"$this->{pkg}::$name"} = sub () {
		return (1<<$this->{start}++);
	};
}

return 1;
