package Hascheme;
use Moose;
use autobox;
use autobox::Core;
use feature ':5.10';
use Data::Dump qw(dump ddx);
use Hascheme::Env;
use Hascheme::Evaluator;
use Hascheme::Reader;

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

sub run {
	my ($self) = @_;
	my $reader = Hascheme::Reader->new();
	my $env = Hascheme::Env->new;
	my $evaluator = Hascheme::Evaluator->new;
	while (1) {
		print "lis.pl> ";
		my $text = <STDIN>;
		my $sexp = $reader->parse($text) ;
		ddx $sexp; 
		say $evaluator->evaluate($_, $env) for @$sexp;
	}

}


no Moose;
__PACKAGE__->meta->make_immutable;
1; # End of Hascheme;

