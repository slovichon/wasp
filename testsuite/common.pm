sub _ {
	my $ret = shift;
	if ($ret) {
		print "\033[1;40;32mTest succeeded\033[1;0;0m\n\n";
	} else {
		die "\033[1;40;31mTest failed!\033[1;0;0m\n";
	}
}

sub test {
	print "\033[1;40;34m", @_, "\033[1;0;0m\n";
}

sub esc {
	my $arg = join '', shift;
	$arg =~ s/\n/\\n/g;
	return $arg;
}

1;
