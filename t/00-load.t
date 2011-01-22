#!perl -T

use Test::More tests => 1;

BEGIN {
	use_ok( 'Hascheme' );
}

diag( "Testing Hascheme $Hascheme::VERSION, Perl $], $^X" );
