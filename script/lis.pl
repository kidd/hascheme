#!/usr/bin/perl
use strict;
use warnings;

#use rlib ;
use FindBin;
use lib "$FindBin::Bin/../lib";

use Data::Dumper;
use Data::Dump qw(dump ddx);
use feature ':5.10';
use Hascheme::Env;
use Hascheme::Evaluator;
use Hascheme::Reader;
use Hascheme::Primitives::Sum;

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

#main

my $reader = Hascheme::Reader->new();
#my $text = $reader->readFile(shift @ARGV or 'test.lisp');
#my $text = '(define a (lambda (x y) (+ x y))) (a 3 4)';
#my $text = '((lambda (x y) (+ x y)) 3 4)';
#my $text = '(define abs (lambda (x) ((if (< x 0) - +) x))) (abs -7)';
#my $text = '(define abs (lambda (x) x )) (if (> (abs 5) (abs 4)) si no)';
#my $text = '((lambda (x) ((if (< x 0) - +) x)) -8) ';
#my $text = '(define var 4) (if (< var 2) (set! var 1) (set! var 2)) var ';
my $text = '(define fact (lambda (x) (if (< x 3) x (* x (fact (- x 1)))))) (fact 10) ';

#my $text = '(define fact (lambda (x) (if (< x 2) 1 (fact 9) ))) (fact 10) ';

	my $env = Hascheme::Env->new(env=>build_env());
	my $evaluator = Hascheme::Evaluator->new;

	my $init = $reader->parse($text);
	say $evaluator->evaluate($_, $env) for @$init;

while (1) {
	print "lis.pl> ";
	my $text = <STDIN>;
	my $sexp = $reader->parse($text) ;
	ddx $sexp; 
	say $evaluator->evaluate($_, $env) for @$sexp;
}

