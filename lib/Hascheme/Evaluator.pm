package Hascheme::Evaluator;
use Moose;
use Data::Dump qw(dump ddx);
use autobox;
use autobox::Core;
use feature ':5.10';
use Data::Dumper;
use List::MoreUtils qw(mesh);
use Hascheme::Reader;


sub evaluate {
	my ($self ,$sexp , $env ) = @_;

	say "eing? $sexp" unless defined $sexp;
	
	if (ref \$sexp eq 'SCALAR' && $sexp =~ /^\s*-?\d+\s*$/) {
		return $sexp;
	}
	elsif (ref \$sexp eq 'SCALAR' ){
		return $env->find($sexp);
	}
	elsif($sexp->[0] eq 'env'){ print ddx $env; }
	elsif($sexp->[0] eq 'repl'){ Hascheme->new(env=>$env)->run;die }
	elsif($sexp->[0] eq 'quote'){ return $sexp->[1] }
	elsif($sexp->[0] eq 'list'){
		return $self->build_list($sexp,$env);
	}
	elsif($sexp->[0] eq 'set!'){
		die unless $env->find($sexp->[0]);
		$env->set($sexp->[1], $self->evaluate($sexp->[2], $env)) ;
		return $env->find($sexp->[1]);
	}
	elsif($sexp->[0] eq 'begin'){
		my $val;
		$val = $self->evaluate($sexp->[$_],$env) for ( 1..$#$sexp );
		return $val;
	}
	elsif( $sexp->[0] eq 'if' ){
		return $self->evaluate($sexp->[$self->evaluate($sexp->[1],$env) ? 2 : 3] 
							   , $env) ;
	}
	elsif( $sexp->[0] eq 'define' ){
		$env->define($sexp->[1], $self->evaluate($sexp->[2], $env));
	}
	elsif($sexp->[0] eq 'lambda' ) {
		return sub {
			my $new_env = Hascheme::Env->new(env=>{ mesh @{$sexp->[1]} , @{$_[0]} }
								  		,parent=>$env);
			my $ret;
			$ret = $self->evaluate( $sexp->[$_], $new_env) for (2..$#$sexp);
			return $ret;
		}
	}
	elsif (ref $sexp eq 'ARRAY' ){ #&& exists $env->env->{$sexp->[0]}) {
		my ($op, @s) = map { $self->evaluate($_,$env)} @$sexp;
		return $env->apply( $op, [@s]);
	}
	say "al final" if 0 == @$sexp;
}

sub build_list {
	say ddx @_;
	my $self = shift;
	my $sexp = shift;
	my $env = shift;
	my $str='';
	$str .= "( cons ".$sexp->[$_]  for (1..$#$sexp);
	$str.= ' 0 ' . ')'x $#$sexp;
	my $code = Hascheme::Reader->new->parse($str);
	say ddx $code;
	return $self->evaluate($code->[0], $env);
	#my $self = shift;
	#return 0 unless @_;
	#my $car = shift;
	#my $cdr = $self->build_list(@_);
	#return sub { say $_[0]  == 0 ? 'zero' : ddx shift }
}
no Moose;
__PACKAGE__->meta->make_immutable;
1; # End of Hascheme::Evaluator;

