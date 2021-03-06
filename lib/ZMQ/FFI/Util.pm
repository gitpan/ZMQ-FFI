package ZMQ::FFI::Util;
$ZMQ::FFI::Util::VERSION = '0.17';
# ABSTRACT: zmq convenience functions

use strict;
use warnings;

use FFI::Raw;
use Carp;
use Try::Tiny;

use Sub::Exporter -setup => {
    exports => [qw(
        zmq_soname
        zmq_version
    )],
};

sub zmq_soname {
    my %args = @_;

    my $die = $args{die};

    # Try to find a soname available on this system
    #
    # Linux .so symlink conventions are linker_name => soname => real_name
    # e.g. libzmq.so => libzmq.so.X => libzmq.so.X.Y.Z
    # Unfortunately not all distros follow this convention (Ubuntu). So first
    # we'll try the linker_name, then the sonames.
    #
    # If Linux extensions fail also try platform specific
    # extensions (e.g. OS X) before giving up.
    my @sonames = qw(
        libzmq.so    libzmq.so.4    libzmq.so.3    libzmq.so.1
        libzmq.dylib libzmq.4.dylib libzmq.3.dylib libzmq.1.dylib
    );

    my $soname;
    FIND_SONAME:
    for (@sonames) {
        try {
            $soname = $_;

            my $zmq_version = FFI::Raw->new(
                $soname => 'zmq_version',
                FFI::Raw::void,
                FFI::Raw::ptr,  # major
                FFI::Raw::ptr,  # minor
                FFI::Raw::ptr   # patch
            );
        }
        catch {
            undef $soname;
        };

        last FIND_SONAME if $soname;
    }

    if ( !$soname && $die ) {
        croak
            qq(Could not load libzmq, tried:\n),
            join(', ', @sonames),"\n",
            q(Is libzmq on your ld path?);
    }

    return $soname;
}

sub zmq_version {
    my $soname = shift;

    $soname //= zmq_soname();

    return unless $soname;

    my $zmq_version = FFI::Raw->new(
        $soname => 'zmq_version',
        FFI::Raw::void,
        FFI::Raw::ptr,  # major
        FFI::Raw::ptr,  # minor
        FFI::Raw::ptr   # patch
    );

    my ($major, $minor, $patch) = map { pack 'i!', $_ } (0, 0, 0);

    my @ptrs = map { unpack('L!', pack('P', $_)) } ($major, $minor, $patch);

    $zmq_version->(@ptrs);

    return map { unpack 'i!', $_ } ($major, $minor, $patch);
}

1;

__END__

=pod

=encoding UTF-8

=head1 NAME

ZMQ::FFI::Util - zmq convenience functions

=head1 VERSION

version 0.17

=head1 SYNOPSIS

    use ZMQ::FFI::Util q(zmq_soname zmq_version)

    my $soname = zmq_soname();
    my ($major, $minor, $patch) = zmq_version($soname);

=head1 FUNCTIONS

=head2 zmq_soname([die => 0|1])

Tries to load the following sonames (in order):

    libzmq.so
    libzmq.so.4
    libzmq.so.3
    libzmq.so.1
    libzmq.dylib
    libzmq.4.dylib
    libzmq.3.dylib
    libzmq.1.dylib

Returns the name of the first one that was successful or undef. If you would
prefer exceptional behavior pass C<die =E<gt> 1>

=head2 ($major, $minor, $patch) = zmq_version([$soname])

return the libzmq version as the list C<($major, $minor, $patch)>. C<$soname>
can either be a filename available in the ld cache or the path to a library
file. If C<$soname> is not specified it is resolved using C<zmq_soname> above

If C<$soname> cannot be resolved undef is returned

=head1 SEE ALSO

=over 4

=item *

L<ZMQ::FFI>

=back

=head1 AUTHOR

Dylan Cali <calid1984@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2014 by Dylan Cali.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
