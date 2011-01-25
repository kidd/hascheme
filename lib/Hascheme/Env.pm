package Hascheme::Env;
use Data::Dump qw(dump ddx);
use Moose;
use autobox;
use autobox::Core;
use feature ':5.10';
use Data::Dumper;
use List::MoreUtils qw(mesh);


has 'env' => (is =>'rw',
			  isa =>'HashRef',
			  default=>\&build_env);

has parent => (is =>'rw', isa =>'Hascheme::Env' );
		  
sub build_env{
	return {
		'write' => sub {my $a=shift;say "@$a"},
		'+' => sub {my$acc=0;$acc+=$_ for@{$_[0]};$acc},
		'nil' => 0,
		'*' => sub {my$acc=1;$acc*=$_ for@{$_[0]};$acc},
		'<' => sub { $_[0]->[0] < $_[0]->[1]},
		'>' => sub { $_[0]->[0] > $_[0]->[1]},
		'=' => sub { $_[0]->[0] == $_[-1]->[1]},
		'-' => sub { my $args = shift; 
			return shift(@$args )* -1 if ( 1 == scalar @$args );
			my $a = shift @$args;
			$a -= $_ for @$args;
			$a },
		#'+' => Hascheme::Primitives::Sum->new ,
	}
}

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

sub define {
	my ($self, $key, $val) = @_ ;
	$self->env->{$key} = $val;
}

sub set {
	my ($self, $key, $val ) = @_;
	if (exists $self->env->{$key}) {
		$self->env->{$key} = $val;
	}
	else {
		$self->parent->set($key,$val) if $self->parent;
	}
}

sub apply {
	my $self = shift;
	my $op = shift;
	#say "apply $op";
	$op->(shift);
}

no Moose;
__PACKAGE__->meta->make_immutable;
1; # End of Env
