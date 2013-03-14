package IRC::Toolkit::Numeric;
use strictures 1;

use List::Objects::WithUtils 'hash';


use Exporter 'import';
our @EXPORT = qw/
  name_from_numeric
  numeric_from_name
/;


our %Numeric = (
   '001' => 'RPL_WELCOME',
   '002' => 'RPL_YOURHOST',          # RFC2812
   '003' => 'RPL_CREATED',           # RFC2812
   '004' => 'RPL_MYINFO',            # RFC2812
   '005' => 'RPL_ISUPPORT',          # draft-brocklesby-irc-isupport-03
   '008' => 'RPL_SNOMASK',           # Undernet
   '009' => 'RPL_STATMEMTOT',        # Undernet
   '010' => 'RPL_STATMEM',           # Undernet
   '014' => 'RPL_YOURCOOKIE',        # IRCnet
   '015' => 'RPL_MAP',               # Undernet
   '016' => 'RPL_MAPMORE',           # Undernet
   '017' => 'RPL_MAPEND',            # Undernet
   '020' => 'RPL_CONNECTING',        # IRCnet
   '042' => 'RPL_YOURID',            # IRCnet
   '043' => 'RPL_SAVENICK',          # IRCnet
   '050' => 'RPL_ATTEMPTINGJUNC',    # aircd
   '051' => 'RPL_ATTEMPTINGREROUTE', # aircd

   '200' => 'RPL_TRACELINK',         # RFC1459
   '201' => 'RPL_TRACECONNECTING',   # RFC1459
   '202' => 'RPL_TRACEHANDSHAKE',    # RFC1459
   '203' => 'RPL_TRACEUNKNOWN',      # RFC1459
   '204' => 'RPL_TRACEOPERATOR',     # RFC1459
   '205' => 'RPL_TRACEUSER',         # RFC1459
   '206' => 'RPL_TRACESERVER',       # RFC1459
   '207' => 'RPL_TRACESERVICE',      # RFC2812
   '208' => 'RPL_TRACENEWTYPE',      # RFC1459
   '209' => 'RPL_TRACECLASS',        # RFC2812
   '210' => 'RPL_STATS',             # aircd
   '211' => 'RPL_STATSLINKINFO',     # RFC1459
   '212' => 'RPL_STATSCOMMANDS',     # RFC1459
   '213' => 'RPL_STATSCLINE',        # RFC1459
   '214' => 'RPL_STATSNLINE',        # RFC1459
   '215' => 'RPL_STATSILINE',        # RFC1459
   '216' => 'RPL_STATSKLINE',        # RFC1459
   '217' => 'RPL_STATSQLINE',        # RFC1459
   '218' => 'RPL_STATSYLINE',        # RFC1459
   '219' => 'RPL_ENDOFSTATS',        # RFC1459

   '220' => 'RPL_STATSPLINE',        # hybrid/ratbox/chary
   '221' => 'RPL_UMODEIS',           # RFC1459
   '224' => 'RPL_STATSFLINE',        # hybrid/ratbox/chary
   '225' => 'RPL_STATSDLINE',        # hybrid/ratbox/chary

   '231' => 'RPL_SERVICEINFO',       # RFC1459
   '233' => 'RPL_SERVICE',           # RFC1459
   '234' => 'RPL_SERVLIST',          # RFC1459
   '235' => 'RPL_SERVLISTEND',       # RFC1459
   '239' => 'RPL_STATSIAUTH',        # IRCnet

   '241' => 'RPL_STATSLLINE',        # RFC1459
   '242' => 'RPL_STATSUPTIME',       # RFC1459
   '243' => 'RPL_STATSOLINE',        # RFC1459
   '244' => 'RPL_STATSHLINE',        # RFC1459
   '245' => 'RPL_STATSSLINE',        # Bahamut, IRCnet, Hybrid
   '247' => 'RPL_STATSXLINE',        # hybrid/ratbox/chary
   '248' => 'RPL_STATSULINE',        # hybrid/ratbox/chary
   '249' => 'RPL_STATSDEBUG',        # ratbox(?)/chary

   '250' => 'RPL_STATSCONN',         # ircu, Unreal
   '251' => 'RPL_LUSERCLIENT',       # RFC1459
   '252' => 'RPL_LUSEROP',           # RFC1459
   '253' => 'RPL_LUSERUNKNOWN',      # RFC1459
   '254' => 'RPL_LUSERCHANNELS',     # RFC1459
   '255' => 'RPL_LUSERME',           # RFC1459
   '256' => 'RPL_ADMINME',           # RFC1459
   '257' => 'RPL_ADMINLOC1',         # RFC1459
   '258' => 'RPL_ADMINLOC2',         # RFC1459
   '259' => 'RPL_ADMINEMAIL',        # RFC1459

   '261' => 'RPL_TRACELOG',          # RFC1459
   '262' => 'RPL_TRACEEND',          # RFC2812
   '263' => 'RPL_TRYAGAIN',          # RFC2812
   '265' => 'RPL_LOCALUSERS',        # aircd, Bahamut, Hybrid
   '266' => 'RPL_GLOBALUSERS',       # aircd, Bahamut, Hybrid
   '267' => 'RPL_START_NETSTAT',     # aircd
   '268' => 'RPL_NETSTAT',           # aircd
   '269' => 'RPL_END_NETSTAT',       # aircd

   '270' => 'RPL_PRIVS',             # ircu
   '271' => 'RPL_SILELIST',          # ircu
   '272' => 'RPL_ENDOFSILELIST',     # ircu
   '276' => 'RPL_WHOISCERTFP',       # oftc-hybrid

   '281' => 'RPL_ACCEPTLIST',        # hybrid/ratbox/chary
   '282' => 'RPL_ENDOFACCEPT',       # hybrid/ratbox/chary

   '300' => 'RPL_NONE',              # RFC1459
   '301' => 'RPL_AWAY',              # RFC1459
   '302' => 'RPL_USERHOST',          # RFC1459
   '303' => 'RPL_ISON',              # RFC1459
   '304' => 'RPL_TEXT',              # ratbox/chary
   '305' => 'RPL_UNAWAY',            # RFC1459
   '306' => 'RPL_NOWAWAY',           # RFC1459
   '307' => 'RPL_WHOISREGNICK',      # Bahamut, Unreal, Plexus
   '308' => 'RPL_WHOISADMIN',        # hybrid

   '310' => 'RPL_WHOISMODES',        # Plexus
   '311' => 'RPL_WHOISUSER',         # RFC1459
   '312' => 'RPL_WHOISSERVER',       # RFC1459
   '313' => 'RPL_WHOISOPERATOR',     # RFC1459
   '314' => 'RPL_WHOWASUSER',        # RFC1459
   '315' => 'RPL_ENDOFWHO',          # RFC1459
   '316' => 'RPL_WHOISCHANOP',       # reserved in rb/chary
   '317' => 'RPL_WHOISIDLE',         # RFC1459
   '318' => 'RPL_ENDOFWHOIS',        # RFC1459
   '319' => 'RPL_WHOISCHANNELS',     # RFC1459

   '321' => 'RPL_LISTSTART',         # RFC1459
   '322' => 'RPL_LIST',              # RFC1459
   '323' => 'RPL_LISTEND',           # RFC1459
   '324' => 'RPL_CHANNELMODEIS',     # RFC1459
   '325' => 'RPL_CHANNELMLOCK',      # sorircd 1.3
   '328' => 'RPL_CHANNELURL',        # ratbox/chary
   '329' => 'RPL_CREATIONTIME',      # Bahamut

   '330' => 'RPL_WHOISLOGGEDIN',     # ratbox/chary
   '331' => 'RPL_NOTOPIC',           # RFC1459
   '332' => 'RPL_TOPIC',             # RFC1459
   '333' => 'RPL_TOPICWHOTIME',      # ircu
   '337' => 'RPL_WHOISTEXT',         # ratbox/chary
   '338' => 'RPL_WHOISACTUALLY',     # Bahamut, ircu

   '340' => 'RPL_USERIP',            # ircu
   '341' => 'RPL_INVITING',          # RFC1459
   '342' => 'RPL_SUMMONING',         # RFC1459
   '345' => 'RPL_INVITED',           # GameSurge
   '346' => 'RPL_INVITELIST',        # RFC2812
   '347' => 'RPL_ENDOFINVITELIST',   # RFC2812
   '348' => 'RPL_EXCEPTLIST',        # RFC2812
   '349' => 'RPL_ENDOFEXCEPTLIST',   # RFC2812

   '351' => 'RPL_VERSION',           # RFC1459
   '352' => 'RPL_WHOREPLY',          # RFC1459
   '353' => 'RPL_NAMREPLY',          # RFC1459
   '354' => 'RPL_WHOSPCRPL',         # ircu
   '355' => 'RPL_NAMREPLY_',         # QuakeNet

   '360' => 'RPL_WHOWASREAL',        # ratbox/chary
   '361' => 'RPL_KILLDONE',          # RFC1459
   '362' => 'RPL_CLOSING',           # RFC1459
   '363' => 'RPL_CLOSEEND',          # RFC1459
   '364' => 'RPL_LINKS',             # RFC1459
   '365' => 'RPL_ENDOFLINKS',        # RFC1459
   '366' => 'RPL_ENDOFNAMES',        # RFC1459
   '367' => 'RPL_BANLIST',           # RFC1459
   '368' => 'RPL_ENDOFBANLIST',      # RFC1459
   '369' => 'RPL_ENDOFWHOWAS',       # RFC1459

   '371' => 'RPL_INFO',              # RFC1459
   '372' => 'RPL_MOTD',              # RFC1459
   '373' => 'RPL_INFOSTART',         # RFC1459
   '374' => 'RPL_ENDOFINFO',         # RFC1459
   '375' => 'RPL_MOTDSTART',         # RFC1459
   '376' => 'RPL_ENDOFMOTD',         # RFC1459

FIXME, # FIXME left off here

   '381' => 'RPL_YOUREOPER',         # RFC1459
   '382' => 'RPL_REHASHING',         # RFC1459
   '383' => 'RPL_YOURESERVICE',      # RFC2812
   '384' => 'RPL_MYPORTIS',          # RFC1459
   '385' => 'RPL_NOTOPERANYMORE',    # AustHex, Hybrid, Unreal

   '391' => 'RPL_TIME',              # RFC1459
   '392' => 'RPL_USERSSTART',        # RFC1459
   '393' => 'RPL_USERS',             # RFC1459
   '394' => 'RPL_ENDOFUSERS',        # RFC1459
   '395' => 'RPL_NOUSERS',           # RFC1459
   '396' => 'RPL_HOSTHIDDEN',        # Undernet

   '401' => 'ERR_NOSUCHNICK',        # RFC1459
   '402' => 'ERR_NOSUCHSERVER',      # RFC1459
   '403' => 'ERR_NOSUCHCHANNEL',     # RFC1459
   '404' => 'ERR_CANNOTSENDTOCHAN',  # RFC1459
   '405' => 'ERR_TOOMANYCHANNELS',   # RFC1459
   '406' => 'ERR_WASNOSUCHNICK',     # RFC1459
   '407' => 'ERR_TOOMANYTARGETS',    # RFC1459
   '408' => 'ERR_NOSUCHSERVICE',     # RFC2812
   '409' => 'ERR_NOORIGIN',          # RFC1459

   '411' => 'ERR_NORECIPIENT',       # RFC1459
   '412' => 'ERR_NOTEXTTOSEND',      # RFC1459
   '413' => 'ERR_NOTOPLEVEL',        # RFC1459
   '414' => 'ERR_WILDTOPLEVEL',      # RFC1459
   '415' => 'ERR_BADMASK',           # RFC2812

   '421' => 'ERR_UNKNOWNCOMMAND',    # RFC1459
   '422' => 'ERR_NOMOTD',            # RFC1459
   '423' => 'ERR_NOADMININFO',       # RFC1459
   '424' => 'ERR_FILEERROR',         # RFC1459
   '425' => 'ERR_NOOPERMOTD',        # Unreal
   '429' => 'ERR_TOOMANYAWAY',       # Bahamut

   '430' => 'ERR_EVENTNICKCHANGE',   # AustHex
   '431' => 'ERR_NONICKNAMEGIVEN',   # RFC1459
   '432' => 'ERR_ERRONEUSNICKNAME',  # RFC1459
   '433' => 'ERR_NICKNAMEINUSE',     # RFC1459
   '436' => 'ERR_NICKCOLLISION',     # RFC1459
   '439' => 'ERR_TARGETTOOFAST',     # ircu

   '440' => 'ERR_SERCVICESDOWN',     # Bahamut, Unreal
   '441' => 'ERR_USERNOTINCHANNEL',  # RFC1459
   '442' => 'ERR_NOTONCHANNEL',      # RFC1459
   '443' => 'ERR_USERONCHANNEL',     # RFC1459
   '444' => 'ERR_NOLOGIN',           # RFC1459
   '445' => 'ERR_SUMMONDISABLED',    # RFC1459
   '446' => 'ERR_USERSDISABLED',     # RFC1459
   '447' => 'ERR_NONICKCHANGE',      # Unreal
   '449' => 'ERR_NOTIMPLEMENTED',    # Undernet

   '451' => 'ERR_NOTREGISTERED',     # RFC1459
   '455' => 'ERR_HOSTILENAME',       # Unreal
   '459' => 'ERR_NOHIDING',          # Unreal

   '460' => 'ERR_NOTFORHALFOPS',     # Unreal
   '461' => 'ERR_NEEDMOREPARAMS',    # RFC1459
   '462' => 'ERR_ALREADYREGISTRED',  # RFC1459
   '463' => 'ERR_NOPERMFORHOST',     # RFC1459
   '464' => 'ERR_PASSWDMISMATCH',    # RFC1459
   '465' => 'ERR_YOUREBANNEDCREEP',  # RFC1459
   '466' => 'ERR_YOUWILLBEBANNED',   # RFC1459
   '467' => 'ERR_KEYSET',            # RFC1459
   '469' => 'ERR_LINKSET',           # Unreal

   '471' => 'ERR_CHANNELISFULL',     # RFC1459
   '472' => 'ERR_UNKNOWNMODE',       # RFC1459
   '473' => 'ERR_INVITEONLYCHAN',    # RFC1459
   '474' => 'ERR_BANNEDFROMCHAN',    # RFC1459
   '475' => 'ERR_BADCHANNELKEY',     # RFC1459
   '476' => 'ERR_BADCHANMASK',       # RFC2812
   '477' => 'ERR_NOCHANMODES',       # RFC2812
   '478' => 'ERR_BANLISTFULL',       # RFC2812

   '481' => 'ERR_NOPRIVILEGES',      # RFC1459
   '482' => 'ERR_CHANOPRIVSNEEDED',  # RFC1459
   '483' => 'ERR_CANTKILLSERVER',    # RFC1459
   '484' => 'ERR_RESTRICTED',        # RFC2812
   '485' => 'ERR_UNIQOPPRIVSNEEDED', # RFC2812
   '488' => 'ERR_TSLESSCHAN',        # IRCnet

   '491' => 'ERR_NOOPERHOST',        # RFC1459
   '492' => 'ERR_NOSERVICEHOST',     # RFC1459
   '493' => 'ERR_NOFEATURE',         # ircu
   '494' => 'ERR_BADFEATURE',        # ircu
   '495' => 'ERR_BADLOGTYPE',        # ircu
   '496' => 'ERR_BADLOGSYS',         # ircu
   '497' => 'ERR_BADLOGVALUE',       # ircu
   '498' => 'ERR_ISOPERLCHAN',       # ircu

   '501' => 'ERR_UMODEUNKNOWNFLAG',  # RFC1459
   '502' => 'ERR_USERSDONTMATCH',    # RFC1459
   '503' => 'ERR_GHOSTEDCLIENT',     # Hybrid
);

