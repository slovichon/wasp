#!/usr/bin/perl -W

use strict;
use AutoConstantGroup;

my $g = AutoConstantGroup->new;

$g->add("A");
$g->add("B");
$g->add("C");
$g->add("D");
$g->add("E");

printf "%05b\n", A();
printf "%05b\n", B();
printf "%05b\n", C();
printf "%05b\n", D();
printf "%05b\n", E();

exit 0;
