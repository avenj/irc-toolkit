use Test::More;
use strict; use warnings FATAL => 'all';

BEGIN { use_ok('IRC::State::Channel') }

# Chan obj, no casemap normalization.
my $chan = isa_ok,
  IRC::State::Channel->new(
    name => '#foo',
  ),
  'IRC::State::Channel';

# users->push/count
cmp_ok $chan->users->count, '==', 0,
  'users->count == 0 ok';
ok $chan->users->push('Nicky', 'Bobby'),
  'users->push ok';
cmp_ok $chan->users->count, '==', 2,
  'users->count == 2 ok';

# users->list/grep

# users->delete

# modes->set

# FIXME modes behavior

# Chan obj with rfc1459 casemap normalization.
FIXME

# clone w/ normalization settings
FIXME

done_testing;
