#!perl -T

use Test::More ;

BEGIN {
	use_ok( 'Hascheme::Reader' );
}

diag( "Testing Hascheme::Reader $Hascheme::VERSION, Perl $], $^X" );

my $a = Hascheme::Reader->new;
is(@{$a->parse('()')},0, 'empty list');

#is(@{$a->parse('(+ 3 2)')} , 'empty list');
done_testing;
