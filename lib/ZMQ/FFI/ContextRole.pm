package ZMQ::FFI::ContextRole;
{
  $ZMQ::FFI::ContextRole::VERSION = '0.12';
}

use Moo::Role;

has soname => (
    is       => 'ro',
    required => 1,
);

has threads => (
    is        => 'ro',
    predicate => 'has_threads',
);

has max_sockets => (
    is        => 'ro',
    predicate => 'has_max_sockets',
);

requires qw(
    get
    set
    socket
    destroy
);

1;

__END__

=pod

=head1 NAME

ZMQ::FFI::ContextRole

=head1 VERSION

version 0.12

=head1 AUTHOR

Dylan Cali <calid1984@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2014 by Dylan Cali.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
