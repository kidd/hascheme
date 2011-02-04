package Hascheme::Primitives::Sum;
use Moose;
use feature ':5.10';
use List::Util ('sum','reduce');

extends 'Hascheme::Primitives';

sub apply {
	my $self = shift;
	my $c = shift;
	#reduce { $a + $b } 0, @$c;
	sum @$c;
}


no Moose;
__PACKAGE__->meta->make_immutable;
1; # End of Package

