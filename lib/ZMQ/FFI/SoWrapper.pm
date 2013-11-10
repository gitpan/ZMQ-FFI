package ZMQ::FFI::SoWrapper;
{
  $ZMQ::FFI::SoWrapper::VERSION = '0.07';
}

use Moo::Role;

has _err_handler => (
    is      => 'ro',
    lazy    => 1,
    default => sub {
        return ZMQ::FFI::ErrorHandler->new(
            soname => shift->soname
        );
    },
    handles => [qw(
        check_error
        check_null
    )],
);

has _versioner => (
    is      => 'ro',
    lazy    => 1,
    default => sub {
        return ZMQ::FFI::Versioner->new(
            soname => shift->soname
        );
    },
    handles => [qw(version)],
);

has soname => (
    is       => 'ro',
    required => 1,
);

1;

__END__

=pod

=head1 NAME

ZMQ::FFI::SoWrapper

=head1 VERSION

version 0.07

=head1 AUTHOR

Dylan Cali <calid1984@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by Dylan Cali.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
