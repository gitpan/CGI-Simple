use lib qw(t/lib blib/lib blib/arch);
use Test;
use Carp;
use strict;
use vars qw(%field %in);
$|++;
BEGIN { plan tests => 330, }

use CGI::Simple;
ok(1);    #1

my ( $q, $sv, @av );
my $debug = 1;
my $tmpfile = './cgi-tmpfile.tmp';
do { $^W = 1; } if $debug;

$ENV{'AUTH_TYPE'}             = 'PGP MD5 DES rot13';
$ENV{'CONTENT_LENGTH'}        = '42';
$ENV{'CONTENT_TYPE'}          = 'application/x-www-form-urlencoded';
$ENV{'COOKIE'}                = 'foo=a%20phrase; bar=yes%2C%20a%20phrase&I%20say;';
$ENV{'DOCUMENT_ROOT'}         = '/vs/www/foo';
$ENV{'GATEWAY_INTERFACE'}     = 'bleeding edge';
$ENV{'HTTPS'}                 = 'ON';
$ENV{'HTTPS_A'}               = 'A';
$ENV{'HTTPS_B'}               = 'B';
$ENV{'HTTP_ACCEPT'}           = 'text/html;q=1, text/plain;q=0.8, image/jpg, image/gif;q=0.42, */*;q=0.001';
$ENV{'HTTP_COOKIE'}           = '';
$ENV{'HTTP_FROM'}             = 'spammer@nowhere.com';
$ENV{'HTTP_HOST'}             = 'the.vatican.org';
$ENV{'HTTP_REFERER'}          = 'xxx.sex.com';
$ENV{'HTTP_USER_AGENT'}       = 'LWP';
$ENV{'PATH_INFO'}             = '/somewhere/else';
$ENV{'PATH_TRANSLATED'}       = '/usr/local/somewhere/else';
$ENV{'QUERY_STRING'}          = 'name=JaPh%2C&color=red&color=green&color=blue';
$ENV{'REDIRECT_QUERY_STRING'} = '';
$ENV{'REMOTE_ADDR'}           = '127.0.0.1';
$ENV{'REMOTE_HOST'}           = 'localhost';
$ENV{'REMOTE_IDENT'}          = 'None of your damn business';
$ENV{'REMOTE_USER'}           = 'Just another Perl hacker,';
$ENV{'REQUEST_METHOD'}        = 'GET';
$ENV{'SCRIPT_NAME'}           = '/cgi-bin/foo.cgi';
$ENV{'SERVER_NAME'}           = 'nowhere.com';
$ENV{'SERVER_PORT'}           = '8080';
$ENV{'SERVER_PROTOCOL'}       = 'HTTP/1.0';
$ENV{'SERVER_SOFTWARE'}       = 'Apache - accept no substitutes';

$q = new CGI::Simple;

eval { goto HERE };

sub undef_globals {
    undef $CGI::Simple::USE_CGI_PM_DEFAULTS;
    undef $CGI::Simple::DISABLE_UPLOADS;
    undef $CGI::Simple::POST_MAX;
    undef $CGI::Simple::NO_UNDEF_PARAMS;
    undef $CGI::Simple::USE_PARAM_SEMICOLONS;
    undef $CGI::Simple::HEADERS_ONCE;
    undef $CGI::Simple::NPH;
    undef $CGI::Simple::DEBUG;
    undef $CGI::Simple::NO_NULL;
    undef $CGI::Simple::FATAL;
}

undef_globals();

# _initialize_globals()
print "Testing: _initialize_globals()\n" if $debug;
$q->_initialize_globals();
ok( $CGI::Simple::USE_CGI_PM_DEFAULTS    , 0  );    #2
ok( $CGI::Simple::DISABLE_UPLOADS        , 1  );    #3
ok( $CGI::Simple::POST_MAX               , 102_400 );    #4
ok( $CGI::Simple::NO_UNDEF_PARAMS        , 0  );    #5
ok( $CGI::Simple::USE_PARAM_SEMICOLONS   , 0  );    #6
ok( $CGI::Simple::HEADERS_ONCE           , 0  );    #7
ok( $CGI::Simple::NPH                    , 0  );    #8
ok( $CGI::Simple::DEBUG                  , 0  );    #9
ok( $CGI::Simple::NO_NULL                , 1  );    #10
ok( $CGI::Simple::FATAL                  , -1 );    #11

undef_globals();

# _use_cgi_pm_global_settings()
print "Testing: _use_cgi_pm_global_settings()\n" if $debug;
$q->_use_cgi_pm_global_settings();
ok( $CGI::Simple::DISABLE_UPLOADS        , 0  );    #12
ok( $CGI::Simple::POST_MAX               , -1 );    #13
ok( $CGI::Simple::NO_UNDEF_PARAMS        , 0  );    #14
ok( $CGI::Simple::USE_PARAM_SEMICOLONS   , 1  );    #15
ok( $CGI::Simple::HEADERS_ONCE           , 0  );    #16
ok( $CGI::Simple::NPH                    , 0  );    #17
ok( $CGI::Simple::DEBUG                  , 1  );    #18
ok( $CGI::Simple::NO_NULL                , 0  );    #19
ok( $CGI::Simple::FATAL                  , -1 );    #20


# _store_globals()
print "Testing: _store_globals()\n" if $debug;
undef %{$q};

ok ( (! defined $q->{'.globals'}->{'DISABLE_UPLOADS'})       ,1 );    #21
ok ( (! defined $q->{'.globals'}->{'POST_MAX'})              ,1 );    #22
ok ( (! defined $q->{'.globals'}->{'NO_UNDEF_PARAMS'})       ,1 );    #23
ok ( (! defined $q->{'.globals'}->{'USE_PARAM_SEMICOLONS'})  ,1 );    #24
ok ( (! defined $q->{'.globals'}->{'HEADERS_ONCE'})          ,1 );    #25
ok ( (! defined $q->{'.globals'}->{'NPH'})                   ,1 );    #26
ok ( (! defined $q->{'.globals'}->{'DEBUG'})                 ,1 );    #27
ok ( (! defined $q->{'.globals'}->{'NO_NULL'})               ,1 );    #28
ok ( (! defined $q->{'.globals'}->{'FATAL'})                 ,1 );    #29
ok ( (! defined $q->{'.globals'}->{'USE_CGI_PM_DEFAULTS'})   ,1 );    #30

$q->_store_globals();

ok ( defined $q->{'.globals'}->{'DISABLE_UPLOADS'}       ,1 );    #31
ok ( defined $q->{'.globals'}->{'POST_MAX'}              ,1 );    #32
ok ( defined $q->{'.globals'}->{'NO_UNDEF_PARAMS'}       ,1 );    #33
ok ( defined $q->{'.globals'}->{'USE_PARAM_SEMICOLONS'}  ,1 );    #34
ok ( defined $q->{'.globals'}->{'HEADERS_ONCE'}          ,1 );    #35
ok ( defined $q->{'.globals'}->{'NPH'}                   ,1 );    #36
ok ( defined $q->{'.globals'}->{'DEBUG'}                 ,1 );    #37
ok ( defined $q->{'.globals'}->{'NO_NULL'}               ,1 );    #38
ok ( defined $q->{'.globals'}->{'FATAL'}                 ,1 );    #39
ok ( defined $q->{'.globals'}->{'USE_CGI_PM_DEFAULTS'}   ,1 );    #40

# import() - used to set paragmas
print "Testing: import()\n" if $debug;
my @args = qw( -default -no_upload -unique_header -nph -no_debug -newstyle_url -no_undef_param );

undef_globals();

$q->import(@args);

