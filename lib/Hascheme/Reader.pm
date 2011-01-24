package Hascheme::Reader;
use Moose;
use Data::Dumper;
use autobox;
use autobox::Core;
use feature ':5.10';


sub readFile {
	my $self=shift;
	open my $code, '<', shift or die "no file! $!";
	local $/;
	my $res = <$code>;
	close $code;
	return $res;
}

sub parse_sanitized {
	my $self = shift;
	my $arr = shift;
	return unless scalar @$arr;
	my $token = shift @$arr;
	die "error, extra )" if ( $token =~ /^\s*\)\s*$/ );
	if ( $token =~ /^\s*\(\s*$/ ){
		my @sexp;
		while ( $arr->[0] !~ /\)/ ) {
			push @sexp, $self->parse_sanitized( $arr );
		}
		shift @$arr;
		return [@sexp ];
	}
	else {
		return "$token";
	}
	#elsif ($token =~ /^\s*\)\s*$/ ) {
	#return [$sexp];
	#}
}

sub parse {
	my $self = shift;
	my $text = shift;
	$text =~ s/([)(])/ $1 /g;
	$text =~ s/^\s*//;
	$text =~ s/\s*$//;
	my @tokens = split /\s+/, $text;
	my @app;
	push (@app, $self->parse_sanitized(\@tokens)) while (scalar @tokens);
	return \@app;
}

no Moose;
__PACKAGE__->meta->make_immutable;
1; # End of Hascheme::Reader;

