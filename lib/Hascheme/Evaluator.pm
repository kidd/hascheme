package Hascheme::Evaluator;
use Moose;
use Data::Dump qw(dump ddx);
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
	#elsif($sexp->[0] eq 'list'){ return $self->build_list($sexp,$env); }
	elsif($sexp->[0] eq 'set!'){
		die unless defined $env->find($sexp->[1]);
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
	  if (ref $sexp->[1] eq 'ARRAY') {
	    my ( $name, @params ) = @{$sexp->[1]};
	    $env->define($name, $self->evaluate(['lambda',\@params,$sexp->[2]],$env))
	  }
	  else {
	    $env->define($sexp->[1], $self->evaluate($sexp->[2], $env));
	  }
	}
	elsif($sexp->[0] eq 'lambda' ) {
		return sub {
		  no warnings;
			my $new_env = Hascheme::Env->new(env=>{ mesh @{$sexp->[1]}  , @{$_[0]} }
								  		,parent=>$env);
		  use warnings;
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
	my ($self , $sexp ,$env) = @_;
	my $str='';
	$str .= " ( cons ".$sexp->[$_]  for (1..$#$sexp);
	$str.= ' nil ' . ' ) 'x $#$sexp;
	say "loco: $str";
	my $code = Hascheme::Reader->new->parse($str);
	return $self->evaluate($code->[0], $env);
}
no Moose;
__PACKAGE__->meta->make_immutable;
1; # End of Hascheme::Evaluator;

