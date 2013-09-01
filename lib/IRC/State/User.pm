package IRC::State::User;
use strictures 1;
use Carp;

use IRC::Toolkit::Case;
use IRC::Toolkit::Masks;

use List::Objects::WithUtils;

use List::Objects::Types -all;
use Types::Standard -all;

use Moo; use MooX::late;
use namespace::clean;

has nickname => (
  required => 1,
  is       => 'ro',
  isa      => Str,
  writer   => 'set_nickname',
  trigger  => 1,
);

has realname => (
  is       => 'ro',
  isa      => Str,
  writer   => 'set_realname',
  default  => sub { '' },
);

has username => (
  required => 1,
  is       => 'ro',
  isa      => Str,
  writer   => 'set_username',
  trigger  => 1,
);

has hostname => (
  required => 1,
  is       => 'ro',
  isa      => Str,
  writer   => 'set_hostname',
  trigger  => 1,
);

has full_mask => (
  # Rebuilt by nickname/realname/hostname triggers as-needed
  lazy      => 1,
  is        => 'ro',
  isa       => Str,
  writer    => '_set_full_mask',
  predicate => '_has_full_mask',
  builder   => '_build_full_mask',
  init_arg  => undef,
);

has channels => (
  # FIXME trigger to map to ->casemap if we have one?
  lazy      => 1,
  is        => 'ro',
  isa       => ArrayObj,
  coerce    => 1,
  writer    => '_set_channels',
  predicate => '_has_channels',
  default   => sub { array },
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
    my @parsed = parse_user($mask);
    $params{$_} = shift @parsed for qw/nickname username hostname/;
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
