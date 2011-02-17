#!perl

use Test::More ;

BEGIN {
	use_ok('Moose');
	use_ok( 'Hascheme' );
	use_ok( 'Hascheme::Env' );
	use_ok( 'Hascheme::Evaluator' );
	use_ok( 'Hascheme::Reader' );
	use_ok( 'Hascheme::InPort' );
}

my $ip = Hascheme::InPort->new;
$ip->getline
is($ip->next_token , '', 'creation ok');


done_testing;
