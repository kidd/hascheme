#!perl -T

use Test::More ;

BEGIN {
	use_ok( 'Prova' );
}

diag( "Testing Hascheme $Hascheme::VERSION, Perl $], $^X" );

done_testing;
