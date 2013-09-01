package IRC::State::User;
use strictures 1;
use Carp;

# FIXME types
# FIXME casemapping?

use Moo;
use namespace::clean;

has nickname => (
  required => 1,
  is       => 'ro',
  writer   => 'set_nickname',
  trigger  => 1,
);

has realname => (
  is       => 'ro',
  writer   => 'set_realname',
  default  => sub { '' },
);

has username => (
  required => 1,
  is       => 'ro',
  writer   => 'set_username',
  trigger  => 1,
);

has hostname => (
  required => 1,
  is       => 'ro',
  writer   => 'set_hostname',
  trigger  => 1,
);

has full_mask => (
  # Rebuilt by nickname/realname/hostname triggers as-needed
  lazy      => 1,
  is        => 'ro',
  writer    => '_set_full_mask',
  predicate => '_has_full_mask',
  builder   => '_build_full_mask',
  init_arg  => undef,
);

has channels => (
  # FIXME
);

sub _build_full_mask {
  my ($self) = @_;
  $self->nickname .'!'. $self->username .'@'. $self->hostname
}

sub _trigger_username { shift->_trigger_nickname }
sub _trigger_hostname { shift->_trigger_nickname }
sub _trigger_nickname {
  my ($self) = @_;
  $self->_set_full_mask( $self->_build_full_mask )
    if $self->_has_full_mask;
}


sub BUILDARGS {
  my ($class, %params) = @_;

  if (my $mask = delete $params{full_mask}) {
    # FIXME parse $mask, return hash
  }

  \%params
}

sub from_mask {
  my ($class, $mask) = @_;
  confess 'from_mask called without a mask specified'
    unless defined $mask;
  $class->new(full_mask => $mask)
}



1;
