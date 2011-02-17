package Hascheme::InPort;
use Hascheme::Symbol;
use IO::All;
use Moose;
use feature ':5.10';
use IO::Handle;

has eof_handle => (is =>'ro', isa =>'Hascheme::Symbol' , default =>
	sub { Hascheme::Symbol->new(symb => 'eof_handle')});

has file => (is =>'rw', isa =>'IO::All', default => sub{ io('-') } );
has _line => (is =>'rw', isa =>'Str', default => '');

sub next_token {
	my $self = shift;
	my $re = q{\s*(,@|[('`,)]|"(?:[\\].|[^\\"])*"|;.*|[^\s('"`,;)]*)(.*)} ;
	while (1) {
		$self->_line($self->file->getline) if $self->_line eq '' ;
		return Symbol(symb=>'eof_object') if $self->_line eq '';
		my ($token, $tmp ) = ($self->_line =~ /$re/);
		$self->_line($tmp);
		unless ($token eq '' or $token=~/^;/) {
			return $token;
		}
	}
}


no Moose;
__PACKAGE__->meta->make_immutable;
1; # End of Hascheme::InPort

