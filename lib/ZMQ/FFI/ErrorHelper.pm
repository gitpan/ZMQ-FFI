package ZMQ::FFI::ErrorHelper;
$ZMQ::FFI::ErrorHelper::VERSION = '0.16';
use Moo;
use namespace::autoclean;

use Carp;
use FFI::Raw;

has soname => (
    is       => 'ro',
    required => 1,
);

has _err_ffi => (
    is      => 'ro',
    lazy    => 1,
    builder => '_init_err_ffi',
);

sub BUILD {
    my $self = shift;
    $self->_err_ffi;
}

sub check_error {
    my ($self, $func, $rc) = @_;

    if ( $rc == -1 ) {
        $self->fatal($func);
    }
}

sub check_null {
    my ($self, $func, $obj) = @_;

    unless ($obj) {
        $self->fatal($func);
    }
}

sub fatal {
    my ($self, $func) = @_;

    my $ffi = $self->_err_ffi;

    my $errno  = $ffi->{zmq_errno}->();
    my $strerr = $ffi->{zmq_strerror}->($errno);

    confess "$func: $strerr";
}

sub _init_err_ffi {
    my $self = shift;

    my $ffi    = {};
    my $soname = $self->soname;

    $ffi->{zmq_errno} = FFI::Raw->new(
        $soname => 'zmq_errno',
        FFI::Raw::int # returns errno
        # void
    );

    $ffi->{zmq_strerror} = FFI::Raw->new(
        $soname => 'zmq_strerror',
        FFI::Raw::str,  # returns error str
        FFI::Raw::int   # errno
    );

    return $ffi;
}

1;

__END__

=pod

=encoding UTF-8

=head1 NAME

ZMQ::FFI::ErrorHelper

=head1 VERSION

version 0.16

=head1 AUTHOR

Dylan Cali <calid1984@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2014 by Dylan Cali.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
