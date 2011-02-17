package Hascheme::Symbol;
use Moose;
use feature ':5.10';

has symb => (is =>'ro', isa =>'Str');

no Moose;
__PACKAGE__->meta->make_immutable;
1; # End of Hascheme::Symbol;

