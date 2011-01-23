package Hascheme::Evaluator;
use Moose;
use Data::Dump qw(dump ddx);
use autobox;
use autobox::Core;
use feature ':5.10';
use Data::Dumper;
use List::MoreUtils qw(mesh);


sub evaluate {
	my ($self ,$sexp , $env ) = @_;

	say "eing? $sexp" unless defined $sexp;
	
	#say $sexp, ':',ref \$sexp, '<->', ref $sexp;
	#say 'hh=>',Dumper($sexp, $env) ;
	if (ref \$sexp eq 'SCALAR' && $sexp =~ /^\s*-?\d+\s*$/) {
		return $sexp;
	}
	elsif (ref \$sexp eq 'SCALAR' ){
		#say 'val:' , $env->find($sexp);
		return $env->find($sexp);
	}
	elsif($sexp->[0] eq 'env'){ print ddx $env; }
	elsif($sexp->[0] eq 'quote'){ return $sexp->[1]; }

	elsif($sexp->[0] eq 'set!'){
		die unless $env->find($sexp->[1]);
		$env->set($sexp->[1], $self->evaluate($sexp->[2], $env)) ;
		return $env->find( $sexp->[1] );
	}
	elsif($sexp->[0] eq 'begin'){
		my $val;
		$val = $self->evaluate($sexp->[$_],$env) for ( 1..$#$sexp );
		return $val;
	}
	elsif( $sexp->[0] eq 'if' ){
		say "un if";
		return $self->evaluate($sexp->[$self->evaluate($sexp->[1],$env) ? 2 : 3] 
			, $env) ;
	}
	elsif( $sexp->[0] eq 'define' ){
	#say "una def :", $sexp->[1];
		$env->env->{$sexp->[1]} = $self->evaluate($sexp->[2], $env);
	}
	elsif($sexp->[0] eq 'lambda' ) {
	#say "una lambda", Dumper $sexp->[2];
		return sub {
			#say "hola",Dumper $sexp->[2];
			my $new_env = Hascheme::Env->new(env=>{ mesh @{$sexp->[1]} , @{$_[0]} }
								  		,parent=>$env);
			my $ret;
			$ret = $self->evaluate( $sexp->[$_], $new_env) for (2..$#$sexp);
			return $ret;
		}
	}
	elsif (ref $sexp eq 'ARRAY' ){ #&& exists $env->env->{$sexp->[0]}) {
		say 'n';
		my ($op, @s) = map { $self->evaluate($_,$env)} @$sexp;
		return $env->apply( $op, [@s]);
	}
	say "al final" if 0 == @$sexp;
}

no Moose;
__PACKAGE__->meta->make_immutable;
1; # End of Hascheme::Evaluator;

