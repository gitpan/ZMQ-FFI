package ZMQ::FFI::Util;
{
  $ZMQ::FFI::Util::VERSION = '0.01_01';
}

# ABSTRACT: zmq convenience functions

use strict;
use warnings;

use FFI::Raw;
use Carp;

use Sub::Exporter -setup => {
    exports => [qw(
        zcheck_error
        zcheck_null
        zmq_version
    )],
};

my $zmq_errno = FFI::Raw->new(
    'libzmq.so' => 'zmq_errno',
    FFI::Raw::int # returns errno
    # void
);

my $zmq_strerror = FFI::Raw->new(
    'libzmq.so' => 'zmq_strerror',
    FFI::Raw::str,  # returns error str
    FFI::Raw::int   # errno
);

my $zmq_version = FFI::Raw->new(
    'libzmq.so' => 'zmq_version',
    FFI::Raw::void,
    FFI::Raw::ptr,  # major
    FFI::Raw::ptr,  # minor
    FFI::Raw::ptr   # patch
);

sub zcheck_error {
    my ($func, $rc) = @_;

    if ( $rc == -1 ) {
        zdie($func);
    }
}

sub zcheck_null {
    my ($func, $obj) = @_;

    unless ($obj) {
        zdie($func);
    }
}

sub zdie {
    my ($func) = @_;

    croak "$func: ".$zmq_strerror->($zmq_errno->());
}

sub zmq_version {
    my ($major, $minor, $patch) = map { pack 'L!', $_ } (0, 0, 0);

    my @ptrs = map { unpack('L!', pack('P', $_)) } ($major, $minor, $patch);

    $zmq_version->(@ptrs);

    return map { unpack 'L!', $_ } ($major, $minor, $patch);
}

1;

__END__

=pod

=head1 NAME

ZMQ::FFI::Util - zmq convenience functions

=head1 VERSION

version 0.01_01

=head1 SYNOPSIS

    use ZMQ::FFI::Util q(zmq_version)

    my ($major, $minor, $patch) = zmq_version();

=head1 SEE ALSO

=over 4

=item *

L<ZMQ::FFI>

=back

=head1 AUTHOR

Dylan Cali <calid1984@gmail.com

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by Dylan Cali.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
