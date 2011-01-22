package Hascheme::Env;
use Data::Dump qw(dump ddx);
use Moose;
use autobox;
use autobox::Core;
use Perl6::Say;
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
	die "no trobbo $item";
	return undef;

}

sub set {
	my ($self, $key, $val ) = @_;

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
