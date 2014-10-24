package ZMQ::FFI::ZMQ3::Context;
{
  $ZMQ::FFI::ZMQ3::Context::VERSION = '0.03';
}

use Moo;
use namespace::autoclean;

use FFI::Raw;
use Carp;

use ZMQ::FFI::Util qw(zcheck_error zcheck_null zmq_version);
use ZMQ::FFI::ZMQ3::Socket;
use ZMQ::FFI::Constants qw(ZMQ_IO_THREADS ZMQ_MAX_SOCKETS);

use Try::Tiny;

with q(ZMQ::FFI::ContextRole);

has '+threads' => (
    default => 1,
);

my $zmq_ctx_new = FFI::Raw->new(
    'libzmq.so' => 'zmq_ctx_new',
    FFI::Raw::ptr, # returns ctx ptr
    # void
);

my $zmq_ctx_set = FFI::Raw->new(
    'libzmq.so' => 'zmq_ctx_set',
    FFI::Raw::int, # error code,
    FFI::Raw::ptr, # ctx
    FFI::Raw::int, # opt constant
    FFI::Raw::int  # opt value
);

my $zmq_ctx_get = FFI::Raw->new(
    'libzmq.so' => 'zmq_ctx_get',
    FFI::Raw::int, # opt value,
    FFI::Raw::ptr, # ctx
    FFI::Raw::int  # opt constant
);

my $zmq_ctx_destroy = FFI::Raw->new(
    'libzmq.so' => 'zmq_ctx_destroy',
    FFI::Raw::int, # retval
    FFI::Raw::ptr  # ctx to destroy
);

sub BUILD {
    my $self = shift;

    $self->_ctx( $zmq_ctx_new->() );

    try {
        zcheck_null('zmq_ctx_new', $self->_ctx);
    }
    catch {
        $self->_ctx(-1);
        croak $_;
    };

    if ( $self->has_threads ) {
        $self->set(ZMQ_IO_THREADS, $self->_threads);
    }

    if ( $self->has_max_sockets ) {
        $self->set(ZMQ_MAX_SOCKETS, $self->_max_sockets);
    }
}

sub get {
    my ($self, $option) = @_;

    my $option_val = $zmq_ctx_get->($self->_ctx, $option);
    zcheck_error('zmq_ctx_get', $option_val);

    return $option_val;
}

sub set {
    my ($self, $option, $option_val) = @_;

    zcheck_error(
        'zmq_ctx_set',
        $zmq_ctx_set->($self->_ctx, $option, $option_val)
    );
}

sub socket {
    my ($self, $type) = @_;

    return ZMQ::FFI::ZMQ3::Socket->new( ctx_ptr => $self->_ctx, type => $type );
}

sub destroy {
    my $self = shift;

    zcheck_error('zmq_ctx_destroy', $zmq_ctx_destroy->($self->_ctx));
    $self->_ctx(-1);
};

__PACKAGE__->meta->make_immutable();

__END__

=pod

=head1 NAME

ZMQ::FFI::ZMQ3::Context

=head1 VERSION

version 0.03

=head1 AUTHOR

Dylan Cali <calid1984@gmail.com

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by Dylan Cali.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
