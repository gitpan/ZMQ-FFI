package ZMQ::FFI::ContextRole;
{
  $ZMQ::FFI::ContextRole::VERSION = '0.07';
}

use Moo::Role;
use ZMQ::FFI::ErrorHandler;
use ZMQ::FFI::Versioner;

with q(ZMQ::FFI::SoWrapper);

has _ctx => (
    is      => 'rw',
    default => -1,
);

has threads => (
    is        => 'ro',
    reader    => '_threads',
    predicate => 'has_threads',
);

has max_sockets => (
    is        => 'ro',
    reader    => '_max_sockets',
    predicate => 'has_max_sockets',
);

requires qw(
    get
    set
    socket
    destroy
);

sub DEMOLISH {
    my $self = shift;

    unless ($self->_ctx == -1) {
        $self->destroy();
    }
}

1;

__END__

=pod

=head1 NAME

ZMQ::FFI::ContextRole

=head1 VERSION

version 0.07

=head1 AUTHOR

Dylan Cali <calid1984@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by Dylan Cali.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
