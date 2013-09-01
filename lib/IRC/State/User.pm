package IRC::State::User;
use strictures 1;

# FIXME casemapping

use Moo;
use namespace::clean;


has nickname => (

);

has realname => (

);

has username => (

);

has hostname => (

);

has full_mask => (
  # FIXME see IRC::Server::Pluggable::User
);

has channels => (
  # FIXME see normalization-related notes in ::Channel
);

1;
