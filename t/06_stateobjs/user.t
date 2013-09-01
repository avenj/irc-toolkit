use Test::More;
use strict; use warnings FATAL => 'all';

BEGIN { use_ok( 'IRC::State::User' ) }

my $user = new_ok 'IRC::State::User' => [
  nickname => 'foo',
  username => 'bar',
  hostname => 'baz.org',
];

# nickname / set_nickname / full_mask
cmp_ok $user->nickname, 'eq', 'foo',
  'nickname eq foo ok';
ok $user->set_nickname('Foo'), 
  'set_nickname ok';
cmp_ok $user->nickname, 'eq', 'Foo',
  'nickname eq Foo ok';
cmp_ok $user->full_mask, 'eq', 'Foo!bar@baz.org',
  'full_mask after set_nickname ok';

# realname / set_realname
ok $user->set_realname('I like snacks'), 
  'set_realname ok';
cmp_ok $user->realname, 'eq', 'I like snacks',
  'realname ok';

# username / set_username / full_mask
cmp_ok $user->username, 'eq', 'bar',
  'username eq bar ok';
ok $user->set_username('Bar'),
  'set_username ok';
cmp_ok $user->username, 'eq', 'Bar',
  'username eq Bar ok';
cmp_ok $user->full_mask, 'eq', 'Foo!Bar@baz.org',
  'full_mask after set_username ok';

# hostname / set_hostname / full_mask
cmp_ok $user->hostname, 'eq', 'baz.org',
  'hostname eq baz.org ok';
ok $user->set_hostname('quux.com'),
  'set_hostname ok';
cmp_ok $user->hostname, 'eq', 'quux.com',
  'hostname eq quux.com ok';
cmp_ok $user->full_mask, 'eq', 'Foo!Bar@quux.com',
  'full_mask after set_hostname ok';

# channels, no casemap normalization
# FIXME

# channels, with casemap normalization
# FIXME

# constructors
{
  my $frommask = IRC::State::User->from_mask('foo!bar@quux.org');
  cmp_ok $frommask->nickname, 'eq', 'foo',
    '->from_mask->nickname ok';
  cmp_ok $frommask->username, 'eq', 'bar',
    '->from_mask->username ok';
  cmp_ok $frommask->hostname, 'eq', 'quux.org',
    '->from_mask->hostname ok';
  cmp_ok $frommask->realname, 'eq', '',
    'default realname ok';
}

{
  my $frommask = IRC::State::User->new(from_mask => 'foo!bar@quux.org');
  cmp_ok $frommask->nickname, 'eq', 'foo',
    '->from_mask->nickname ok';
  cmp_ok $frommask->username, 'eq', 'bar',
    '->from_mask->username ok';
  cmp_ok $frommask->hostname, 'eq', 'quux.org',
    '->from_mask->hostname ok';
  cmp_ok $frommask->realname, 'eq', '',
    'default realname ok';
}

done_testing;
