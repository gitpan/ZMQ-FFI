package ZMQ::FFI::ZMQ2::Socket;
$ZMQ::FFI::ZMQ2::Socket::VERSION = '0.17';
use Moo;
use namespace::autoclean;

use Carp;
use FFI::Raw;

use ZMQ::FFI::Constants q(zmq_msg_t_size);

extends q(ZMQ::FFI::SocketBase);

has _zmq2_ffi => (
    is      => 'ro',
    lazy    => 1,
    builder => '_init_zmq2_ffi',
);

sub send {
    my ($self, $msg, $flags) = @_;

    my $ffi      = $self->_ffi;
    my $zmq2_ffi = $self->_zmq2_ffi;

    $flags //= 0;


    my $length;
    {
        use bytes;
        $length = length($msg);
    };

    my $bytes_size = $length;
    my $bytes      = pack "a$bytes_size", $msg;
    my $bytes_ptr  = unpack('L!', pack('P', $bytes));

    my $msg_ptr = FFI::Raw::memptr(zmq_msg_t_size);

    $self->check_error(
        'zmq_msg_init_size',
        $ffi->{zmq_msg_init_size}->($msg_ptr, $bytes_size)
    );

    my $msg_data_ptr = $ffi->{zmq_msg_data}->($msg_ptr);
    $self->_ffi->{memcpy}->($msg_data_ptr, $bytes_ptr, $bytes_size);

    $self->check_error(
        'zmq_send',
        $zmq2_ffi->{zmq_send}->($self->_socket, $msg_ptr, $flags)
    );

    $ffi->{zmq_msg_close}->($msg_ptr);
}

sub recv {
    my ($self, $flags) = @_;

    my $ffi      = $self->_ffi;
    my $zmq2_ffi = $self->_zmq2_ffi;

    $flags //= 0;

    my $msg_ptr = FFI::Raw::memptr(zmq_msg_t_size);

    $self->check_error(
        'zmq_msg_init',
        $ffi->{zmq_msg_init}->($msg_ptr)
    );

    $self->check_error(
        'zmq_recv',
        $zmq2_ffi->{zmq_recv}->($self->_socket, $msg_ptr, $flags)
    );

    my $data_ptr = $ffi->{zmq_msg_data}->($msg_ptr);

    my $msg_size = $ffi->{zmq_msg_size}->($msg_ptr);
    $self->check_error('zmq_msg_size', $msg_size);

    my $rv;
    if ($msg_size) {
        my $content_ptr = FFI::Raw::memptr($msg_size);

        $self->_ffi->{memcpy}->($content_ptr, $data_ptr, $msg_size);


        $ffi->{memcpy}->($content_ptr, $data_ptr, $msg_size);
        $rv = $content_ptr->tostr($msg_size);
    }
    else {
        $rv = '';
    }

    $ffi->{zmq_msg_close}->($msg_ptr);

    return $rv;
}

sub disconnect {
    my ($self, $endpoint) = @_;

    croak 'not available in zmq 2.x';
}

sub unbind {
    my ($self, $endpoint) = @_;

    croak 'not available in zmq 2.x';
}

sub _init_zmq2_ffi {
    my $self = shift;

    my $ffi    = {};
    my $soname = $self->soname;

    $ffi->{zmq_send} = FFI::Raw->new(
        $soname => 'zmq_send',
        FFI::Raw::int, # retval
        FFI::Raw::ptr, # socket
        FFI::Raw::ptr, # ptr to zmq_msg_t
        FFI::Raw::int  # flags
    );

    $ffi->{zmq_recv} = FFI::Raw->new(
        $soname => 'zmq_recv',
        FFI::Raw::int, # retval
        FFI::Raw::ptr, # socket ptr
        FFI::Raw::ptr, # msg ptr
        FFI::Raw::int  # flags
    );

    return $ffi;
}

__PACKAGE__->meta->make_immutable();

__END__

=pod

=encoding UTF-8

=head1 NAME

ZMQ::FFI::ZMQ2::Socket

=head1 VERSION

version 0.17

=head1 AUTHOR

Dylan Cali <calid1984@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2014 by Dylan Cali.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
