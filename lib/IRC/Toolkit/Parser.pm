package IRC::Toolkit::Parser;

use Carp;
use strictures 1;

use POE::Filter::IRCv3;
my $filter = 'POE::Filter::IRCv3';

sub irc_ref_from_line {
  my $line = shift;
  confess "Expected a line and optional filter arguments"
    unless $line;
  $filter->new(@_)->get([$line])->[0]
}

sub irc_line_from_ref {
  my $ref = shift;
  confess "Expected a HASH and optional filter arguments"
    unless ref $ref eq 'HASH';
  $filter->new(@_)->put([$ref])->[0]
}


1;
