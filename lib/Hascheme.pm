package Hascheme;
use Moose;
use autobox;
use autobox::Core;
use feature ':5.10';
use Data::Dump qw(dump ddx);
use Hascheme::Env;
use Hascheme::Evaluator;
use Hascheme::Reader;

has reader => ( is =>'ro',
				isa =>'Hascheme::Reader',
				default=>sub {Hascheme::Reader->new});

has evaluator => (is =>'ro', 
				  isa =>'Hascheme::Evaluator',
				  default=>sub{Hascheme::Evaluator->new});

has env => (is =>'ro', isa =>'Hascheme::Env', default=>sub{Hascheme::Env->new});

sub build_env {
	return {
		'write' => sub {my $a=shift;say "@$a"},
		'+' => sub {my$acc=0;$acc+=$_ for@{$_[0]};$acc},
		'*' => sub {my$acc=1;$acc*=$_ for@{$_[0]};$acc},
		'<' => sub { $_[0]->[0] < $_[0]->[1]},
		'>' => sub { $_[0]->[0] > $_[0]->[1]},
		'-' => sub { my $args = shift; 
					return shift(@$args )* -1 if ( 1 == scalar @$args );
					my $a = shift @$args;
					$a -= $_ for @$args;
					$a },
		#'+' => Hascheme::Primitives::Sum->new ,
	}
}

sub parse_file {
	my ($self, $file) = @_;
	open my $fh, '<',$file or die "file $file does not exist. $!";
	my $code='';
	while (<$fh>) {
		chomp;
		s/;.*//;
		$code .= $_;
	}
	close $fh;

	my $sexp = $self->reader->parse($code);
	say $self->evaluator->evaluate($_, $self->env) for @$sexp;
}

sub run {
	my ($self) = @_;
	while (1) {
		print "lis.pl> ";
		my $text = <STDIN>;
		my $sexp = $self->reader->parse($text) ;
		ddx $sexp; 
		say $self->evaluator->evaluate($_, $self->env) for @$sexp;
	}
}


no Moose;
__PACKAGE__->meta->make_immutable;
1; # End of Hascheme;

