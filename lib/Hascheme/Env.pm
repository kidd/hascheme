package Hascheme::Env;
use Data::Dump qw(dump ddx);
use Moose;
use Carp qw(confess);
use feature ':5.10';
use Data::Dumper;
use Ubigraph;
use List::MoreUtils qw(mesh);

has 'env' => (is =>'rw',
	      isa =>'HashRef',
	      default=>\&build_env);

has parent => (is =>'rw', isa =>'Hascheme::Env' );

has graph => (is => 'rw', isa => 'Ubigraph' , default => \&get_graph);

has node => (is => 'rw', isa => 'Ubigraph::Vertex', lazy_build => 1);

sub BUILD {
	my $self = shift;
	$self->graph->Edge($self->node,$self->parent->node ) if defined $self->parent;
}

sub DEMOLISH {
	my $self = shift;
	$self->node->remove;
}
sub _build_node {
  my $self = shift;
  my $n = $self->graph->Vertex();
  return $n;
}

sub recur { 
	my $vals = shift;	
	my @valors = @$vals;
	[$valors[0] , defined $valors[1] ? recur([@valors[1..$#valors]]) : 0 ] };


{
	my $graph;
	sub newgraph {
		$graph = new Ubigraph;
		return $graph;
	}
	sub get_graph {
		return $graph || newgraph();
	}
}

sub build_env {
	return {
		'write' => sub {my $a=shift;ddx $a},
		'+' => sub {my$acc=0;$acc+=$_ for@{$_[0]}; $acc},
		'nil' => 0,
		'*' => sub {my$acc=1;$acc*=$_ for@{$_[0]};$acc},
		'<' => sub { $_[0]->[0] < $_[0]->[1]},
		'>' => sub { $_[0]->[0] > $_[0]->[1]},
		'=' => sub { $_[0]->[0] == $_[0]->[1]},
		'cons' => sub { [$_[0]->[0] ,  $_[0]->[1]] },
		'car' => sub {  $_[0]->[0]->[0] },
		'cdr' => sub { $_[0]->[0]->[1] },
		'list' => \&recur,
		'-' => sub { my $args = shift; 
			return shift(@$args )* -1 if ( 1 == scalar @$args );
			my $a = shift @$args;
			$a -= $_ for @$args;
			$a },
		#'+' => Hascheme::Primitives::Sum->new ,

		'make-graph' => sub{ newgraph() },
		'make-vertex' => sub { my $a=shift; $a->[0]->Vertex()},
		'make-edge' => sub { my $a=shift;shift(@$a)->Edge(shift(@$a),shift @$a)},
		'clear-graph' => sub {my $a=shift; shift(@$a)->clear()},
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
	confess "Can't find item: $item ";
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
		$self->parent->set($key,$val) if defined $self->parent;
	}
}

sub apply {
	my $self = shift;
	my $op = shift;
	my $a = $op->(shift);
	return $a;
}

no Moose;
__PACKAGE__->meta->make_immutable;
1; # End of Env
