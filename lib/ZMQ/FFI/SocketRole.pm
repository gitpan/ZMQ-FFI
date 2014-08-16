package ZMQ::FFI::SocketRole;
{
  $ZMQ::FFI::SocketRole::VERSION = '0.15';
}

use Moo::Role;

has soname => (
    is       => 'ro',
    required => 1,
);

# context to associate socket instance with.
# reference necessary to guard against premature object destruction
has ctx => (
    is       => 'ro',
    required => 1,
);

# zmq constant socket type, e.g. ZMQ_REQ
has type => (
    is       => 'ro',
    required => 1,
);

requires qw(
    connect
    disconnect
    bind
    unbind
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

1;

__END__

=pod

=head1 NAME

ZMQ::FFI::SocketRole

=head1 VERSION

version 0.15

=head1 AUTHOR

Dylan Cali <calid1984@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2014 by Dylan Cali.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