ok( $CGI::Simple::USE_CGI_PM_DEFAULTS    , 1 );    #41
ok( $CGI::Simple::DISABLE_UPLOADS        , 1  );    #42
ok( $CGI::Simple::NO_UNDEF_PARAMS        , 1  );    #43
ok( $CGI::Simple::USE_PARAM_SEMICOLONS   , 1  );    #44
ok( $CGI::Simple::HEADERS_ONCE           , 1  );    #45
ok( $CGI::Simple::NPH                    , 1  );    #46
ok( $CGI::Simple::DEBUG                  , 0  );    #47

undef_globals();

$q->import( qw ( -upload -oldstyle_url  -debug  ) );

ok( $CGI::Simple::DISABLE_UPLOADS        , 0  );    #48
ok( $CGI::Simple::USE_PARAM_SEMICOLONS   , 0  );    #49
ok( $CGI::Simple::DEBUG                  , 2  );    #50

undef_globals();

# _reset_globals()
print "Testing: _reset_globals()\n" if $debug;
$q->_reset_globals();
ok( $CGI::Simple::DISABLE_UPLOADS        , 0  );    #51
ok( $CGI::Simple::POST_MAX               , -1 );    #52
ok( $CGI::Simple::NO_UNDEF_PARAMS        , 0  );    #53
ok( $CGI::Simple::USE_PARAM_SEMICOLONS   , 1  );    #54
ok( $CGI::Simple::HEADERS_ONCE           , 0  );    #55
ok( $CGI::Simple::NPH                    , 0  );    #56
ok( $CGI::Simple::DEBUG                  , 1  );    #57
ok( $CGI::Simple::NO_NULL                , 0  );    #58
ok( $CGI::Simple::FATAL                  , -1 );    #59

undef_globals();

$q = new CGI::Simple;

# url_decode() - scalar context, void argument
print "Testing: url_decode()\n" if $debug;
$sv  = $q->url_decode();
ok ( $sv, undef );    #60

# url_decode() - scalar context, valid argument
print "Testing: url_decode(\$enc_string)\n" if $debug;
my ( $string, $enc_string );
for (32..255) { $string .= chr ; $enc_string .= uc sprintf "%%%02x", ord chr }
ok ( $q->url_decode($enc_string), $string );    #61

# url_encode() - scalar context, void argument
print "Testing: url_encode()\n" if $debug;
$sv  = $q->url_encode();
ok ( $sv, undef );    #62

# url_encode() - scalar context, valid argument
print "Testing: url_encode(\$string)\n" if $debug;
$sv  = $q->url_encode($string);
$sv =~ tr/+/ /;
$sv =~ s/%([a-fA-F0-9]{2})/ pack "C", hex $1 /eg;
ok ( $sv, $string );    #63

# url encoding - circular test
print "Testing: url encoding via circular test\n" if $debug;
ok ( $q->url_decode($q->url_encode($string)), $string );    #64

# new() plain constructor
print "Testing: new() plain constructor\n" if $debug;
$q = CGI::Simple->new;
ok( $q, qr/CGI::Simple/ );    #65

# new('') empty constructor
print "Testing: new() empty constructor\n" if $debug;
$q = new CGI::Simple('');
ok( $q, qr/CGI::Simple/ );    #66
$q = new CGI::Simple({});
ok( $q, qr/CGI::Simple/ );    #67

# new() hash constructor
print "Testing: new() hash constructor\n" if $debug;
$q = new CGI::Simple( { 'foo'=>'1', 'bar'=>[2,3,4] } );
@av = $q->param;
# fix OS bug with testing
ok( (join' ',@av) eq 'foo bar' or (join' ',@av) eq 'bar foo'  );    #68
ok( $q->param('foo'), 1);    #69
ok( $q->param('bar'), 2 );    #70
@av = $q->param('bar');
ok( (join'',@av), 234 );    #71
$q = new CGI::Simple( 'foo=1&bar=2&bar=3&bar=4' );
open FH, ">$tmpfile", or carp "Can't create $tmpfile $!\n";
$q->save(\*FH);
close FH;

# new() query string constructor
print "Testing: new() query string constructor\n" if $debug;
$q = new CGI::Simple( 'foo=5&bar=6&bar=7&bar=8' );
@av = $q->param;
ok( (join' ',@av), 'foo bar' );    #72
ok( $q->param('foo'), 5);    #73
ok( $q->param('bar'), 6 );    #74
@av = $q->param('bar');
ok( (join'',@av), 678 );    #75
open FH, ">>$tmpfile", or carp "Can't append $tmpfile $!\n";
$q->save_parameters(\*FH);
close FH;

# new() file constructor
print "Testing: new() file constructor\n" if $debug;
open FH, $tmpfile, or carp "Can't open temp file\n";
ok( (join'',<FH>), "foo=1\nbar=2\nbar=3\nbar=4\n=\nfoo=5\nbar=6\nbar=7\nbar=8\n=\n" );    #76
close FH;
open FH, $tmpfile, or carp "Can't open temp file\n";
$q = new CGI::Simple(\*FH);
close FH;
@av = $q->param;
ok( (join' ',@av), 'foo bar' );    #77
ok( $q->param('foo'), 1);    #78
ok( $q->param('bar'), 2 );    #79
@av = $q->param('bar');
ok( (join'',@av), 234 );    #80
# call new twice to read two sections of file
open FH, $tmpfile, or carp "Can't open temp file\n";
$q = new CGI::Simple(\*FH);
@av = $q->param;
ok( (join' ',@av), 'foo bar' );    #81
ok( $q->param('foo'), 1);    #82
ok( $q->param('bar'), 2 );    #83
@av = $q->param('bar');
ok( (join'',@av), 234 );    #84
# call new again
$q = new CGI::Simple(\*FH);
close FH;
@av = $q->param;
ok( (join' ',@av), 'foo bar' );    #85
ok( $q->param('foo'), 5);    #86
ok( $q->param('bar'), 6 );    #87
@av = $q->param('bar');
ok( (join'',@av), 678 );    #88

# new() CGI::Simple object constructor
print "Testing: new() CGI::Simple object constructor\n" if $debug;
my $q_old = new CGI::Simple( 'foo=1&bar=2&bar=3&bar=4' );
my $q_new = new CGI::Simple( $q_old );
ok( $q_old->query_string, 'foo=1&bar=2&bar=3&bar=4' );    #89
ok( $q_new->query_string, 'foo=1&bar=2&bar=3&bar=4' );    #90

# new() \@ARGV constructor
print "Testing: new() \@ARGV constructor\n" if $debug;
$ENV{'REQUEST_METHOD'} = '';
$CGI::Simple::DEBUG = 1;
@ARGV = qw( foo=bar\=baz foo=bar\&baz );
$q = new CGI::Simple;
ok( (join ' ', $q->param('foo')), 'bar=baz bar&baz' );    #91
$ENV{'REQUEST_METHOD'} = 'GET';


################ The Core Methods ################

$q = new CGI::Simple;

# param() - scalar and array context, void argument
print "Testing: param() void argument\n" if $debug;
$sv  = $q->param();
@av = $q->param();
ok ( $sv, '2' );    #92
ok ( (join' ',@av), 'name color' );    #93

# param() - scalar and array context, single argument (valid)
print "Testing: param('color') single argument (valid)\n" if $debug;
$sv = $q->param('color');
@av = $q->param('color');
ok ( $sv, 'red' );    #94
ok ( (join' ',@av), 'red green blue' );    #95

# param() - scalar and array context, single argument (invalid)
print "Testing: param('invalid') single argument (invalid)\n" if $debug;
$sv = $q->param('invalid');
@av = $q->param('invalid');
ok ( $sv, undef );    #96
ok ( (join' ',@av), '' );    #97

