package Hascheme::Primitives;
use Moose;
use feature ':5.10';
use Hascheme::Primitives::Sum;

sub apply {
	die "you should never be called";
}

no Moose;
__PACKAGE__->meta->make_immutable;
1; # End of Package

