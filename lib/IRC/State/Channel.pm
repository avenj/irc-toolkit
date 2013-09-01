package IRC::State::Channel;
use strictures 1;

# FIXME types

# FIXME casemapping
#  normalization should be optional
#    default: none
#             rfc1459
#             strict
#             ascii

use Moo;
use namespace::clean;


has name => (
  is        => 'ro',
  required  => 1,
);

has users => (

);

has modes => (
  # FIXME channel status modes
  # FIXME provide optional ->lists interface for bans etc also?
);

has topic => (
  # FIXME lightweight topic objs?
);


1;