# param() - scalar and array context, -name=>'param' (valid)
print "Testing: param( -name=>'color' ) get values\n" if $debug;
$sv = $q->param( -name=>'color' );
@av = $q->param( -name=>'color' );
ok ( $sv, 'red' );    #98
ok ( (join' ',@av), 'red green blue' );    #99

# param() - scalar and array context, -name=>'param' (invalid)
print "Testing: param( -name=>'invalid' ) get values\n" if $debug;
$sv = $q->param( -name=>'invalid' );
@av = $q->param( -name=>'invalid' );
ok ( $sv, undef );    #100
ok ( (join' ',@av), '' );    #101

$CGI::Simple::NO_UNDEF_PARAMS = 0;
$q = new CGI::Simple ( 'name=&color=' );

# param() - scalar and array context, void values void arg
print "Testing: param() void values 1\n" if $debug;
$sv  = $q->param();
@av = $q->param();
ok ( $sv, '2' );    #102
ok ( (join' ',@av), 'name color' );    #103

# param() - scalar and array context, void values, valid arg
print "Testing: param('name') void values 1, valid param\n" if $debug;
$sv  = $q->param('name');
@av = $q->param('name');
ok ( $sv, '' );    #104
ok ( (join' ',@av), '' );    #105

$q = new CGI::Simple ( 'name&color' );

# param() - scalar and array context, void values void arg
print "Testing: param() void values 2\n" if $debug;
$sv  = $q->param();
@av = $q->param();
ok ( $sv, '2' );    #106
ok ( (join' ',@av), 'name color' );    #107

# param() - scalar and array context, void values, valid arg
print "Testing: param('name') void values 2 , valid param\n" if $debug;
$sv  = $q->param('name');
@av = $q->param('name');
ok ( $sv, '' );    #108
ok ( (join' ',@av), '' );    #109

$CGI::Simple::NO_UNDEF_PARAMS = 1;
$q = new CGI::Simple ( 'name=&color=' );

# param() - scalar and array context, void values void arg
print "Testing: param() void values 1, no undef\n" if $debug;
$sv  = $q->param();
@av = $q->param();
ok ( $sv, '0' );    #110
ok ( (join' ',@av), '' );    #111

# param() - scalar and array context, void values, valid arg
print "Testing: param('name') void values 1, valid param, no undef\n" if $debug;
$sv  = $q->param('name');
@av = $q->param('name');
ok ( $sv, undef );    #112
ok ( (join' ',@av), '' );    #113

$q = new CGI::Simple ( 'name&color' );

# param() - scalar and array context, void values void arg
print "Testing: param() void values 2, no undef\n" if $debug;
$sv  = $q->param();
@av = $q->param();
ok ( $sv, '0' );    #114
ok ( (join' ',@av), '' );    #115

# param() - scalar and array context, void values, valid arg
print "Testing: param('name') void values 2, valid param, no undef\n" if $debug;
$sv  = $q->param('name');
@av = $q->param('name');
ok ( $sv, undef );    #116
ok ( (join' ',@av), '' );    #117

$CGI::Simple::NO_UNDEF_PARAMS = 0;
$q = new CGI::Simple;

# param() - scalar and array context, set values
print "Testing: param( 'foo', 'some', 'new', 'values' ) set values\n" if $debug;
$sv = $q->param( 'foo', 'some', 'new', 'values' );
@av = $q->param( 'foo', 'some', 'new', 'values' );
ok ( $sv, 'some' );    #118
ok ( (join' ',@av), 'some new values' );    #119

# param() - scalar and array context
print "Testing: param( -name=>'foo', -value=>'bar' ) set values\n" if $debug;
$sv = $q->param( -name=>'foo', -value=>'bar' );
@av = $q->param( -name=>'foo', -value=>'bar' );
ok ( $sv, 'bar' );    #120
ok ( (join' ',@av), 'bar' );    #121

# param() - scalar and array context
print "Testing: param(-name=>'foo',-value=>['bar','baz']) set values\n" if $debug;
$sv = $q->param( -name=>'foo', -value=>['bar','baz'] );
@av = $q->param( -name=>'foo', -value=>['bar','baz'] );
ok ( $sv, 'bar' );    #122
ok ( (join' ',@av), 'bar baz' );    #123

# add_param() - scalar and array context, void argument
print "Testing: add_param()\n" if $debug;
$sv = $q->add_param();
@av = $q->add_param();
ok ( $sv, undef );    #124
ok ( (join' ',@av), '' );    #125

# add_param() - scalar and array context, existing param argument
print "Testing: add_param( 'foo', 'new' )\n" if $debug;
$q->add_param('foo', 'new');
@av  = $q->param('foo');
ok ( (join' ',@av), 'bar baz new' );    #126
$q->add_param('foo', [1,2,3,4,5]);
@av  = $q->param('foo');
ok ( (join' ',@av), 'bar baz new 1 2 3 4 5' );    #127

# add_param() - existing param argument, overwrite
print "Testing: add_param('foo', 'bar', 'overwrite' )\n" if $debug;
$q->add_param( 'foo', 'bar', 'overwrite' );
@av  = $q->param('foo');
ok ( (join' ',@av), 'bar' );    #128

# add_param() - scalar and array context, existing param argument
print "Testing: add_param(  'new', 'new'  )\n" if $debug;
$q->add_param( 'new', 'new%2C' );
@av  = $q->param('new');
ok ( (join' ',@av), 'new%2C' );    #129
$q->add_param('new', [1,2,3,4,5]);
@av  = $q->param('new');
ok ( (join' ',@av), 'new%2C 1 2 3 4 5' );    #130

# param_fetch() - scalar context, void argument
print "Testing: param_fetch()\n" if $debug;
$sv  = $q->param_fetch();
ok ( $sv, undef );    #131

# param_fetch() - scalar context, 'color' syntax
print "Testing: param_fetch( 'color' )\n" if $debug;
$sv  = $q->param_fetch( 'color' );
ok ( ref $sv, 'ARRAY' );    #132
ok ( (join' ',@$sv), 'red green blue' );    #133

# param_fetch() - scalar context, -name=>'color' syntax
print "Testing: param_fetch( -name=>'color' )\n" if $debug;
$sv  = $q->param_fetch( -name=>'color' );
ok ( ref $sv, 'ARRAY' );    #134
ok ( (join' ',@$sv), 'red green blue' );    #135

# url_param() - scalar and array context, void argument
print "Testing: url_param() void argument\n" if $debug;
$sv  = $q->url_param();
@av  = $q->url_param();
ok ( $sv, '2' );    #136
ok ( (join' ',@av), 'name color' );    #137

# url_param() - scalar and array context, single argument (valid)
print "Testing: url_param('color') single argument (valid)\n" if $debug;
$sv  = $q->url_param('color');
@av  = $q->url_param('color');
ok ( $sv, 'red' );    #138
ok ( (join' ',@av), 'red green blue' );    #139

# url_param() - scalar and array context, single argument (invalid)
print "Testing: url_param('invalid') single argument (invalid)\n" if $debug;
$sv  = $q->url_param('invalid');
@av  = $q->url_param('invalid');
ok ( $sv, undef );    #140
ok ( (join' ',@av), '' );    #141

# keywords() - scalar and array context, void argument
print "Testing: keywords()\n" if $debug;
$q = new CGI::Simple( 'here+are++++some%20keywords' );
$sv = $q->keywords;
@av = $q->keywords;
ok ( $sv, '4' );    #142
ok ( (join' ',@av), 'here are some keywords' );    #143

