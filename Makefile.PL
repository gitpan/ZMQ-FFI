
use strict;
use warnings;



use ExtUtils::MakeMaker 6.30;



my %WriteMakefileArgs = (
  "ABSTRACT" => "zeromq bindings using libffi and FFI::Raw",
  "AUTHOR" => "Dylan Cali <calid1984\@gmail.com>",
  "BUILD_REQUIRES" => {},
  "CONFIGURE_REQUIRES" => {
    "ExtUtils::MakeMaker" => "6.30"
  },
  "DISTNAME" => "ZMQ-FFI",
  "EXE_FILES" => [],
  "LICENSE" => "perl",
  "NAME" => "ZMQ::FFI",
  "PREREQ_PM" => {
    "Carp" => 0,
    "Exporter" => 0,
    "FFI::Raw" => 0,
    "Math::Int64" => 0,
    "Moo" => "1.003001",
    "Moo::Role" => 0,
    "Sub::Exporter" => 0,
    "Try::Tiny" => 0,
    "feature" => 0,
    "if" => 0,
    "namespace::autoclean" => 0,
    "strict" => 0,
    "warnings" => 0
  },
  "TEST_REQUIRES" => {
    "AnyEvent" => 0,
    "EV" => 0,
    "Math::BigInt" => 0,
    "Scalar::Util" => 0,
    "Test::Exception" => 0,
    "Test::More" => 0,
    "Time::HiRes" => 0
  },
  "VERSION" => "0.07",
  "test" => {
    "TESTS" => "t/*.t"
  }
);


my %FallbackPrereqs = (
  "AnyEvent" => 0,
  "Carp" => 0,
  "EV" => 0,
  "Exporter" => 0,
  "FFI::Raw" => 0,
  "Math::BigInt" => 0,
  "Math::Int64" => 0,
  "Moo" => "1.003001",
  "Moo::Role" => 0,
  "Scalar::Util" => 0,
  "Sub::Exporter" => 0,
  "Test::Exception" => 0,
  "Test::More" => 0,
  "Time::HiRes" => 0,
  "Try::Tiny" => 0,
  "feature" => 0,
  "if" => 0,
  "namespace::autoclean" => 0,
  "strict" => 0,
  "warnings" => 0
);


unless ( eval { ExtUtils::MakeMaker->VERSION(6.63_03) } ) {
  delete $WriteMakefileArgs{TEST_REQUIRES};
  delete $WriteMakefileArgs{BUILD_REQUIRES};
  $WriteMakefileArgs{PREREQ_PM} = \%FallbackPrereqs;
}

delete $WriteMakefileArgs{CONFIGURE_REQUIRES}
  unless eval { ExtUtils::MakeMaker->VERSION(6.52) };

WriteMakefile(%WriteMakefileArgs);



