package ZMQ::FFI::SocketRole;
{
  $ZMQ::FFI::SocketRole::VERSION = '0.01_01';
}

use Moo::Role;

use FFI::Raw;

has ctx_ptr => (
    is       => 'ro',
    required => 1,
);

has type => (
    is       => 'ro',
    required => 1,
);

has _socket => (
    is      => 'rw',
    default => -1,
);

requires qw(
    connect
    bind
    send
    send_multipart
    recv
    recv_multipart
    get_fd
    get_linger
    set_linger
    get_identity
    set_identity
    subscribe
    unsubscribe
    has_pollin
    has_pollout
    get
    set
    close
);

sub DEMOLISH {
    my $self = shift;

    unless ($self->_socket == -1) {
        $self->close();
    }
}

1;

__END__

=pod

=head1 NAME

ZMQ::FFI::SocketRole

=head1 VERSION

version 0.01_01

=head1 AUTHOR

Dylan Cali <calid1984@gmail.com

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by Dylan Cali.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
