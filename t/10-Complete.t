#!perl -T

use Test::More ;
use feature ':5.10';
BEGIN {
	use_ok( 'Hascheme::Env' );
	use_ok( 'Hascheme::Evaluator' );
	use_ok( 'Hascheme::Reader' );
}

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

sub try {

	my $reader = Hascheme::Reader->new();
	my $env = Hascheme::Env->new(env=>build_env());
	my $evaluator = Hascheme::Evaluator->new;
	my $init = $reader->parse(shift);
	my $res;
	$res = $evaluator->evaluate($_, $env) for @$init;
	return $res;
}


is try('(+ 3 3)') , 6 , 'sum';
is try('(define a (lambda (x y) (+ x y))) (a 3 4)') ,7 ,'lambda';
is try('(define abs (lambda (x) ((if (< x 0) - +) x))) (abs -7)'), 7 ,'abs';
is try('(define abs (lambda (x) ((if (< x 0) - +) x))) (abs -7)'), 7 ,'abs';
is try('(define abs (lambda (x) x )) (if (> (abs 5) (abs 4)) 1 0)') ,1,'funs in if';
is try('((lambda (x) ((if (< x 0) - +) x)) -8)'),8,'anon fun applied' ;
is try('(define var 4) (if (< var 2) (set! var 1) (set! var 2)) var'),2,'set';
is try('(define var 4) (if (< var 2) (set! var 1) (set! var (- var 2))) var'),2,'set';
is try('(define make-acc (lambda (initial) (define i initial) (lambda (x) (set!  i (- i x)) i))) (define a (make-acc 1000)) (a 100)'), 900, 'oop';
#is try('(define make-acc (lambda (initial) (lambda (x) (set! initial (- initial x)) initial ))) ((make-acc 100) 50)'), 50, 'oop2'; 






done_testing;
