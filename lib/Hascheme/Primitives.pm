package Hascheme::Primitives;
use Moose;
use autobox;
use autobox::Core;
use Perl6::Say;
use Hascheme::Primitives::Sum;

sub apply {
	die "you should never be called";
}

no Moose;
__PACKAGE__->meta->make_immutable;
1; # End of Package

