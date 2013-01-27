package IRC::Toolkit::Modes;

use Carp;
use strictures 1;


sub mode_to_array {
  ## mode_to_array( $string,
  ##   param_always => [ split //, 'bkov' ],
  ##   param_set    => [ 'l' ],
  ##   params       => [ @params ],
  ##
  ## Returns ARRAY-of-ARRAY like:
  ##  [  [ '+', 'o', 'some_nick' ], [ '-', 't' ] ]

  my $modestr = shift // confess "mode_to_array() called without mode string";

  my %args = @_;
  $args{param_always} //= [ split //, 'bkohv' ];
  $args{param_set}    //= ( $args{param_on_set} // [ 'l' ] );
  $args{params}       //= [ ];

  if ( index($modestr, ' ') > -1 ) {
    my @params;
    ($modestr, @params) = split ' ', $modestr;
    unshift @{ $args{params} }, @params;
  }

  for (qw/ param_always param_set params /) {
    confess "$_ should be an ARRAY"
      unless ref $args{$_} eq 'ARRAY';
  }

  my @parsed;
  my %param_always = map {; $_ => 1 } @{ $args{param_always} };
  my %param_set    = map {; $_ => 1 } @{ $args{param_set} };
  my @chunks = split //, $modestr;
  my $in = '+';
  CHUNK: while (my $chunk = shift @chunks) {
    if ($chunk eq '-' || $chunk eq '+') {
      $in = $chunk;
      next CHUNK
    }

    my @current = ( $in, $chunk );
    if ($in eq '+') {
      push @current, shift @{ $args{params} }
        if exists $param_always{$chunk}
        or exists $param_set{$chunk};
    } else {
      push @current, shift @{ $args{params} }
        if exists $param_always{$chunk};
    }

    push @parsed, [ @current ]
  }

  [ @parsed ]
}

sub mode_to_hash {
  ## Returns HASH like:
  ##  add => {
  ##    'o' => [ 'some_nick' ],
  ##    't' => 1,
  ##  },
  ##  del => {
  ##    'k' => [ 'some_key' ],
  ##  },

  ## This is a 'lossy' approach.
  ## It won't accomodate batched modes well.
  ## Use mode_to_array instead.
  my $array = mode_to_array(@_);
  my $modes = { add => {}, del => {} };
  while (my $this_mode = shift @$array) {
    my ($flag, $mode, $param) = @$this_mode;
    my $key = $flag eq '+' ? 'add' : 'del' ;
    $modes->{$key}->{$mode} = $param ? [ $param ] : 1
  }

  $modes
}

1;