# keywords() - scalar and array context, array argument
print "Testing: keywords( 'foo', 'bar', 'baz' )\n" if $debug;
$sv  = $q->keywords( 'foo', 'bar', 'baz' );
@av  = $q->keywords( 'foo', 'bar', 'baz' );
ok ( $sv, '3' );    #144
ok ( (join' ',@av), 'foo bar baz' );    #145

# keywords() - scalar and array context, array ref argument
print "Testing: keywords( ['foo', 'man', 'chu'] )\n" if $debug;
$q = new CGI::Simple;
$sv  = $q->keywords( ['foo', 'man', 'chu'] );
@av  = $q->keywords( ['foo', 'man', 'chu'] );
ok ( $sv, '3' );    #146
ok ( (join' ',@av), 'foo man chu' );    #147

print "Testing: Vars() - tied interface\n" if $debug;
$sv     = $q->Vars();
ok ( $sv->{'color'}, "red\0green\0blue" );    #148
$sv->{'color'} = "foo\0bar\0baz";
ok( (join' ',$q->param('color')), 'foo bar baz');    #149

$q = new CGI::Simple;

# Vars() - hash context, void argument
print "Testing: Vars()\n" if $debug;
my %hv  = $q->Vars();
ok ( $hv{'name'}, 'JaPh,' );    #150

# Vars() - hash context, "|" argument
print "Testing: Vars(',')\n" if $debug;
%hv  = $q->Vars(',');
ok ( $hv{'color'}, 'red,green,blue' );    #151

# append() - scalar and array context, void argument
print "Testing: append()\n" if $debug;
$sv  = $q->append();
@av  = $q->append();
ok ( $sv, undef );    #152
ok ( (join'',@av), '' );    #153

# append() - scalar and array context, set values, valid param
print "Testing: append( 'foo', 'some' ) set values\n" if $debug;
$q->add_param( 'foo', 'bar', 'overwrite' );
$sv  = $q->append( 'foo', 'some' );
@av  = $q->append( 'foo', 'some-more' );
ok ( $sv, 'bar' );    #154
ok ( (join' ',@av), 'bar some some-more' );    #155

# append() - scalar and array context, set values, non-existant param
print "Testing: append( 'invalid', 'param' ) set values\n" if $debug;
$sv  = $q->append( 'invalid', 'param1' );
@av  = $q->append( 'invalid', 'param2' );;
ok ( $sv, 'param1' );    #156
ok ( (join' ',@av), 'param1 param2' );    #157
ok ( (join' ',$q->param('invalid')), 'param1 param2' );    #158

# append() - scalar and array context, set values
print "Testing: append( 'foo', 'some', 'new', 'values' ) set values\n" if $debug;
$sv  = $q->append( 'foo', 'some', 'new', 'values' );
@av  = $q->append( 'foo', 'even', 'more', 'stuff' );
ok ( $sv, 'bar' );    #159
ok ( (join' ',@av), 'bar some some-more some new values even more stuff' );    #160

# append() - scalar and array context
print "Testing: append( -name=>'foo', -value=>'bar' ) set values\n" if $debug;
$sv  = $q->append( -name=>'foo', -value=>'baz' );
@av  = $q->append( -name=>'foo', -value=>'xyz' );
ok ( $sv, 'bar' );    #161
ok ( (join' ',@av), 'bar some some-more some new values even more stuff baz xyz' );    #162

# append() - scalar and array context
print "Testing: append(-name=>'foo',-value=>['bar','baz']) set values\n" if $debug;
$sv  = $q->append( -name=>'foo', -value=>[1,2] );
@av  = $q->append( -name=>'foo', -value=>[3,4] );
ok ( $sv, 'bar' );    #163
ok ( (join' ',@av), 'bar some some-more some new values even more stuff baz xyz 1 2 3 4' );    #164

# delete() - void/valid argument
print "Testing: delete()\n" if $debug;
$q->delete();
ok ( (join' ',$q->param) , 'name color foo invalid' );    #165
$q->delete('foo');
ok ( (join' ',$q->param) , 'name color invalid' );    #166

# Delete() - void/valid argument
print "Testing: Delete()\n" if $debug;
$q->Delete();
ok ( (join' ',$q->param) , 'name color invalid' );    #167
$q->Delete('invalid');
ok ( (join' ',$q->param) , 'name color' );    #168

# delete_all() - scalar and array context, void/invalid/valid argument
print "Testing: delete_all()\n" if $debug;
$q->delete_all();
ok ( (join'',$q->param), '' );    #169
ok ( $q->globals, '10');    #170


$ENV{'CONTENT_TYPE'} = 'NOT multipart/form-data';
$q = new CGI::Simple;

# delete_all() - scalar and array context, void/invalid/valid argument
print "Testing: Delete_all()\n" if $debug;
ok ( (join' ',$q->param), 'name color' );    #171
$q->Delete_all();
ok ( (join'',$q->param), '' );    #172

$ENV{'CONTENT_TYPE'} = 'application/x-www-form-urlencoded';

# upload() - invalid CONTENT_TYPE
print "Testing: upload() - invalid CONTENT_TYPE\n" if $debug;
$sv = $q->upload();
ok ( $sv, undef );    #173
ok ( $q->cgi_error(), 'Oops! File uploads only work if you specify ENCTYPE="multipart/form-data" in your <FORM> tag' );    #174

$ENV{'CONTENT_TYPE'} = 'multipart/form-data';

# upload() - scalar and array context, void/invalid/valid argument
print "Testing: upload() - no files available\n" if $debug;
$sv = $q->upload();
@av = $q->upload();
ok ( $sv, undef );    #175
ok ( (join' ', @av), '' );    #176

# upload() - scalar and array context, files available, void arg
print "Testing: upload() - files available\n" if $debug;
$q->{'.filehandles'}->{$_} = $_ for qw( File1 File2 File3 );
$sv = $q->upload();
@av = $q->upload();
ok ( $sv, 3);    #177
ok ( (join' ', sort @av), 'File1 File2 File3' );    #178
$q->{'.filehandles'} = {};

# upload() - scalar context, valid argument
print "Testing: upload('/some/path/to/myfile') - real files\n" if $debug;
open FH, $tmpfile or carp "Can't read $tmpfile $!\n";
my $data = join'',<FH>;
ok ( $data && 1, 1); # make sure we have data    #179
seek FH, 0,0;
$q->{'.filehandles'}->{ '/some/path/to/myfile' } = \*FH;
my $handle = $q->upload( '/some/path/to/myfile' );
my $upload = join'', <$handle>;
ok ( $upload, $data );    #180

# upload() - scalar context, invalid argument
print "Testing: upload('invalid')\n" if $debug;
$sv = $q->upload('invalid');
ok( $sv, undef );    #181
ok( $q->cgi_error, "No filehandle for 'invalid'. Are uploads enabled (\$DISABLE_UPLOADS = 0)? Is \$POST_MAX big enough?" );    #182

print "Testing: upload( '/some/path/to/myfile', \"$tmpfile.bak\" ) - real files\n" if $debug;
my $ok = $q->upload( '/some/path/to/myfile', "$tmpfile.bak" );
ok ( $ok, 1 );    #183
open $handle, "$tmpfile.bak" or carp "Can't read $tmpfile.bak $!\n";
$upload = join'', <$handle>;
ok ( $upload, $data );    #184
$sv = $q->upload( '/some/path/to/myfile', "$tmpfile.bak" );
ok ( $sv, undef );    #185
unlink $tmpfile, "$tmpfile.bak";

$ENV{'CONTENT_TYPE'} = 'application/x-www-form-urlencoded';
$q = new CGI::Simple;

