package ZMQ::FFI::Util;
{
  $ZMQ::FFI::Util::VERSION = '0.07';
}

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
    # try to find a soname available on this system

    # .so symlink conventions are linker_name => soname => real_name
    # e.g. libzmq.so => libzmq.so.X => libzmq.so.X.Y.Z
    # Unfortunately not all distros follow this convention (Ubuntu).
    # So first we'll try the linker_name, then the sonames, and then give up
    my @sonames = qw(libzmq.so libzmq.so.3 libzmq.so.1);

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

version 0.07

=head1 SYNOPSIS

    use ZMQ::FFI::Util q(zmq_soname zmq_version)

    my $soname = zmq_soname();
    my ($major, $minor, $patch) = zmq_version($soname);

=head1 FUNCTIONS

=head2 zmq_soname

Tries to load libzmq.so, libzmq.so.1, libzmq.so.3 in that order, returning the
first one that was successful, or undef

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

This software is copyright (c) 2013 by Dylan Cali.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
