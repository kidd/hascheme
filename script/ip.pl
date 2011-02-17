#!/usr/bin/perl

#use rlib;
use FindBin;
use lib "$FindBin::Bin/../lib";

use feature ':5.10';

use Data::Dumper;
use Getopt::Long;
use Pod::Usage;
use strict;
use warnings;
use Hascheme::InPort;

sub man {#{{{
	pod2usage(
		-exitval => 1,
		-verbose => 2
	);
}#}}}

# main
GetOptions (
	'man' => \&man,
);

my $ip = Hascheme::InPort->new;
while (1) {
	say $ip->next_token;
	print "dilo> ";
	<STDIN>;
}


__END__#{{{

=head1 NAME


=head1 SEE ALSO


=head1 SYNOPSIS


=head1 DESCRIPTION

=head1 AUTHOR

Raimon Grau Cuscó <raimonster@gmail.com>

=head1 Credits

=cut

# vim: set tabstop=4 shiftwidth=4 foldmethod=marker : ###}}}