# query_string() - scalar and array context, void/invalid/valid argument
print "Testing: query_string()\n" if $debug;
$sv  = $q->query_string();
ok ( $sv, 'name=JaPh%2C&color=red&color=green&color=blue' );    #186

# parse_query_string()
print "Testing: parse_query_string()\n" if $debug;
$q->delete_all;
ok ( $q->param, 0 );    #187
$ENV{'REQUEST_METHOD'} = 'POST';
$q->parse_query_string();
$sv  = $q->query_string();
ok ( $sv, 'name=JaPh%2C&color=red&color=green&color=blue' );    #188
$ENV{'REQUEST_METHOD'} = 'GET';

# parse_keywordlist() - scalar and array context
print "Testing: parse_keywordlist()\n" if $debug;
$sv  = $q->parse_keywordlist('Just+another++Perl%20hacker%2C');
@av =  $q->parse_keywordlist('Just+another++Perl%20hacker%2C');
ok ( $sv, '4' );    #189
ok ( (join' ',@av), 'Just another Perl hacker,' );    #190


################ Save and Restore params from file ###############

# _init_from_file()
# save() - scalar and array context, void/invalid/valid argument
# save_parameters() - scalar and array context, void/invalid/valid argument

# all tested in constructor section

################ Miscelaneous Methods ################

$q = new CGI::Simple;

# escapeHTML()
print "Testing: escapeHTML()\n" if $debug;
$sv  = $q->escapeHTML();
ok ( $sv, undef );    #191
$sv  = $q->escapeHTML("<>&\"\012\015<>&\"\012\015", 0 );
ok( $sv, "&lt;&gt;&amp;&quot;\012\015&lt;&gt;&amp;&quot;\012\015" );    #192
$sv  = $q->escapeHTML("<>&\"\012\015<>&\"\012\015", 'newlines too' );
ok( $sv, "&lt;&gt;&amp;&quot;&#10;&#13;&lt;&gt;&amp;&quot;&#10;&#13;" );    #193

# unescapeHTML()
print "Testing: unescapeHTML()\n" if $debug;
$sv  = $q->unescapeHTML();
ok ( $sv, undef );    #194
$sv  = $q->unescapeHTML("&lt;&gt;&amp;&quot;&#10;&#13;&lt;&gt;&amp;&quot;&#10;&#13;" );
ok( $sv, "<>&\"\012\015<>&\"\012\015" );    #195


# put()
print "Testing: put()\n" if $debug;
ok ($q->put(''), 1 );    #196

# print()
print "Testing: print()\n" if $debug;
ok ($q->print(''), 1 );    #197


################# Cookie Methods ################


$q = new CGI::Simple;

# raw_cookie() - scalar and array context, void argument
print "Testing: raw_cookie()\n" if $debug;
$sv  = $q->raw_cookie();
@av  = $q->raw_cookie();
ok ( $sv, 'foo=a%20phrase; bar=yes%2C%20a%20phrase&I%20say;' );    #198
ok ( (join'',@av), 'foo=a%20phrase; bar=yes%2C%20a%20phrase&I%20say;' );    #199

# raw_cookie() - scalar and array context, valid argument
print "Testing: raw_cookie('foo')\n" if $debug;
$sv  = $q->raw_cookie('foo');
@av  = $q->raw_cookie('foo');
ok ( $sv, 'a%20phrase' );    #200
ok ( (join'',@av), 'a%20phrase' );    #201

# raw_cookie() - scalar and array context, invalid argument
print "Testing: raw_cookie('invalid')\n" if $debug;
$sv  = $q->raw_cookie('invalid');
@av  = $q->raw_cookie('invalid');
ok ( $sv, undef );    #202
ok ( (join'',@av), '' );    #203

# cookie() - scalar and array context, void argument
print "Testing: cookie()\n" if $debug;
$sv  = $q->cookie();
@av  = $q->cookie();
ok ( $sv, '2' );    #204
# fix OS perl version test bug
ok( (join' ',@av) eq 'foo bar' or (join' ',@av) eq 'bar foo'  );    #205

# cookie() - scalar and array context, valid argument, single value
print "Testing: cookie('foo')\n" if $debug;
$sv  = $q->cookie('foo');
@av  = $q->cookie('foo');
ok ( $sv, 'a phrase' );    #206
ok ( (join'',@av), 'a phrase' );    #207

# cookie() - scalar and array context, valid argument, multiple values
print "Testing: cookie('foo')\n" if $debug;
$sv  = $q->cookie('bar');
@av  = $q->cookie('bar');
ok ( $sv, 'yes, a phrase' );    #208
ok ( (join' ',@av), 'yes, a phrase I say' );    #209

# cookie() - scalar and array context, invalid argument
print "Testing: cookie('invalid')\n" if $debug;
$sv  = $q->cookie('invalid');
@av  = $q->cookie('invalid');
ok ( $sv, undef );    #210
ok ( (join'',@av), '' );    #211

my @vals = (   -name    => 'Password',
            -value   => ['superuser','god','open sesame','mydog woofie'],
            -expires => 'Mon, 11-Nov-2018 11:00:00 GMT',
            -domain  => '.nowhere.com',
            -path    => '/cgi-bin/database',
            -secure  => 1
         );

# cookie() - scalar and array context, full argument set, correct order
print "Testing: cookie(\@vals) correct order\n" if $debug;
$sv  = $q->cookie(@vals);
@av  = $q->cookie(@vals);
ok ( $sv, 'Password=superuser&god&open%20sesame&mydog%20woofie; domain=.nowhere.com; path=/cgi-bin/database; expires=Mon, 11-Nov-2018 11:00:00 GMT; secure' );    #212
ok ( (join'',@av), 'Password=superuser&god&open%20sesame&mydog%20woofie; domain=.nowhere.com; path=/cgi-bin/database; expires=Mon, 11-Nov-2018 11:00:00 GMT; secure' );    #213

# cookie() - scalar and array context, full argument set, incorrect order
print "Testing: cookie(\@vals) incorrect order\n" if $debug;
$sv  = $q->cookie(@vals[0,1,10,11,8,9,2,3,4,5,6,7]);
@av  = $q->cookie(@vals[0,1,10,11,8,9,2,3,4,5,6,7]);
ok ( $sv, 'Password=superuser&god&open%20sesame&mydog%20woofie; domain=.nowhere.com; path=/cgi-bin/database; expires=Mon, 11-Nov-2018 11:00:00 GMT; secure' );    #214
ok ( (join'',@av), 'Password=superuser&god&open%20sesame&mydog%20woofie; domain=.nowhere.com; path=/cgi-bin/database; expires=Mon, 11-Nov-2018 11:00:00 GMT; secure' );    #215
my $cookie = $sv; # save a cookie for header testing

# cookie() - scalar and array context, partial argument set
print "Testing: cookie( -name=>'foo', -value=>'bar' )\n" if $debug;
$sv  = $q->cookie( -name=>'foo', -value=>'bar' );
@av  = $q->cookie( -name=>'foo', -value=>'bar' );
ok ( $sv, 'foo=bar; path=/' );    #216
ok ( (join'',@av), 'foo=bar; path=/' );    #217

################# Header Methods ################

$q = new CGI::Simple

my $CRLF = $q->crlf;

# header() - scalar and array context, void argument
print "Testing: header()\n" if $debug;
$sv  = $q->header();
@av  = $q->header();
ok ( $sv, "Content-Type: text/html; charset=ISO-8859-1$CRLF$CRLF" );    #218
ok ( (join'',@av), "Content-Type: text/html; charset=ISO-8859-1$CRLF$CRLF" );    #219

# header() - scalar context, single argument
print "Testing: header('image/gif')\n" if $debug;
$sv  = $q->header('image/gif');
ok ( $sv, "Content-Type: image/gif$CRLF$CRLF" );    #220

