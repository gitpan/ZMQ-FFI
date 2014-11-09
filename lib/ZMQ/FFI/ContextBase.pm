package ZMQ::FFI::ContextBase;
$ZMQ::FFI::ContextBase::VERSION = '0.17';
use Moo;
use namespace::autoclean;

use Carp;

with qw(
    ZMQ::FFI::ContextRole
    ZMQ::FFI::ErrorHandler
    ZMQ::FFI::Versioner
);

# real underlying zmq ctx pointer
has _ctx => (
    is      => 'rw',
    default => -1,
);

sub get {
    croak 'unimplemented in base class';
}

sub set {
    croak 'unimplemented in base class';
}

sub socket {
    croak 'unimplemented in base class';
}

sub proxy {
    croak 'unimplemented in base class';
}

sub device {
    my ($self, $type, $front, $back) = @_;

    $self->check_error(
        'zmq_device',
        $self->_ffi->{zmq_device}->($type, $front->_socket, $back->_socket)
    );
}

sub destroy {
    croak 'unimplemented in base class';
}

sub DEMOLISH {
    my $self = shift;

    unless ($self->_ctx == -1) {
        $self->destroy();
    }
}

__PACKAGE__->meta->make_immutable();

__END__

=pod

=encoding UTF-8

=head1 NAME

ZMQ::FFI::ContextBase

=head1 VERSION

version 0.17

=head1 AUTHOR

Dylan Cali <calid1984@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2014 by Dylan Cali.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
