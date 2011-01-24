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
use Hascheme;
use Hascheme::Evaluator;
use Hascheme::Reader;
use Hascheme::Primitives::Sum;

#main


if (@ARGV) {
	Hascheme->new->parse_file(shift);
}
else{
	Hascheme->new->run;
}

die;

my $reader = Hascheme::Reader->new();

my $text = '(define make-acc (lambda (i) (lambda (x) (set!  i (- i x))))) (define a (make-acc 1000))';
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