@vals = (   -type=>'image/gif',
            -nph=>1,
            -status=>'402 Payment required',
            -expires=>'Mon, 11-Nov-2018 11:00:00 GMT',
            -cookie=>$cookie,
            -charset=>'utf-7',
            -attachment=>'foo.gif',
            -Cost=>'$2.00');

# header() - scalar context, complex header
print "Testing: header(\@vals) - complex header\n" if $debug;
$sv  = $q->header(@vals);
my $header = <<'HEADER';
HTTP/1.0 402 Payment required
Server: Apache - accept no substitutes
Status: 402 Payment required
Set-Cookie: Password=superuser&god&open%20sesame&mydog%20woofie; domain=.nowhere.com; path=/cgi-bin/database; expires=Mon, 11-Nov-2018 11:00:00 GMT; secure
Expires: Mon, 11-Nov-2018 11:00:00 GMT
Date: Tue, 11-Nov-2018 11:00:00 GMT
Content-Disposition: attachment; filename="foo.gif"
Cost: $2.00
Content-Type: image/gif
HEADER
$sv      =~ s/[\012\015]//g;
$header  =~ s/[\012\015]//g;
$sv      =~ s/(?:Expires|Date).*?GMT//g; # strip the time elements
$header  =~ s/(?:Expires|Date).*?GMT//g;    # strip the time elements
ok ( $sv, $header );    #221

# cache() - scalar and array context, void argument
print "Testing: cache()\n" if $debug;
$sv  = $q->cache();
ok ( $sv, undef );    #222

# cache() - scalar and array context, true argument, sets no cache paragma
print "Testing: cache(1)\n" if $debug;
$sv  = $q->cache(1);
ok ( $sv, 1 );    #223
$sv  = $q->header();
ok ( $sv =~ /Pragma: no-cache/, 1 );    #224

# no_cache() - scalar and array context, void argument
print "Testing: cache()\n" if $debug;
$sv  = $q->no_cache();
ok ( $sv, undef );    #225

# no_cache() - scalar and array context, true argument, sets no cache paragma
print "Testing: cache(1)\n" if $debug;
$sv  = $q->no_cache(1);
ok ( $sv, 1 );    #226
$sv  = $q->header();
ok ( ($sv =~ /Pragma: no-cache/ and $sv =~ /Expires:(.*?)GMT/ and $sv =~ /Date:$1GMT/) , 1 );    #227

# redirect() - scalar and array context, void argument
print "Testing: redirect()\n" if $debug;
$sv  = $q->redirect('http://a.galaxy.far.away.gov');
$header = <<'HEADER';
Status: 302 Moved
Expires: Tue, 13 Nov 2001 06:45:15 GMT
Date: Tue, 13 Nov 2001 06:45:15 GMT
Pragma: no-cache
Location: http://a.galaxy.far.away.gov
HEADER
$sv      =~ s/[\012\015]//g;
$header  =~ s/[\012\015]//g;
$sv      =~ s/(?:Expires|Date).*?GMT//g; # strip the time elements
$header  =~ s/(?:Expires|Date).*?GMT//g;    # strip the time elements
ok ( $sv, $header );    #228

# redirect() - scalar and array context, void argument
print "Testing: redirect() - nph\n" if $debug;
$sv  = $q->redirect( -uri=>'http://a.galaxy.far.away.gov', -nph=>1 );
$header = <<'HEADER';
HTTP/1.0 302 Moved
Server: Apache - accept no substitutes
Status: 302 Moved
Expires: Tue, 13 Nov 2001 06:49:24 GMT
Date: Tue, 13 Nov 2001 06:49:24 GMT
Pragma: no-cache
Location: http://a.galaxy.far.away.gov
HEADER
$sv      =~ s/[\012\015]//g;
$header  =~ s/[\012\015]//g;
$sv      =~ s/(?:Expires|Date).*?GMT//g;    # strip the time elements
$header  =~ s/(?:Expires|Date).*?GMT//g;    # strip the time elements
ok ( $sv, $header );    #229


################# Server Push Methods #################

$q = new CGI::Simple;

print "Testing: multipart_init()\n" if $debug;
$sv  = $q->multipart_init();
ok ( $sv, qr|Content-Type: multipart/x-mixed-replace;boundary="------- =_aaaaaaaaaa0"| );    #230
ok ( $sv, qr/--------- =_aaaaaaaaaa0$CRLF/ );    #231
$sv  = $q->multipart_init('this_is_the_boundary');
ok ( $sv, qr/boundary="this_is_the_boundary"/ );    #232
$sv  = $q->multipart_init(-boundary=>'this_is_another_boundary');
ok ( $sv, qr/boundary="this_is_another_boundary"/ );    #233

# multipart_start()
print "Testing: multipart_start()\n" if $debug;
$sv  = $q->multipart_start();
ok ( $sv, "Content-Type: text/html$CRLF$CRLF" );    #234
$sv  = $q->multipart_start('foo/bar');
ok ( $sv, "Content-Type: foo/bar$CRLF$CRLF" );    #235
$sv  = $q->multipart_start(-type=>'text/plain' );
ok ( $sv, "Content-Type: text/plain$CRLF$CRLF" );    #236

# multipart_end()
print "Testing: multipart_end()\n" if $debug;
$sv  = $q->multipart_end();
ok ( $sv, "$CRLF--this_is_another_boundary$CRLF" );    #237

# multipart_final() - scalar and array context, void/invalid/valid argument
print "Testing: multipart_final()\n" if $debug;
$sv  = $q->multipart_final();
ok ( $sv, qr|--this_is_another_boundary--| );    #238


################# Debugging Methods ################

# Dump() - scalar context, void argument
print "Testing: Dump()\n" if $debug;
$sv  = $q->Dump();
ok ( $sv =~ m/JaPh,/, 1 );    #239

# as_string()
print "Testing: as_string()\n" if $debug;
ok ( $q->as_string(), $q->Dump() );    #240

# cgi_error()
print "Testing: cgi_error()\n" if $debug;
$ENV{'REQUEST_METHOD'} = 'GET';
$ENV{'QUERY_STRING'} = '';
$q = CGI::Simple->new;
ok( $q->cgi_error, qr/400 No data received via method: GET/ );    #241
$ENV{'QUERY_STRING'} = 'name=JaPh%2C&color=red&color=green&color=blue';


############## cgi-lib.pl tests ################

# ReadParse() - scalar and array context, void/invalid/valid argument
print "Testing: ReadParse()\n" if $debug;
CGI::Simple::ReadParse();
ok ( $in{'name'}, 'JaPh,' );    #242
%in = ();
$q = new CGI::Simple;
$q->ReadParse();
ok ( $in{'name'}, 'JaPh,' );    #243
CGI::Simple::ReadParse(*field);
ok ( $field{'name'}, 'JaPh,' );    #244
%field = ();
$q = new CGI::Simple;
$q->ReadParse(*field);
ok ( $field{'name'}, 'JaPh,' );    #245
$q = $field{'CGI'};
ok ( $q->param('name'), 'JaPh,' );    #246

# SplitParam() - scalar and array context, void/invalid/valid argument
print "Testing: SplitParam()\n" if $debug;
ok ( (join ' ', $q->SplitParam($field{'color'})), 'red green blue' );    #247
ok ( (join ' ', CGI::Simple::SplitParam($field{'color'})), 'red green blue' );    #248
ok ( scalar $q->SplitParam($field{'color'}), 'red' );    #249
ok ( scalar CGI::Simple::SplitParam($field{'color'}), 'red' );    #250

