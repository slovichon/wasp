#!/usr/bin/perl -W
# $Id$

use strict;
use XML::Element;

print "Creating new XML::Element\n";
my $n = XML::Element->new("a", "welcome");

print "Setting attribute href=http://www.yahoo.com/\n";
$n->set_attribute("href", "http://www.yahoo.com/");

print "Retrieving attribute href=", $n->get_attribute("href"), "\n";

print "Value: ", $n->get_value(), "\n";

print "Setting new value Hello World\n";
$n->set_value("Hello");
$n->append_value(" World");

print "Dumping element: ", $n->build(), "\n";

print "-------------------------\n";

print "Creating new br element: ", XML::Element->new("br")->build, "\n";

print "Creating new p element: ", XML::Element->new("p", "this is a para")->build, "\n";

print "Testing append value: ";

$n = XML::Element->new('a');
$n->append_value("val");
print $n->build, "\n";

exit 0;
