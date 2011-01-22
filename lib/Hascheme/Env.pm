package Hascheme::Env;
use Data::Dump qw(dump ddx);
use Moose;
use autobox;
use autobox::Core;
use feature ':5.10';
use Data::Dumper;
use Hascheme::Primitives;
use List::MoreUtils qw(mesh);


has 'env' => (is =>'rw',
			  isa =>'HashRef');

has parent => (is =>'rw', isa =>'Hascheme::Env' );
		  
		  
sub find {
	my $self = shift;
	my $item = shift;
	if (exists $self->env->{$item}) {
		return $self->env->{$item};
	}
	else {
		return $self->parent->find($item) if $self->parent;
	}
	die "Can't find item: $item ";
}

sub apply {
	ddx @_;
	my $self = shift;
	my $op = shift;
	say "apply $op";
	$op->(shift);
}

no Moose;
__PACKAGE__->meta->make_immutable;
1; # End of Env
