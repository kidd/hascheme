#!perl -T

use Test::More ;

BEGIN {
	#use_ok( 'Hascheme' );
	use_ok( 'Hascheme::Env' );
	use_ok( 'Hascheme::Evaluator' );
	use_ok( 'Hascheme::Reader' );
}

diag( "Testing Hascheme $Hascheme::VERSION, Perl $], $^X" );

done_testing;