our %Name = reverse %Numeric;

sub name_from_numeric { $Numeric{$_[0]} }
sub numeric_from_name { $Name{$_[0]} }

sub export { hash(%Numeric) }
sub export_by_name { hash(%Name) }

1;

=pod

=head1 NAME

IRC::Toolkit::Numeric - Modern IRC numeric responses

=head2 SYNOPSIS

  use IRC::Toolkit::Numeric;

  my $rpl = name_from_numeric( '001' );                 # 'RPL_WELCOME'
  my $num = numeric_from_name( 'RPL_USERSDONTMATCH' );  # '502'

=head1 DESCRIPTION

A pair of functions for translating IRC numerics into their "RPL" or "ERR" 
name and back again.

=head2 name_from_numeric

Given a numeric, B<name_from_numeric> returns its proper RPL name.

=head2 numeric_from_name

Given a RPL name, B<numeric_from_name> returns its assigned command numeric.

=head2 export

  my $hash = IRC::Toolkit::Numeric->export;

Exports a L<List::Objects::WithUtils::Hash> mapping numerics to RPL/ERR names.

=head2 export_by_name

Like L</export>, but returns the reversed hash (mapping RPL/ERR names to
numerics).

=head1 AUTHOR

Jon Portnoy <avenj@cobaltirc.org>, based on the L<AnyEvent::IRC> list present
in L<IRC::Utils> and review of the B<charybdis> C<include/numeric.h> header.

Requested by <matthew@alphachat.org>

=cut
