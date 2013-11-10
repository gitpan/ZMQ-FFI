package ZMQ::FFI::ErrorHandler;
{
  $ZMQ::FFI::ErrorHandler::VERSION = '0.07';
}

use Moo;
use namespace::autoclean;

use Carp;
use FFI::Raw;

has soname => (
    is       => 'ro',
    required => 1,
);

sub BUILD {
    shift->_init_ffi();
}

my $zmq_errno;
my $zmq_strerror;

sub _init_ffi {
    my $soname = shift->soname;

    $zmq_errno = FFI::Raw->new(
        $soname => 'zmq_errno',
        FFI::Raw::int # returns errno
        # void
    );

    $zmq_strerror = FFI::Raw->new(
        $soname => 'zmq_strerror',
        FFI::Raw::str,  # returns error str
        FFI::Raw::int   # errno
    );
}

sub check_error {
    my ($self, $func, $rc) = @_;

    if ( $rc == -1 ) {
        $self->fatal($func);
    }
}

sub check_null {
    my ($self, $func, $obj) = @_;

    unless ($obj) {
        $self->fatal($func);
    }
}

sub fatal {
    my ($self, $func) = @_;

    croak "$func: ".$zmq_strerror->($zmq_errno->());
}

__PACKAGE__->meta->make_immutable;

__END__

=pod

=head1 NAME

ZMQ::FFI::ErrorHandler

=head1 VERSION

version 0.07

=head1 AUTHOR

Dylan Cali <calid1984@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by Dylan Cali.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
