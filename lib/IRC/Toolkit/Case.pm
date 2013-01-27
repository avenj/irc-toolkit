package IRC::Toolkit::Case;

use strictures 1;

use Exporter 'import';
our @EXPORT = qw/
  lc_irc
  uc_irc
  eq_irc
/;

sub lc_irc ($;$) {
  my ($string, $casemap) = @_;
  $casemap = lc( $casemap // 'rfc1459' );

  CASE: {
    if ($casemap eq 'strict-rfc1459') {
      $string =~ tr/A-Z[]\\/a-z{}|/;
      last CASE
    }

    if ($casemap eq 'ascii') {
      $string =~ tr/A-Z/a-z/;
      last CASE
    }

    $string =~ tr/A-Z[]\\~/a-z{}|^/
  }

  $string
}

sub uc_irc ($;$) {
  my ($string, $casemap) = @_;
  $casemap = lc( $casemap // 'rfc1459' );

  CASE: {
    if ($casemap eq 'strict-rfc1459') {
      $string =~ tr/a-z{}|/A-Z[]\\/;
      last CASE
    }

    if ($casemap eq 'ascii') {
      $string =~ tr/a-z/A-Z/;
      last CASE
    }

    $string =~ tr/a-z{}|^/A-Z[]\\~/
  }

  $string
}

sub eq_irc ($$;$) {
  my ($first, $second, $casemap) = @_;
  return unless uc_irc($first, $casemap) eq uc_irc($second, $casemap);
  1
}


1;