# MethGet() - scalar and array context, void/invalid/valid argument
print "Testing: MethGet()\n" if $debug;
ok ( $q->MethGet, 1 );    #251

# MethPost() - scalar and array context, void/invalid/valid argument
print "Testing: MethPost()\n" if $debug;
ok ( ! $q->MethPost, 1 );    #252

# MyBaseUrl() - scalar and array context, void/invalid/valid argument
print "Testing: MyBaseUrl()\n" if $debug;
ok ( $q->MyBaseUrl, 'http://nowhere.com:8080/cgi-bin/foo.cgi' );    #253
$ENV{'SERVER_PORT'} = 80;
ok ( $q->MyBaseUrl, 'http://nowhere.com/cgi-bin/foo.cgi' );    #254
$ENV{'SERVER_PORT'} = 8080;

# MyURL() - scalar and array context, void/invalid/valid argument
print "Testing: MyURL()\n" if $debug;
ok ( $q->MyURL, 'http://nowhere.com:8080/cgi-bin/foo.cgi' );    #255

# MyFullUrl() - scalar and array context, void/invalid/valid argument
print "Testing: MyFullUrl()\n" if $debug;
ok ( $q->MyFullUrl, 'http://nowhere.com:8080/cgi-bin/foo.cgi/somewhere/else?name=JaPh%2C&color=red&color=green&color=blue' );    #256
$ENV{'QUERY_STRING'} = '';
$ENV{'PATH_INFO'}     ='';
ok ( $q->MyFullUrl, 'http://nowhere.com:8080/cgi-bin/foo.cgi' );    #257
$ENV{'QUERY_STRING'} = 'name=JaPh%2C&color=red&color=green&color=blue';
$ENV{'PATH_INFO'}             = '/somewhere/else';

# PrintHeader() - scalar and array context, void/invalid/valid argument
print "Testing: PrintHeader()\n" if $debug;
ok ( $q->PrintHeader, qr|Content-Type: text/html| );    #258

# HtmlTop() - scalar and array context, void/invalid/valid argument
print "Testing: HtmlTop()\n" if $debug;
ok ( $q->HtmlTop('$'), "<html>\n<head>\n<title>\$</title>\n</head>\n<body>\n<h1>\$</h1>\n" );    #259
ok ( CGI::Simple::HtmlTop('$'), "<html>\n<head>\n<title>\$</title>\n</head>\n<body>\n<h1>\$</h1>\n" );    #260

# HtmlBot() - scalar and array context, void/invalid/valid argument
print "Testing: HtmlBot()\n" if $debug;
ok ( $q->HtmlBot, "</body>\n</html>\n" );    #261

# PrintVariables() - scalar and array context, void/invalid/valid argument
print "Testing: PrintVariables()\n" if $debug;
ok ( $q->PrintVariables(\%field), qr/JaPh,/ );    #262

# PrintEnv() - scalar and array context, void/invalid/valid argument
print "Testing: PrintEnv()\n" if $debug;
ok ( $q->PrintEnv, qr/PATH_TRANSLATED/ );    #263

# CgiDie() - scalar and array context, void/invalid/valid argument

# CgiError() - scalar and array context, void/invalid/valid argument


################ Accessor Methods ################

$q = new CGI::Simple;

# version() - scalar context, void argument
print "Testing: version()\n" if $debug;
ok ( $q->version(), qr/[\d\.]+/ );    #264

# nph() - scalar context, void  argument
print "Testing: nph()\n" if $debug;
ok ( $q->nph(), $q->globals('NPH') );    #265

# nph() - scalar context, valid  argument
print "Testing: nph(42)\n" if $debug;
ok ( $q->nph(42), 42 );    #266
ok ( $q->globals('NPH'), 42 );    #267

# all_parameters() - array context, void/invalid/valid argument
print "Testing: all_parameters()\n" if $debug;
$sv = $q->all_parameters();
@av = $q->all_parameters();
ok ( $sv, 2 );    #268
ok ( (join' ',@av), 'name color' );    #269

# charset() - scalar context, void argument
print "Testing: charset()\n" if $debug;
$sv  = $q->charset();
ok ( $sv, 'utf-7'); # should remain reset to this from header method    #270

# charset() - scalar context, void argument
print "Testing: charset()\n" if $debug;
$sv  = $q->charset('Linear B');
ok ( $sv, 'Linear B');    #271
$sv  = $q->charset();
ok ( $sv, 'Linear B');    #272

# crlf() - scalar context, void argument
print "Testing: crlf()\n" if $debug;
$sv = $q->crlf();
ok ( $sv, qr/[\012\015]{1,2}/ );    #273

# globals() - scalar and array context, void argument
print "Testing: globals()\n" if $debug;
$sv  = $q->globals();
ok ( $sv, 10 );    #274
@av  = $q->globals();
ok ( (join' ',sort@av), 'DEBUG DISABLE_UPLOADS FATAL HEADERS_ONCE NO_NULL NO_UNDEF_PARAMS NPH POST_MAX USE_CGI_PM_DEFAULTS USE_PARAM_SEMICOLONS' );    #275

# globals() - scalar context, invalid argument
print "Testing: globals('FOO') - invalid arg\n" if $debug;
$sv  = $q->globals('FOO');
ok ( $sv, undef );    #276

# globals() - scalar context, valid argument
print "Testing: globals('VERSION') - valid arg\n" if $debug;
ok( $q->globals('VERSION', '3.1415' ), '3.1415' );    #277
ok( $q->globals('VERSION'), '3.1415' );    #278

# auth_type() - scalar context, void argument
print "Testing: auth_type()\n" if $debug;
$sv  = $q->auth_type();
ok ( $sv, 'PGP MD5 DES rot13' );    #279

# content_length() - scalar context, void argument
print "Testing: content_length()\n" if $debug;
$sv  = $q->content_length();
ok ( $sv, '42' );    #280

# content_type() - scalar context, void argument
print "Testing: content_type()\n" if $debug;
$sv  = $q->content_type();
ok ( $sv, 'application/x-www-form-urlencoded' );    #281

# document_root() - scalar context, void argument
print "Testing: document_root()\n" if $debug;
$sv  = $q->document_root();
ok ( $sv, '/vs/www/foo' );    #282

# gateway_interface() - scalar context, void argument
print "Testing: gateway_interface()\n" if $debug;
$sv  = $q->gateway_interface();
ok ( $sv, 'bleeding edge' );    #283

# path_translated() - scalar context, void argument
print "Testing: path_translated()\n" if $debug;
$sv  = $q->path_translated();
ok ( $sv, '/usr/local/somewhere/else' );    #284

# referer() - scalar context, void argument
print "Testing: referer()\n" if $debug;
$sv  = $q->referer();
ok ( $sv, 'xxx.sex.com' );    #285

# remote_addr() - scalar and array context, void/invalid/valid argument
print "Testing: remote_addr()\n" if $debug;
$sv  = $q->remote_addr();
ok ( $sv, '127.0.0.1' );    #286

# remote_host() - scalar context, void argument
print "Testing: remote_host()\n" if $debug;
$sv  = $q->remote_host();
ok ( $sv, 'localhost' );    #287

# remote_ident() - scalar context, void argument
print "Testing: remote_ident()\n" if $debug;
$sv  = $q->remote_ident();
ok ( $sv, 'None of your damn business' );    #288

# remote_user() - scalar context, void argument
print "Testing: remote_user()\n" if $debug;
$sv  = $q->remote_user();
ok ( $sv, 'Just another Perl hacker,' );    #289

# request_method() - scalar context, void argument
print "Testing: request_method()\n" if $debug;
$sv  = $q->request_method();
ok ( $sv, 'GET' );    #290

