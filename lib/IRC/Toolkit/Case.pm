package IRC::Toolkit::Case;
use strictures 1;

use Carp 'carp';

use parent 'Exporter::Tiny';
our @EXPORT = qw/
  lc_irc
  uc_irc
  eq_irc
/;

## The prototypes are unfortunate, but I pulled these out of an old
## and very large bot project ... and was too scared to remove them.

sub lc_irc ($;$) {
  my ($string, $casemap) = @_;
  $casemap = lc( $casemap || 'rfc1459' );

  CASE: {
    if ($casemap eq 'rfc1459') {
      $string =~ tr/A-Z[]\\~/a-z{}|^/;
      last CASE
    }

    if ($casemap eq 'strict-rfc1459' || $casemap eq 'strict') {
      $string =~ tr/A-Z[]\\/a-z{}|/;
      last CASE
    }

    if ($casemap eq 'ascii') {
      $string =~ tr/A-Z/a-z/;
      last CASE
    }

    carp "Unknown CASEMAP $casemap, defaulted to rfc1459";
    $casemap = 'rfc1459';
    redo CASE
  }

  $string
}

sub uc_irc ($;$) {
  my ($string, $casemap) = @_;
  $casemap = lc( $casemap || 'rfc1459' );

  CASE: {
    if ($casemap eq 'rfc1459') {
      $string =~ tr/a-z{}|^/A-Z[]\\~/;
      last CASE
    }

    if ($casemap eq 'strict-rfc1459') {
      $string =~ tr/a-z{}|/A-Z[]\\/;
      last CASE
    }

    if ($casemap eq 'ascii') {
      $string =~ tr/a-z/A-Z/;
      last CASE
    }

    carp "Unknown CASEMAP $casemap, defaulted to rfc1459";
    $casemap = 'rfc1459';
    redo CASE
  }

  $string
}

sub eq_irc ($$;$) {
  my ($first, $second, $casemap) = @_;
  return unless uc_irc($first, $casemap) eq uc_irc($second, $casemap);
  1
}


1;

=pod

=head1 NAME

IRC::Toolkit::Case - IRC case-folding utilities

=head1 SYNOPSIS

  use IRC::Toolkit::Case;

  my $lower = lc_irc( $string, 'rfc1459' );

  my $upper = uc_irc( $string, 'ascii' );

  if (eq_irc($first, $second, 'strict-rfc1459')) {
    ...
  }

=head1 DESCRIPTION

IRC case-folding utilities.

IRC daemons typically announce their casemap in B<ISUPPORT> (via the
B<CASEMAPPING> directive). This should be one of C<rfc1459>,
C<strict-rfc1459>, or C<ascii>:

  'ascii'           a-z      -->  A-Z
  'rfc1459'         a-z{}|^  -->  A-Z[]\~   (default)
  'strict-rfc1459'  a-z{}|   -->  A-Z[]\

If you're building a class that tracks an IRC casemapping and manipulates
strings accordingly, you may also want to see L<IRC::Toolkit::Role::CaseMap>.

=head2 lc_irc

Takes a string and an optional casemap.

Returns the lowercased string.

=head2 uc_irc

Takes a string and an optional casemap.

Returns the uppercased string.

=head2 eq_irc

Takes a pair of strings and an optional casemap.

Returns boolean true if the strings are equal 
(per the rules specified by the given casemap).

=head1 AUTHOR

Jon Portnoy <avenj@cobaltirc.org>

Inspired by L<IRC::Utils>, copyright Chris Williams, Hinrik et al

=cut
