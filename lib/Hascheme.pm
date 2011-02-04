package Hascheme;
use Moose;
use feature ':5.10';
use Data::Dump qw(dump ddx);
use Hascheme::Env;
use Hascheme::Evaluator;
use Hascheme::Reader;
use Data::Dumper::Concise;

has reader => ( is =>'ro',
				isa =>'Hascheme::Reader',
				default=>sub {Hascheme::Reader->new});

has evaluator => (is =>'ro', 
				  isa =>'Hascheme::Evaluator',
				  default=>sub{Hascheme::Evaluator->new});

has env => (is =>'ro', isa =>'Hascheme::Env', default=>sub{Hascheme::Env->new});

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
	my $res;
	$res = $self->evaluator->evaluate($_, $self->env) for @$sexp;
	say "res: $res";
}

sub run {
	my ($self) = @_;
	while (1) {
		print "has> ";
		my $text = <STDIN>;
		my $sexp = $self->reader->parse($text) ;
		ddx $sexp; 
		my $res;
		$res = $self->evaluator->evaluate($_, $self->env) for @$sexp;
		say "res: "; print Dumper $res;
	}
}


no Moose;
__PACKAGE__->meta->make_immutable;
1; # End of Hascheme;

