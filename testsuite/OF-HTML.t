#!/usr/bin/perl -W
# $Id$

use WASP;
use OF::HTML;
use CGI;

use strict;

my $w = WASP->new();
my $of = OF::HTML->new($w,{
				form=>{
					method=>"post",
					enctype=>"application/x-www-form-urlencoded",
					action=>CGI::url(-absolute=>1)
				},
				header=>{size=>3}
			});

print $of->header({class=>"foo"}, "hi"),"\n",
	$of->link(href=>"this is the href", value=>"this is the val"), "\n";

__END__

print	"Small tests:\n",
	$of->p("hello there"), "\n",
	$of->p({class=>"ptst"}, "another p test"), "\n",
	$of->link(href=>"this is the href", value=>"this is the val"), "\n",
	$of->hr, "\n",
	$of->br, "\n",
	$of->header({size=>2}, "hi"), "\n",
	$of->emph("emphasized"), "\n",
	$of->pre("preformatted"), "\n",
	$of->code("super CODE"), "\n",
	$of->strong("strength"), "\n",
	$of->div({align=>"center"}, "page division"), "\n",
	$of->img(src=>"hi.png", alt=>"hi"),
	$of->email("email\@test.com"),
	"\n-----------------------\n";

print "\nForm test:\n";
print $of->form
	(
		{method=>"get"}, "\n\t",
		$of->fieldset(
		$of->input(type=>"text", name=>"fieldfoo", label=>"foo"), "\n\t\t",
		$of->input(type=>"textarea", name=>"hi", rows=>8, cols=>45), "\n\t\t",
		$of->input(type=>"checkbox", name=>"hi"), "\n\t\t",
		$of->input(type=>"select", name=>"myslct", options=>{b=>"B", a=>"A"}, value=>"a"), "\n\t\t",
		$of->input(type=>"submit", value=>"press me"), "\n\t",), "\n"
	);

print "\n-------------------------\n";

print "Table test:\n";
print $of->table
	(
		{class=>"foo", border=>0, cols=>[{width=>1},{width=>2},{width=>3},{width=>4},{width=>5}]}, "\n",
		$of->table_head({colspan=>4, value=>"foo"}, "bar"), "\n",
		$of->table_row("foo", {value=>"bar"}, {colspan=>3, value=>"glarch"}), "\n",
	);

print "\n-------------------------\n";

print "List test:\n";
print $of->list
	(
		OF::LIST_UN,
		qw(a b c d e)
	);

print "\n";

exit 0;
