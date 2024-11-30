#!perl -w
use strict;
use ExtUtils::MakeMaker 6.46;
use Getopt::Long;
use List::Util "first";
use Config;

my $verbose = $ENV{IM_VERBOSE};
my @libpaths;
my @incpaths;

$^O eq "freebsd"
  or die "OS unsupported: FreeBSD::libpmc::Simple requires FreeBSD\n";

GetOptions("incpath=s", \@incpaths,
           "libpath=s" => \@libpaths,
           "verbose|v" => \$verbose);

my %opts = 
  (
   NAME => 'FreeBSD::libpmc::Simple',
   VERSION_FROM => 'lib/FreeBSD/libpmc/Simple.pm',
   OBJECT => 'Simple.o dopmc.o',
   LICENSE => "perl_5",
   AUTHOR => 'Tony Cook <tony@develop-help.com>',
   ABSTRACT => 'Simple interface to FreeBSD libpmc',
   META_MERGE =>
   {
     'meta-spec' =>
     {
       version => "2",
       url => "https://metacpan.org/pod/CPAN::Meta::Spec",
     },
     resources =>
     {
       homepage => "http://github.com/tonycoz/perl5-freebsd-libpmc-simple/",
       repository =>
       {
         type => "git",
         url => "https://github.com/tonycoz/perl5-freebsd-libpmc-simple.git",
         web => "https://github.com/tonycoz/perl5-freebsd-libpmc-simple/",
       },
       bugtracker =>
       {
         web => "https://github.com/tonycoz/perl5-freebsd-libpmc-simple/",
       },
     },
   },
  );


$opts{META_MERGE}{prereqs} =
  {
    configure =>
    {
      requires =>
      {
        "ExtUtils::MakeMaker" => "6.46",
      },
    },
    build =>
    {
      requires =>
      {
        "Test::More" => "0.47",
      }
    },
    runtime =>
    {
      requires =>
      {
      }
    },
    test =>
    {
      requires =>
      {
        "Test::More" => "0.47",
      }
    },
  };
$opts{PREREQ_PM} =
  {
    XSLoader => 0,
  };


WriteMakefile
  (
    %opts,
    LIBS => "-lpmc",
   );
