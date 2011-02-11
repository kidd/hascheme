package Hascheme::Graph::Ubi;
use Ubigraph;
use MooseX::Singleton;
use Data::Dumper;

has graph => (is =>'rw', isa =>'Ubigraph', default => sub{ Ubigraph->new});

1;





1; # End of Hascheme::Graph::Ubi;

