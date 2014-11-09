package ZMQ::FFI::ErrorHandler;
$ZMQ::FFI::ErrorHandler::VERSION = '0.17';
use Moo::Role;

requires q(soname);

# ZMQ::FFI::ErrorHelper instance
has error_helper => (
    is       => 'ro',
    required => 1,
    handles => [qw(
        check_error
        check_null
    )],
);

1;

__END__

=pod

=encoding UTF-8

=head1 NAME

ZMQ::FFI::ErrorHandler

=head1 VERSION

version 0.17

=head1 AUTHOR

Dylan Cali <calid1984@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2014 by Dylan Cali.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
