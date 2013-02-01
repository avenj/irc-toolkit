use Test::More;
use strict; use warnings FATAL => 'all';

use_ok( 'IRC::Message::Object', 'ircmsg' );
use_ok( 'POE::Filter::IRCv3' );

my $filter = POE::Filter::IRCv3->new(colonify => 0);

my $raw_line = ":server.org 001 user :Welcome to IRC";
my $arr = $filter->get([$raw_line]);
my $hash = shift @$arr;

my $obj = new_ok( 'IRC::Message::Object' => [
    %$hash
  ],
);

cmp_ok( $obj->prefix, 'eq', 'server.org', 'prefix  ok' );
cmp_ok( $obj->command, 'eq', '001', 'command  ok' );
cmp_ok( $obj->params->[0], 'eq', 'user', 'param 0  ok' );
cmp_ok( $obj->params->[1], 'eq', 'Welcome to IRC', 'param 1  ok' );

my $short = ircmsg(%$hash);
isa_ok($short, 'IRC::Message::Object', 'ircmsg() produced obj' );
cmp_ok( $short->command, 'eq', '001', 'ircmsg()->command()  ok' );

my $tag_line = q{@intent=ACTION;znc.in/extension=value;foobar}
            . qq{ PRIVMSG #somewhere :Some string};
my $parsed = $filter->get([$tag_line])->[0];
my $tagged = IRC::Message::Object->new(%$parsed);

cmp_ok( length($tagged->raw_line), '==', $tag_line, 'raw_line length ok' );

ok( $tagged->has_tags, 'has_tags  ok' );
is_deeply( $tagged->tags,
  +{
    foobar => undef,
    intent => 'ACTION',
    'znc.in/extension' => 'value',
  },
  'tags  ok'
);
cmp_ok( $tagged->get_tag('intent'), 'eq', 'ACTION', 'get_tag  ok' );
ok( $tagged->has_tag('foobar'), 'has_tag  ok' );

ok(
  $tagged->tags_as_string =~ qr/intent=ACTION(?:[;\s]|$)/ &&
  $tagged->tags_as_string =~ qr/znc\.in\/extension=value(?:[;\s]|$)/ &&
  $tagged->tags_as_string =~ qr/foobar(?:[;\s]|$)/,
  'tags_as_string'
) or diag "Got string ".$tagged->tags_as_string;

ok(
  (grep {; $_ eq 'foobar' } @{ $tagged->tags_as_array }) &&
  (grep {; $_ eq 'znc.in/extension=value' } @{ $tagged->tags_as_array }) &&
  (grep {; $_ eq 'intent=ACTION' } @{ $tagged->tags_as_array }),
  'tags_as_array  ok'
) or diag explain $tagged->tags_as_array;

my $from_raw = new_ok( 'IRC::Message::Object' => [
    raw_line => $tag_line,
  ],
);
cmp_ok( $from_raw->command, 'eq', 'PRIVMSG', 'obj from raw_line  ok' );

done_testing;
