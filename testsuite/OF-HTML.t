#!/usr/bin/perl -W
# $Id$

use WASP;
use OF::HTML;
use CGI;

use common;

use strict;

my $w = WASP->new;
my $of = OF::HTML->new($w, {
	textarea=>{rows=>6, cols=>40},
	form=>{
		method=>"post",
		enctype=>"application/x-www-form-urlencoded",
		action=>CGI::url(-absolute=>1)
	},
	header=>{size=>3}
});

my ($a, $b, $c, $d, $e);

test "email";
$a = $of->email('foo@bar.net');
print "foo\@bar.net yields: ", esc($a), "\n";
_ $a eq qq{<script type="text/javascript">
<!--
document.write('<a href="mailto:');document.write('&#102;&#111;&#111;');document.write('&#64;');document.write(['&#98;&#97;&#114;', '&#110;&#101;&#116;'].join('&#46;'));document.write('">');document.write('&#102;&#111;&#111;');document.write('&#64;');document.write(['&#98;&#97;&#114;', '&#110;&#101;&#116;'].join('&#46;'));document.write('</a>');// --></script><noscript>&#102;&#111;&#111;<!-- 
bleh
 -->(at)<!-- 
bleh
 -->&#98;&#97;&#114;<!-- 
bleh
 -->[dot]<!-- 
bleh
 -->&#110;&#101;&#116;</noscript>};

test "select input";
$a = $of->input(type=>"select", options=>{
	1=>1, 2=>2, 3=>3, 4=>4, 5=>5, 6=>6,
	7=>7, 8=>8, 9=>9, 10=>10, 11=>11, 12=>12
	}, multiple=>"multiple", size=>5, order=>[
	1..12], value=>1);
print $a, "\n";
_ $a eq qq{<select multiple="multiple" size="5"><option selected="selected" value="1">1</option><option value="2">2</option><option value="3">3</option><option value="4">4</option><option value="5">5</option><option value="6">6</option><option value="7">7</option><option value="8">8</option><option value="9">9</option><option value="10">10</option><option value="11">11</option><option value="12">12</option></select>};


test "header, preference arguing";
$a = $of->header({class=>"foo"}, "hi");
print $a, "\n";
_ $a eq qq{<h3 class="foo">hi</h3>};

test "link, complex";
$a = $of->link(href=>"this is the href", value=>"this is the val");
print $a, "\n";
_ $a eq qq{<a href="this is the href">this is the val</a>};


test "p, simple";
$a = $of->p("hello there");
print $a, "\n";
_ $a eq "<p>hello there</p>";

test "p, complex";
$a = $of->p({class=>"ptst"}, "another p test");
print $a, "\n";
_ $a eq qq{<p class="ptst">another p test</p>};


test "link, simple";
$a = $of->link("VAL", "HREF");
print $a, "\n";
_ $a eq qq{<a href="HREF">VAL</a>};

test "hr";
$a = $of->hr;
print $a, "\n";
_ $a eq "<hr />";

test "br";
$a = $of->br;
print $a, "\n";
_ $a eq "<br />";

test "header, complex";
$a = $of->header({size=>2}, "hi");
print $a, "\n";
_ $a eq qq{<h2>hi</h2>};

test "emph, simple";
$a = $of->emph("emphasized");
print $a, "\n";
_ $a eq "<em>emphasized</em>";

test "pre, simple";
$a = $of->pre("preformatted");
print $a, "\n";
_ $a eq "<pre>preformatted</pre>";

test "code, simple";
$a = $of->code("super CODE");
print $a, "\n";
_ $a eq "<code>super CODE</code>";

test "strong, simple";
$a = $of->strong("strength");
print $a, "\n";
_ $a eq "<strong>strength</strong>";

test "div, complex";
$a = $of->div({align=>"center"}, "page division");
print $a, "\n";
_ $a eq qq{<div align="center">page division</div>};

test "img";
$a = $of->img(src=>"hi.png", alt=>"hi");
print $a, "\n";
_ $a eq qq{<img alt="hi" src="hi.png" />};

__END__

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
