package IRC::Toolkit::Case::MappedString;
use strictures 1;
use IRC::Toolkit::Case;
use overload
  bool     => 'length',
  eq       => '_eq',
  ne       => '_ne',
  gt       => '_gt',
  lt       => '_lt',
  ge       => '_ge',
  le       => '_le',
  '""'     => 'as_string',
  fallback => 1;

sub STR  () { 0 }
sub CMAP () { 1 }

sub new {
  my ($class, $cmap, $str) = @_;
  unless (defined $str) {
    $str  = $cmap;
    $cmap = 'rfc1459';
  }
  bless [ $str, $cmap ], $class
}

sub as_string { $_[0]->[STR] }
sub casemap { $_[0]->[CMAP] }
sub length  { length $_[0]->[STR] }

sub _eq {
  my ($self) = @_;
  eq_irc( $_[1], $self->[STR], $self->[CMAP] )
}

sub _ne {
  my ($self) = @_;
  ! eq_irc( $_[1], $self->[STR], $self->[CMAP] )
}

sub _gt {
  return _lt( @_[0,1] ) if $_[2];
  my ($self) = @_;
  uc_irc( @$self ) gt uc_irc( $_[1], $self->[CMAP] )
}

sub _lt {
  return _gt( @_[0,1] ) if $_[2];
  my ($self) = @_;
  uc_irc( @$self ) lt uc_irc( $_[1], $self->[CMAP] )
}

sub _ge {
  return _le( @_[0,1] ) if $_[2];
  my ($self) = @_;
  uc_irc( @$self ) ge uc_irc( $_[1], $self->[CMAP] )
}

sub _le {
  return _ge( @_[0,1] ) if $_[2];
  my ($self) = @_;
  uc_irc( @$self ) le uc_irc( $_[1], $self->[CMAP] )
}


1;

=pod

=cut
