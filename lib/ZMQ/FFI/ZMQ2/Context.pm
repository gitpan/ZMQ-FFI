package ZMQ::FFI::ZMQ2::Context;
{
  $ZMQ::FFI::ZMQ2::Context::VERSION = '0.02';
}

use Moo;
use namespace::autoclean;

use FFI::Raw;
use Carp;
use Try::Tiny;

use ZMQ::FFI::Util qw(zcheck_error zcheck_null zmq_version);
use ZMQ::FFI::ZMQ2::Socket;

with q(ZMQ::FFI::ContextRole);

has '+threads' => (
    default => 1,
);

my $zmq_init = FFI::Raw->new(
    'libzmq.so' => 'zmq_init',
    FFI::Raw::ptr, # returns ctx ptr
    FFI::Raw::int  # num threads
);

my $zmq_term = FFI::Raw->new(
    'libzmq.so' => 'zmq_term',
    FFI::Raw::int, # retval
    FFI::Raw::ptr  # ctx pt
);

sub BUILD {
    my $self = shift;

    if ($self->has_max_sockets) {
        croak
            "max_sockets option not available for ZMQ2\n".
            $self->_verstr();
    }

    $self->_ctx( $zmq_init->($self->_threads) );

    try {
        zcheck_null('zmq_init', $self->_ctx);
    }
    catch {
        $self->_ctx(-1);
        croak $_;
    };
}

sub get {
    my $self = shift;

    croak
        "getting ctx options not implemented for ZMQ2\n".
        $self->_verstr();
}

sub set {
    my $self = shift;

    croak
        "setting ctx options not implemented for ZMQ2\n".
        $self->_verstr();
}

sub socket {
    my ($self, $type) = @_;

    return ZMQ::FFI::ZMQ2::Socket->new(
        ctx_ptr => $self->_ctx,
        type    => $type
    );
}

sub _verstr {
    return "your version: ".join(".", zmq_version())
}

sub destroy {
    my $self = shift;

    zcheck_error('zmq_term', $zmq_term->($self->_ctx));
    $self->_ctx(-1);
}

__PACKAGE__->meta->make_immutable();

__END__

=pod

=head1 NAME

ZMQ::FFI::ZMQ2::Context

=head1 VERSION

version 0.02

=head1 AUTHOR

Dylan Cali <calid1984@gmail.com

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by Dylan Cali.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