# script_name() - scalar context, void argument
print "Testing: script_name()\n" if $debug;
$sv  = $q->script_name();
ok ( $sv, '/cgi-bin/foo.cgi' );    #291

# server_name() - scalar context, void argument
print "Testing: server_name()\n" if $debug;
$sv  = $q->server_name();
ok ( $sv, 'nowhere.com' );    #292

# server_port() - scalar context, void argument
print "Testing: server_port()\n" if $debug;
$sv  = $q->server_port();
ok ( $sv, '8080' );    #293

# server_protocol() - scalar context, void argument
print "Testing: server_protocol()\n" if $debug;
$sv  = $q->server_protocol();
ok ( $sv, 'HTTP/1.0' );    #294

# server_software() - scalar context, void argument
print "Testing: server_software()\n" if $debug;
$sv  = $q->server_software();
ok ( $sv, 'Apache - accept no substitutes' );    #295

# user_name() - scalar context, void argument
print "Testing: user_name()\n" if $debug;
$sv  = $q->user_name();
ok ( $sv, 'spammer@nowhere.com' );    #296

# user_agent() - scalar context, void argument
print "Testing: user_agent()\n" if $debug;
$sv  = $q->user_agent();
ok ( $sv, 'LWP' );    #297

# user_agent() - scalar context, void argument
print "Testing: user_agent()\n" if $debug;
$sv  = $q->user_agent('lwp');
ok ( $sv, 1 );    #298
$sv  = $q->user_agent('mozilla');
ok ( $sv, '' );    #299

# virtual_host() - scalar context, void argument
print "Testing: virtual_host()\n" if $debug;
$sv  = $q->virtual_host();
ok ( $sv, 'the.vatican.org' );    #300

# path_info() - scalar and array context, void/valid argument
print "Testing: path_info()\n" if $debug;
$sv  = $q->path_info();
ok ( $sv, '/somewhere/else' );    #301
$sv  = $q->path_info('somewhere/else/again');
ok ( $sv, '/somewhere/else/again' );    #302
$sv  = $q->path_info();
ok ( $sv, '/somewhere/else/again' );    #303
$q->path_info('/somewhere/else');

# Accept() - scalar and array context, void argument
print "Testing: Accept()\n" if $debug;
$sv  = $q->Accept();
@av  = $q->Accept();
ok ( $sv, 5 );    #304
ok ( (join' ',sort@av), '*/* image/gif image/jpg text/html text/plain' );    #305

# Accept() - scalar context, invalid argument (matches '*/*'
print "Testing: Accept('foo/bar')\n" if $debug;
$sv  = $q->Accept('foo/bar');
ok ( $sv, '0.001' );    #306

# Accept() - scalar and array context, void argument
print "Testing: Accept()\n" if $debug;
$sv  = $q->Accept('*/*');
ok ( $sv, '0.001' );    #307

# http() - scalar and array context, void argument
print "Testing: http()\n" if $debug;
$sv  = $q->http();
@av  = $q->http();
ok ( $sv > 0 );    #308
ok ( $av[0] =~ m/HTTP/ );    #309

# http() - scalar context, invalid arguments
print "Testing: http('invalid arg')\n" if $debug;
$sv  = $q->http('http-hell');
ok ( $sv, undef );    #310
$sv  = $q->http('hell');
ok ( $sv, undef );    #311

# http() - scalar context, valid arguments
print "Testing: http('valid arg')\n" if $debug;
$sv  = $q->http('http-from');
ok ( $sv, 'spammer@nowhere.com' );    #312
$sv  = $q->http('from');
ok ( $sv, 'spammer@nowhere.com' );    #313

# https() - scalar and array context, void argument
print "Testing: https()\n" if $debug;
$sv  = $q->https();
ok ( $sv, 'ON' );    #314

# https() - scalar  context, invalid argument
print "Testing: https('invalid arg')\n" if $debug;
$sv  = $q->https('hell');
ok ( $sv, undef );    #315

# https() - scalar context, valid arguments
print "Testing: https('valid arg')\n" if $debug;
$sv  = $q->https('https-a');
ok ( $sv, 'A' );    #316
$sv  = $q->https('a');
ok ( $sv, 'A' );    #317

# protocol() - scalar context, void arguments
print "Testing: protocol()\n" if $debug;
$sv  = $q->protocol();
ok ( $sv, 'https' );    #318
$ENV{'HTTPS'} = 'OFF';
$ENV{'SERVER_PORT'} = '443';
$sv  = $q->protocol();
ok ( $sv, 'https' );    #319
$ENV{'SERVER_PORT'} = '8080';
$sv  = $q->protocol();
ok ( $sv, 'http' );    #320

# url() - scalar context, void argument
print "Testing: url()\n" if $debug;
$ENV{'HTTP_HOST'} = '';
ok( $q->url,  'http://nowhere.com:8080/cgi-bin/foo.cgi' );    #321

# url() - scalar context, valid argument
print "Testing: url()\n" if $debug;
ok( $q->url(-absolute=>1), '/cgi-bin/foo.cgi','CGI::url(-absolute=>1)');    #322

# url() - scalar context, valid argument
print "Testing: url(-relative=>1)\n" if $debug;
ok( $q->url(-relative=>1), 'foo.cgi' );    #323

# url() - scalar context, valid argument
print "Testing: url(-relative=>1,-path=>1)\n" if $debug;
ok( $q->url(-relative=>1,-path=>1), 'foo.cgi/somewhere/else' );    #324

# url() - scalar context, valid argument
print "Testing: url(-relative=>1,-path=>1,-query=>1)\n" if $debug;
ok( $q->url(-relative=>1,-path=>1,-query=>1), 'foo.cgi/somewhere/else?name=JaPh%2C&color=red&color=green&color=blue' );    #325

# self_url() - scalar context, void argument
print "Testing: self_url()\n" if $debug;
$sv  = $q->self_url();
@av  = $q->self_url();
ok( $sv , 'http://nowhere.com:8080/cgi-bin/foo.cgi/somewhere/else?name=JaPh%2C&color=red&color=green&color=blue' );    #326

# state() - scalar and array context, void/invalid/valid argument
print "Testing: state()\n" if $debug;
ok( $q->state(), $q->self_url() );    #327


################ Yet More Tests ################


print "Yet more tests\n" if $debug;
$CGI::Simple::POST_MAX = 20;
$ENV{'REQUEST_METHOD'} = 'POST';
$q = new CGI::Simple;
ok( $q->cgi_error, '413 Request entity too large: 42 bytes on STDIN exceeds $POST_MAX!' );    #328

$ENV{'REQUEST_METHOD'} = 'HEAD';
$ENV{'QUERY_STRING'} = '';
$ENV{'REDIRECT_QUERY_STRING'} = 'name=JAPH&color=red&color=green&color=blue';
$CGI::Simple::POST_MAX = 50;
$q = new CGI::Simple;
@av = $q->param;
ok ( (join' ',@av), 'name color' );    #329
@av = $q->param('color');
ok( (join' ',@av), 'red green blue' );    #330



################ Wrap Up ################


my $tests = $Test::ntest - 1;
my $fail = @Test::FAILDETAIL;
$ok = $tests - $fail;
print "\nCompleted $tests tests $ok/$tests OK, failed $fail/$tests\n";
printf "%3.1f%% of tests completed successfully, %3.1f%% failed\n" , $ok*100/$tests, $fail*100/$tests;
print "Please email \$VERSION, OS and test numbers failed
to jfreeman\@tassie.net.au so I can fix them
Set \$debug = 1 to see where tests are failing\n" if $fail;

if ($debug) {
    use Data::Dumper;
    print "\n",Dumper(@Test::FAILDETAIL);
}
