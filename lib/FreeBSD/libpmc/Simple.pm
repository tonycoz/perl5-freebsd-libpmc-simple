package FreeBSD::libpmc::Simple;
use v5.36;

our $VERSION;
BEGIN {
  $VERSION = "1.000";
  use XSLoader;
  XSLoader::load("FreeBSD::libpmc::Simple" => $VERSION);

  if (!_init_ok()) {
      die "Failed to initialize libpmc: $!";
  }
}

sub CLONE_SKIP {}

1;

__END__

=head1 NAME

FreeBSD::libpmc::Simple - simple wrapper around libpmc

=head1 SYNOPSIS

  use FreeBSD::libpmc::Simple;

  my $p = FreeBSD::libpmc::Simple->new;
  $p->enable;
  # perform in-process task to measure
  $p->disable;
  my $result = $p->results;

=head1 DESCRIPTION

This module is a simple wrapper around FreeBSD F<libpmc>.

It is intended for use in measuring in-process execution time for
precise benchmarking, whether it will actually be useful for that
remains to be seen.

C<libpmc> is installed by default, but you may need to load the
C<hwpmc> driver, to check whether this is available, try running
C<pmcstate>:

  pmcstat -p instructions perl -e0

If this fails to initialize the library with a C<ENOENT> (No such file
or directory) error the C<hwpmc> module isn't loaded.  You can load it
until the next reboot with:

  # requires root
  kldload hwpmc

To ensure C<hwpmc> is loaded on each reboot, add a line to
F</boot/loader.conf.local> or one of the other C<loader.conf> files:

  hwpmc_load=YES

You may want to read "SECURITY CONSIDERATIONS" in the C<hwpmc> man
page.

Loading this module will throw an error if C<pmc_init()> fails.

=head1 METHODS

=over

=item new()

Create a new object, no parameters (yet).

=item enable()

=item disable()

Enable or disable stats collection.

You can enable and disable multiple times.  Statistics are cumulative.

=item results()

Returns a hash reference where the keys are (intended to be) the keys
used by the C<perf> tool, and the values are each a hash ref with the
following possible keys (some are currently never used):

=over

=item * val - the value of the captured statistic

=item * enabled

=item * id

=item * lost

=item * run

=back

=back

=head1 BUGS

Everything is subject to change.

=head1 SEE ALSO

FreeBSD man pages: pmc(3), loader.conf(5), kldload(8), pmcstat(8),
pmccontrol(8).

=head1 AUTHOR

Tony Cook <tony@develop-help.com>

=cut
