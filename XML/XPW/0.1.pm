package XML::XPW;
# $Id$

use XML::Node;
use strict;

our $VERSION = 0.1;

sub new
{
	my ($class) = @_;
	return bless {
	}, ref($class) || $class;
}

sub parse
{
	my ($this, $xml) = @_;
	# Strip meta information
	$xml =~ s/^\s*<\?\s*xml[^>]*\?>//s;
	# Valid identifer
	my $vid = qr![a-zA-Z0-9-_]+!;
	if (
		($name, @attrs) = ($xml =~ m!
						<			# Open tag
						($vid)			# Tag Identifier
						(			# Save attributes
							\s*		# Whitespace
							$vid		# Attribute identifer
							\s*		# Whitespace
							=		# Equals
							\s*		# Whitespace
							(?:
								".*?"	# "Quoted value"
								|	# Or
								'.*?'	# 'Quoted value'
							)
						)*			# Zero or more attributes
						\s*			# Whitespace
						>			# Close tag
						(.*)			# Value (slurp as much as possible)
						</\1>			# Match ending tag
					!x))
	{
		my $value = $+;
	} elsif (($name, @attrs) = ($xml =~ m!
						<
						($vid)
						\s*
						()?
						\s*
						/>
					!x)) {
	} else {
		$this->{wasp}->throw("Malformed input; input: $xml");
	}
}

sub generate
{
	my ($this, $struct, $name) = @_;
	my $node;
}

=comment
<?xml version="1.0" ?>
<foo-bar bar-bar="glarch">
	<test foo-bar="glarch" />
	<foob name="glarch">
		hi
		<bleh hi="bye" />
		there
		<eat food="yes" />
		buddy
	</foob>
	<ass>hold</ass>
</foo-bar>



$a = {
	"foo-bar" => {
		attrs => { "bar-bar" => "glarch"},
		value => [
		]
	}
};












=cut

return 1;
