use lib qw(t/lib blib/lib blib/arch);
use Test;
use Carp;
use strict;
use vars qw(%field %in);
$|++;
BEGIN { plan tests => 302 }

use CGI::Simple::Standard qw( :all );;
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

restore_parameters();

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
restore_parameters();

# _initialize_globals()
print "Testing: _initialize_globals()\n" if $debug;
_initialize_globals();
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
_use_cgi_pm_global_settings();
restore_parameters();
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
$q = _cgi_object();
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
my @args = qw( -default -no_upload -unique_header -nph -no_debug -newstyle_url -no_undef_param  );

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

$q->import( qw ( -default -upload -no_undefparams -oldstyle_url -npheader -debug  ) );

ok( $CGI::Simple::USE_CGI_PM_DEFAULTS    , 1 );    #48
ok( $CGI::Simple::DISABLE_UPLOADS        , 0  );    #49
ok( $CGI::Simple::NO_UNDEF_PARAMS        , 1  );    #50
ok( $CGI::Simple::USE_PARAM_SEMICOLONS   , 0  );    #51
ok( $CGI::Simple::NPH                    , 1  );    #52
ok( $CGI::Simple::DEBUG                  , 2  );    #53

undef_globals();

# _reset_globals()
print "Testing: _reset_globals()\n" if $debug;
_reset_globals();
ok( $CGI::Simple::DISABLE_UPLOADS        , 0  );    #54
ok( $CGI::Simple::POST_MAX               , -1 );    #55
ok( $CGI::Simple::NO_UNDEF_PARAMS        , 0  );    #56
ok( $CGI::Simple::USE_PARAM_SEMICOLONS   , 1  );    #57
ok( $CGI::Simple::HEADERS_ONCE           , 0  );    #58
ok( $CGI::Simple::NPH                    , 0  );    #59
ok( $CGI::Simple::DEBUG                  , 1  );    #60
ok( $CGI::Simple::NO_NULL                , 0  );    #61
ok( $CGI::Simple::FATAL                  , -1 );    #62

undef_globals();

restore_parameters();

# url_decode() - scalar context, void argument
print "Testing: url_decode()\n" if $debug;
$sv  = url_decode();
ok ( $sv, undef );    #63

# url_decode() - scalar context, valid argument
print "Testing: url_decode(\$enc_string)\n" if $debug;
my ( $string, $enc_string );
for (32..255) { $string .= chr ; $enc_string .= uc sprintf "%%%02x", ord chr }
ok ( url_decode($enc_string), $string );    #64

# url_encode() - scalar context, void argument
print "Testing: url_encode()\n" if $debug;
$sv  = url_encode();
ok ( $sv, undef );    #65

# url_encode() - scalar context, valid argument
print "Testing: url_encode(\$string)\n" if $debug;
$sv  = url_encode($string);
$sv =~ tr/+/ /;
$sv =~ s/%([a-fA-F0-9]{2})/ pack "C", hex $1 /eg;
ok ( $sv, $string );    #66

# url encoding - circular test
print "Testing: url encoding via circular test\n" if $debug;
ok ( url_decode($q->url_encode($string)), $string );    #67

# new() plain constructor
print "Testing: new() plain constructor\n" if $debug;
restore_parameters();
ok( _cgi_object(), qr/CGI::Simple/ );    #68

# new() hash constructor
print "Testing: new() hash constructor\n" if $debug;
restore_parameters( { 'foo'=>'1', 'bar'=>[2,3,4] } );
@av = param();
# fix OS bug with testing
ok( (join' ',@av) eq 'foo bar' or (join' ',@av) eq 'bar foo'  );    #69
ok( param('foo'), 1);    #70
ok( param('bar'), 2 );    #71
@av = param('bar');
ok( (join'',@av), 234 );    #72
restore_parameters( 'foo=1&bar=2&bar=3&bar=4' );
open FH, ">$tmpfile", or carp "Can't create $tmpfile $!\n";
save_parameters(\*FH);
#close FH;

# new() query string constructor
print "Testing: new() query string constructor\n" if $debug;
restore_parameters( 'foo=5&bar=6&bar=7&bar=8' );
@av = param();
ok( (join' ',@av), 'foo bar' );    #73
ok( param('foo'), 5);    #74
ok( param('bar'), 6 );    #75
@av = param('bar');
ok( (join'',@av), 678 );    #76
open FH, ">>$tmpfile", or carp "Can't append $tmpfile $!\n";
save_parameters(\*FH);
close FH;

# new() file constructor
print "Testing: new() file constructor\n" if $debug;
open FH, $tmpfile, or carp "Can't open temp file\n";
ok( (join'',<FH>), "foo=1\nbar=2\nbar=3\nbar=4\n=\nfoo=5\nbar=6\nbar=7\nbar=8\n=\n" );    #77
close FH;
open FH, $tmpfile, or carp "Can't open temp file\n";
restore_parameters(\*FH);
close FH;
@av = param();
ok( (join' ',@av), 'foo bar' );    #78
ok( param('foo'), 1);    #79
ok( param('bar'), 2 );    #80
@av = param('bar');
ok( (join'',@av), 234 );    #81
# call new twice to read two sections of file
open FH, $tmpfile, or carp "Can't open temp file\n";
restore_parameters(\*FH);
@av = param();
ok( (join' ',@av), 'foo bar' );    #82
ok( param('foo'), 1);    #83
ok( param('bar'), 2 );    #84
@av = param('bar');
ok( (join'',@av), 234 );    #85
# call new again
restore_parameters(\*FH);
close FH;
@av = param();
ok( (join' ',@av), 'foo bar' );    #86
ok( param('foo'), 5);    #87
ok( param('bar'), 6 );    #88
@av = param('bar');
ok( (join'',@av), 678 );    #89

# new() \@ARGV constructor
print "Testing: new() \@ARGV constructor\n" if $debug;
$ENV{'REQUEST_METHOD'} = '';
$CGI::Simple::DEBUG = 1;
@ARGV = qw( foo=bar\=baz foo=bar\&baz );
restore_parameters();
ok( (join ' ', param('foo')), 'bar=baz bar&baz' );    #90
$ENV{'REQUEST_METHOD'} = 'GET';


################ The Core Methods ################

restore_parameters();

# param() - scalar and array context, void argument
print "Testing: param() void argument\n" if $debug;
$sv  = param();
@av = param();
ok ( $sv, '2' );    #91
ok ( (join' ',@av), 'name color' );    #92

# param() - scalar and array context, single argument (valid)
print "Testing: param('color') single argument (valid)\n" if $debug;
$sv = param('color');
@av = param('color');
ok ( $sv, 'red' );    #93
ok ( (join' ',@av), 'red green blue' );    #94

# param() - scalar and array context, single argument (invalid)
print "Testing: param('invalid') single argument (invalid)\n" if $debug;
$sv = param('invalid');
@av = param('invalid');
ok ( $sv, undef );    #95
ok ( (join' ',@av), '' );    #96

# param() - scalar and array context, -name=>'param' (valid)
print "Testing: param( -name=>'color' ) get values\n" if $debug;
$sv = param( -name=>'color' );
@av = param( -name=>'color' );
ok ( $sv, 'red' );    #97
ok ( (join' ',@av), 'red green blue' );    #98

# param() - scalar and array context, -name=>'param' (invalid)
print "Testing: param( -name=>'invalid' ) get values\n" if $debug;
$sv = param( -name=>'invalid' );
@av = param( -name=>'invalid' );
ok ( $sv, undef );    #99
ok ( (join' ',@av), '' );    #100

# param() - scalar and array context, set values
print "Testing: param( 'foo', 'some', 'new', 'values' ) set values\n" if $debug;
$sv = param( 'foo', 'some', 'new', 'values' );
@av = param( 'foo', 'some', 'new', 'values' );
ok ( $sv, 'some' );    #101
ok ( (join' ',@av), 'some new values' );    #102

# param() - scalar and array context
print "Testing: param( -name=>'foo', -value=>'bar' ) set values\n" if $debug;
$sv = param( -name=>'foo', -value=>'bar' );
@av = param( -name=>'foo', -value=>'bar' );
ok ( $sv, 'bar' );    #103
ok ( (join' ',@av), 'bar' );    #104

# param() - scalar and array context
print "Testing: param(-name=>'foo',-value=>['bar','baz']) set values\n" if $debug;
$sv = param( -name=>'foo', -value=>['bar','baz'] );
@av = param( -name=>'foo', -value=>['bar','baz'] );
ok ( $sv, 'bar' );    #105
ok ( (join' ',@av), 'bar baz' );    #106

# add_param() - scalar and array context, void argument
print "Testing: add_param()\n" if $debug;
$sv = add_param();
@av = add_param();
ok ( $sv, undef );    #107
ok ( (join' ',@av), '' );    #108

# add_param() - scalar and array context, existing param argument
print "Testing: add_param( 'foo', 'new' )\n" if $debug;
add_param('foo', 'new');
@av  = param('foo');
ok ( (join' ',@av), 'bar baz new' );    #109
add_param('foo', [1,2,3,4,5]);
@av  = param('foo');
ok ( (join' ',@av), 'bar baz new 1 2 3 4 5' );    #110

# add_param() - existing param argument, overwrite
print "Testing: add_param('foo', 'bar', 'overwrite' )\n" if $debug;
add_param( 'foo', 'bar', 'overwrite' );
@av  = param('foo');
ok ( (join' ',@av), 'bar' );    #111

# add_param() - scalar and array context, existing param argument
print "Testing: add_param(  'new', 'new'  )\n" if $debug;
add_param( 'new', 'new%2C' );
@av  = param('new');
ok ( (join' ',@av), 'new%2C' );    #112
add_param('new', [1,2,3,4,5]);
@av  = param('new');
ok ( (join' ',@av), 'new%2C 1 2 3 4 5' );    #113

# param_fetch() - scalar context, void argument
print "Testing: param_fetch()\n" if $debug;
$sv  = param_fetch();
ok ( $sv, undef );    #114

# param_fetch() - scalar context, 'color' syntax
print "Testing: param_fetch( 'color' )\n" if $debug;
$sv  = param_fetch( 'color' );
ok ( ref $sv, 'ARRAY' );    #115
ok ( (join' ',@$sv), 'red green blue' );    #116

# param_fetch() - scalar context, -name=>'color' syntax
print "Testing: param_fetch( -name=>'color' )\n" if $debug;
$sv  = param_fetch( -name=>'color' );
ok ( ref $sv, 'ARRAY' );    #117
ok ( (join' ',@$sv), 'red green blue' );    #118

# url_param() - scalar and array context, void argument
print "Testing: url_param() void argument\n" if $debug;
$sv  = url_param();
@av  = url_param();
ok ( $sv, '2' );    #119
ok ( (join' ',@av), 'name color' );    #120

# url_param() - scalar and array context, single argument (valid)
print "Testing: url_param('color') single argument (valid)\n" if $debug;
$sv  = url_param('color');
@av  = url_param('color');
ok ( $sv, 'red' );    #121
ok ( (join' ',@av), 'red green blue' );    #122

# url_param() - scalar and array context, single argument (invalid)
print "Testing: url_param('invalid') single argument (invalid)\n" if $debug;
$sv  = url_param('invalid');
@av  = url_param('invalid');
ok ( $sv, undef );    #123
ok ( (join' ',@av), '' );    #124

# keywords() - scalar and array context, void argument
print "Testing: keywords()\n" if $debug;
$ENV{'QUERY_STRING'} = 'here+are++++some%20keywords';
restore_parameters();
$sv = keywords();
@av = keywords();
ok ( $sv, '4' );    #125
ok ( (join' ',@av), 'here are some keywords' );    #126
$ENV{'QUERY_STRING'} = 'name=JaPh%2C&color=red&color=green&color=blue';

# keywords() - scalar and array context, array argument
print "Testing: keywords( 'foo', 'bar', 'baz' )\n" if $debug;
$sv  = keywords( 'foo', 'bar', 'baz' );
@av  = keywords( 'foo', 'bar', 'baz' );
ok ( $sv, '3' );    #127
ok ( (join' ',@av), 'foo bar baz' );    #128

# keywords() - scalar and array context, array ref argument
print "Testing: keywords( ['foo', 'man', 'chu'] )\n" if $debug;
restore_parameters();
$sv  = keywords( ['foo', 'man', 'chu'] );
@av  = keywords( ['foo', 'man', 'chu'] );
ok ( $sv, '3' );    #129
ok ( (join' ',@av), 'foo man chu' );    #130

# Vars() - scalar and array context, void argument
print "Testing: Vars()\n" if $debug;
$sv     = Vars();
my %hv  = Vars();
ok ( $sv->{'color'}, "red\0green\0blue" );    #131
ok ( $hv{'name'}, 'JaPh,' );    #132

# Vars() - hash context, "|" argument
print "Testing: Vars('|')\n" if $debug;
%hv  = Vars('|');
ok ( $hv{'color'}, 'red|green|blue' );    #133

# append() - scalar and array context, void argument
print "Testing: append()\n" if $debug;
$sv  = append();
@av  = append();
ok ( $sv, undef );    #134
ok ( (join'',@av), '' );    #135

# append() - scalar and array context, set values, valid param
print "Testing: append( 'foo', 'some' ) set values\n" if $debug;
add_param( 'foo', 'bar', 'overwrite' );
$sv  = append( 'foo', 'some' );
@av  = append( 'foo', 'some-more' );
ok ( $sv, 'bar' );    #136
ok ( (join' ',@av), 'bar some some-more' );    #137

# append() - scalar and array context, set values, non-existant param
print "Testing: append( 'invalid', 'param' ) set values\n" if $debug;
$sv  = append( 'invalid', 'param1' );
@av  = append( 'invalid', 'param2' );;
ok ( $sv, 'param1' );    #138
ok ( (join' ',@av), 'param1 param2' );    #139
ok ( (join' ',param('invalid')), 'param1 param2' );    #140

# append() - scalar and array context, set values
print "Testing: append( 'foo', 'some', 'new', 'values' ) set values\n" if $debug;
$sv  = append( 'foo', 'some', 'new', 'values' );
@av  = append( 'foo', 'even', 'more', 'stuff' );
ok ( $sv, 'bar' );    #141
ok ( (join' ',@av), 'bar some some-more some new values even more stuff' );    #142

# append() - scalar and array context
print "Testing: append( -name=>'foo', -value=>'bar' ) set values\n" if $debug;
$sv  = append( -name=>'foo', -value=>'baz' );
@av  = append( -name=>'foo', -value=>'xyz' );
ok ( $sv, 'bar' );    #143
ok ( (join' ',@av), 'bar some some-more some new values even more stuff baz xyz' );    #144

# append() - scalar and array context
print "Testing: append(-name=>'foo',-value=>['bar','baz']) set values\n" if $debug;
$sv  = append( -name=>'foo', -value=>[1,2] );
@av  = append( -name=>'foo', -value=>[3,4] );
ok ( $sv, 'bar' );    #145
ok ( (join' ',@av), 'bar some some-more some new values even more stuff baz xyz 1 2 3 4' );    #146

# delete() - void/valid argument
print "Testing: delete()\n" if $debug;
Delete();
ok ( (join' ',param()) , 'name color foo invalid' );    #147
Delete('foo');
ok ( (join' ',param()) , 'name color invalid' );    #148

# Delete() - void/valid argument
print "Testing: Delete()\n" if $debug;
Delete();
ok ( (join' ',param()) , 'name color invalid' );    #149
Delete('invalid');
ok ( (join' ',param()) , 'name color' );    #150

# delete_all() - scalar and array context, void/invalid/valid argument
print "Testing: delete_all()\n" if $debug;
delete_all();
ok ( (join'',param()), '' );    #151
ok ( globals(), '10');    #152

restore_parameters();

# delete_all() - scalar and array context, void/invalid/valid argument
print "Testing: Delete_all()\n" if $debug;
ok ( (join' ',param()), 'name color' );    #153
Delete_all();
ok ( (join'',param()), '' );    #154

$ENV{'CONTENT_TYPE'} = 'multipart/form-data';

# upload() - scalar and array context, void/invalid/valid argument
print "Testing: upload() - no files available\n" if $debug;
$sv = upload();
@av = upload();
ok ( $sv, undef );    #155
ok ( (join' ', @av), '' );    #156

# upload() - scalar and array context, files available, void arg
print "Testing: upload() - files available\n" if $debug;
$q = _cgi_object();
$q->{'.filehandles'}->{$_} = $_ for qw( File1 File2 File3 );
$sv = upload();
@av = upload();
ok ( $sv, 3);    #157
ok ( (join' ', sort @av), 'File1 File2 File3' );    #158
$q->{'.filehandles'} = {};

# upload() - scalar context, valid argument
print "Testing: upload('/some/path/to/myfile') - real files\n" if $debug;
open FH, $tmpfile or carp "Can't read $tmpfile $!\n";
my $data = join'',<FH>;
ok ( $data && 1, 1); # make sure we have data    #159
seek FH, 0,0;
$q->{'.filehandles'}->{ '/some/path/to/myfile' } = \*FH;
my $handle = upload( '/some/path/to/myfile' );
my $upload = join'', <$handle>;
ok ( $upload, $data );    #160

# upload() - scalar context, invalid argument
print "Testing: upload('invalid')\n" if $debug;
$sv = upload('invalid');
ok( $sv, undef );    #161
ok( cgi_error, "No filehandle for 'invalid'. Are uploads enabled (\$DISABLE_UPLOADS = 0)? Is \$POST_MAX big enough?" );    #162

print "Testing: upload( '/some/path/to/myfile', \"$tmpfile.bak\" ) - real files\n" if $debug;
my $ok = upload( '/some/path/to/myfile', "$tmpfile.bak" );
ok ( $ok, 1 );    #163
open $handle, "$tmpfile.bak" or carp "Can't read $tmpfile.bak $!\n";
$upload = join'', <$handle>;
ok ( $upload, $data );    #164
$sv = upload( '/some/path/to/myfile', "$tmpfile.bak" );
ok ( $sv, undef );    #165
unlink $tmpfile, "$tmpfile.bak";

$ENV{'CONTENT_TYPE'} = 'application/x-www-form-urlencoded';

restore_parameters();

# query_string() - scalar and array context, void/invalid/valid argument
print "Testing: query_string()\n" if $debug;
$sv  = query_string();
ok ( $sv, 'name=JaPh%2C&color=red&color=green&color=blue' );    #166

# parse_query_string()
print "Testing: parse_query_string()\n" if $debug;
delete_all();
ok ( param(), 0 );    #167
$ENV{'REQUEST_METHOD'} = 'POST';
parse_query_string();
$sv  = query_string();
ok ( $sv, 'name=JaPh%2C&color=red&color=green&color=blue' );    #168
$ENV{'REQUEST_METHOD'} = 'GET';

# parse_keywordlist() - scalar and array context
print "Testing: parse_keywordlist()\n" if $debug;
$sv  = parse_keywordlist('Just+another++Perl%20hacker%2C');
@av =  parse_keywordlist('Just+another++Perl%20hacker%2C');
ok ( $sv, '4' );    #169
ok ( (join' ',@av), 'Just another Perl hacker,' );    #170


################ Save and Restore params from file ###############

# _init_from_file()
# save() - scalar and array context, void/invalid/valid argument
# save_parameters() - scalar and array context, void/invalid/valid argument

# all tested in constructor section

################ Miscelaneous Methods ################

restore_parameters();

# escapeHTML()
print "Testing: escapeHTML()\n" if $debug;
$sv  = escapeHTML();
ok ( $sv, undef );    #171
$sv  = escapeHTML("<>&\"\012\015<>&\"\012\015", 0 );
ok( $sv, "&lt;&gt;&amp;&quot;\012\015&lt;&gt;&amp;&quot;\012\015" );    #172
$sv  = escapeHTML("<>&\"\012\015<>&\"\012\015", 'newlines too' );
ok( $sv, "&lt;&gt;&amp;&quot;&#10;&#13;&lt;&gt;&amp;&quot;&#10;&#13;" );    #173

# unescapeHTML()
print "Testing: unescapeHTML()\n" if $debug;
$sv  = unescapeHTML();
ok ( $sv, undef );    #174
$sv  = unescapeHTML("&lt;&gt;&amp;&quot;&#10;&#13;&lt;&gt;&amp;&quot;&#10;&#13;" );
ok( $sv, "<>&\"\012\015<>&\"\012\015" );    #175


# put()
print "Testing: put()\n" if $debug;
ok (put(''), 1 );    #176

# print()
print "Testing: print()\n" if $debug;
ok (print(''), 1 );    #177


################# Cookie Methods ################


restore_parameters();

# raw_cookie() - scalar and array context, void argument
print "Testing: raw_cookie()\n" if $debug;
$sv  = raw_cookie();
@av  = raw_cookie();
ok ( $sv, 'foo=a%20phrase; bar=yes%2C%20a%20phrase&I%20say;' );    #178
ok ( (join'',@av), 'foo=a%20phrase; bar=yes%2C%20a%20phrase&I%20say;' );    #179

# raw_cookie() - scalar and array context, valid argument
print "Testing: raw_cookie('foo')\n" if $debug;
$sv  = raw_cookie('foo');
@av  = raw_cookie('foo');
ok ( $sv, 'a%20phrase' );    #180
ok ( (join'',@av), 'a%20phrase' );    #181

# raw_cookie() - scalar and array context, invalid argument
print "Testing: raw_cookie('invalid')\n" if $debug;
$sv  = raw_cookie('invalid');
@av  = raw_cookie('invalid');
ok ( $sv, undef );    #182
ok ( (join'',@av), '' );    #183

# cookie() - scalar and array context, void argument
print "Testing: cookie()\n" if $debug;
$sv  = cookie();
@av  = cookie();
ok ( $sv, '2' );    #184
# fix OS perl version test bug
ok( (join' ',@av) eq 'foo bar' or (join' ',@av) eq 'bar foo'  );     #185

# cookie() - scalar and array context, valid argument, single value
print "Testing: cookie('foo')\n" if $debug;
$sv  = cookie('foo');
@av  = cookie('foo');
ok ( $sv, 'a phrase' );    #186
ok ( (join'',@av), 'a phrase' );    #187

# cookie() - scalar and array context, valid argument, multiple values
print "Testing: cookie('foo')\n" if $debug;
$sv  = cookie('bar');
@av  = cookie('bar');
ok ( $sv, 'yes, a phrase' );    #188
ok ( (join' ',@av), 'yes, a phrase I say' );    #189

# cookie() - scalar and array context, invalid argument
print "Testing: cookie('invalid')\n" if $debug;
$sv  = cookie('invalid');
@av  = cookie('invalid');
ok ( $sv, undef );    #190
ok ( (join'',@av), '' );    #191

my @vals = (-name    => 'Password',
            -value   => ['superuser','god','open sesame','mydog woofie'],
            -expires => 'Mon, 11-Nov-2018 11:00:00 GMT',
            -domain  => '.nowhere.com',
            -path    => '/cgi-bin/database',
            -secure  => 1
         );

# cookie() - scalar and array context, full argument set, correct order
print "Testing: cookie(\@vals) correct order\n" if $debug;
$sv  = cookie(@vals);
@av  = cookie(@vals);
ok ( $sv, 'Password=superuser&god&open%20sesame&mydog%20woofie; domain=.nowhere.com; path=/cgi-bin/database; expires=Mon, 11-Nov-2018 11:00:00 GMT; secure' );    #192
ok ( (join'',@av), 'Password=superuser&god&open%20sesame&mydog%20woofie; domain=.nowhere.com; path=/cgi-bin/database; expires=Mon, 11-Nov-2018 11:00:00 GMT; secure' );    #193

# cookie() - scalar and array context, full argument set, incorrect order
print "Testing: cookie(\@vals) incorrect order\n" if $debug;
$sv  = cookie(@vals[0,1,10,11,8,9,2,3,4,5,6,7]);
@av  = cookie(@vals[0,1,10,11,8,9,2,3,4,5,6,7]);
ok ( $sv, 'Password=superuser&god&open%20sesame&mydog%20woofie; domain=.nowhere.com; path=/cgi-bin/database; expires=Mon, 11-Nov-2018 11:00:00 GMT; secure' );    #194
ok ( (join'',@av), 'Password=superuser&god&open%20sesame&mydog%20woofie; domain=.nowhere.com; path=/cgi-bin/database; expires=Mon, 11-Nov-2018 11:00:00 GMT; secure' );    #195
my $cookie = $sv; # save a cookie for header testing

# cookie() - scalar and array context, partial argument set
print "Testing: cookie( -name=>'foo', -value=>'bar' )\n" if $debug;
$sv  = cookie( -name=>'foo', -value=>'bar' );
@av  = cookie( -name=>'foo', -value=>'bar' );
ok ( $sv, 'foo=bar; path=/' );    #196
ok ( (join'',@av), 'foo=bar; path=/' );    #197

################# Header Methods ################

$q = new CGI::Simple

my $CRLF = crlf();

# header() - scalar and array context, void argument
print "Testing: header()\n" if $debug;
$sv  = header();
@av  = header();
ok ( $sv, "Content-Type: text/html; charset=ISO-8859-1$CRLF$CRLF" );    #198
ok ( (join'',@av), "Content-Type: text/html; charset=ISO-8859-1$CRLF$CRLF" );    #199

# header() - scalar context, single argument
print "Testing: header('image/gif')\n" if $debug;
$sv  = header('image/gif');
ok ( $sv, "Content-Type: image/gif$CRLF$CRLF" );    #200

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
$sv  = header(@vals);
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
ok ( $sv, $header );    #201

# cache() - scalar and array context, void argument
print "Testing: cache()\n" if $debug;
$sv  = cache();
ok ( $sv, undef );    #202

# cache() - scalar and array context, true argument, sets no cache paragma
print "Testing: cache(1)\n" if $debug;
$sv  = cache(1);
ok ( $sv, 1 );    #203
$sv  = header();
ok ( $sv =~ /Pragma: no-cache/, 1 );    #204

# no_cache() - scalar and array context, void argument
print "Testing: cache()\n" if $debug;
$sv  = no_cache();
ok ( $sv, undef );    #205

# no_cache() - scalar and array context, true argument, sets no cache paragma
print "Testing: cache(1)\n" if $debug;
$sv  = no_cache(1);
ok ( $sv, 1 );    #206
$sv  = header();
ok ( ($sv =~ /Pragma: no-cache/ and $sv =~ /Expires:(.*?)GMT/ and $sv =~ /Date:$1GMT/) , 1 );    #207

# redirect() - scalar and array context, void argument
print "Testing: redirect()\n" if $debug;
$sv  = redirect('http://a.galaxy.far.away.gov');
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
ok ( $sv, $header );    #208

# redirect() - scalar and array context, void argument
print "Testing: redirect() - nph\n" if $debug;
$sv  = redirect( -uri=>'http://a.galaxy.far.away.gov', -nph=>1 );
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
ok ( $sv, $header );    #209


################# Server Push Methods #################

restore_parameters();

print "Testing: multipart_init()\n" if $debug;
$sv  = multipart_init();
ok ( $sv, qr|Content-Type: multipart/x-mixed-replace;boundary="------- =_aaaaaaaaaa0"| );    #210
ok ( $sv, qr/--------- =_aaaaaaaaaa0$CRLF/ );    #211
$sv  = multipart_init('this_is_the_boundary');
ok ( $sv, qr/boundary="this_is_the_boundary"/ );    #212
$sv  = multipart_init(-boundary=>'this_is_another_boundary');
ok ( $sv, qr/boundary="this_is_another_boundary"/ );    #213

# multipart_start()
print "Testing: multipart_start()\n" if $debug;
$sv  = multipart_start();
ok ( $sv, "Content-Type: text/html$CRLF$CRLF" );    #214
$sv  = multipart_start('foo/bar');
ok ( $sv, "Content-Type: foo/bar$CRLF$CRLF" );    #215
$sv  = multipart_start(-type=>'text/plain' );
ok ( $sv, "Content-Type: text/plain$CRLF$CRLF" );    #216

# multipart_end()
print "Testing: multipart_end()\n" if $debug;
$sv  = multipart_end();
ok ( $sv, "$CRLF--this_is_another_boundary$CRLF" );    #217

# multipart_final() - scalar and array context, void/invalid/valid argument
print "Testing: multipart_final()\n" if $debug;
$sv  = multipart_final();
ok ( $sv, qr|--this_is_another_boundary--| );    #218


################# Debugging Methods ################

# Dump() - scalar context, void argument
print "Testing: Dump()\n" if $debug;
$sv  = Dump();
ok ( $sv =~ m/JaPh,/, 1 );    #219

# as_string()
print "Testing: as_string()\n" if $debug;
ok ( as_string(), Dump() );    #220

# cgi_error()
print "Testing: cgi_error()\n" if $debug;
$ENV{'REQUEST_METHOD'} = 'GET';
$ENV{'QUERY_STRING'} = '';
restore_parameters();
ok( cgi_error(), qr/400 No data received via method: GET/ );    #221
$ENV{'QUERY_STRING'} = 'name=JaPh%2C&color=red&color=green&color=blue';


############## cgi-lib.pl tests ################

# ReadParse() - scalar and array context, void/invalid/valid argument
print "Testing: ReadParse()\n" if $debug;
restore_parameters();
ReadParse();
#ok ( $in{'name'}, 'JaPh,' );    #222
restore_parameters();
ReadParse(*field);
ok ( $field{'name'}, 'JaPh,' );    #223

# SplitParam() - scalar and array context, void/invalid/valid argument
print "Testing: SplitParam()\n" if $debug;
ok ( (join ' ', SplitParam($field{'color'})), 'red green blue' );    #224
ok ( scalar SplitParam($field{'color'}), 'red' );    #225

# MethGet() - scalar and array context, void/invalid/valid argument
print "Testing: MethGet()\n" if $debug;
ok ( MethGet(), 1 );    #226

# MethPost() - scalar and array context, void/invalid/valid argument
print "Testing: MethPost()\n" if $debug;
ok ( ! MethPost(), 1 );    #227

# MyBaseUrl() - scalar and array context, void/invalid/valid argument
print "Testing: MyBaseUrl()\n" if $debug;
ok ( MyBaseUrl(), 'http://nowhere.com:8080/cgi-bin/foo.cgi' );    #228
$ENV{'SERVER_PORT'} = 80;
ok ( MyBaseUrl(), 'http://nowhere.com/cgi-bin/foo.cgi' );    #229
$ENV{'SERVER_PORT'} = 8080;

# MyURL() - scalar and array context, void/invalid/valid argument
print "Testing: MyURL()\n" if $debug;
ok ( MyURL(), 'http://nowhere.com:8080/cgi-bin/foo.cgi' );    #230

# MyFullUrl() - scalar and array context, void/invalid/valid argument
print "Testing: MyFullUrl()\n" if $debug;
ok ( MyFullUrl(), 'http://nowhere.com:8080/cgi-bin/foo.cgi/somewhere/else?name=JaPh%2C&color=red&color=green&color=blue' );    #231
$ENV{'QUERY_STRING'} = '';
$ENV{'PATH_INFO'}     ='';
ok ( MyFullUrl(), 'http://nowhere.com:8080/cgi-bin/foo.cgi' );    #232
$ENV{'QUERY_STRING'} = 'name=JaPh%2C&color=red&color=green&color=blue';
$ENV{'PATH_INFO'}             = '/somewhere/else';

# PrintHeader() - scalar and array context, void/invalid/valid argument
print "Testing: PrintHeader()\n" if $debug;
ok ( PrintHeader(), qr|Content-Type: text/html| );    #233

# HtmlTop() - scalar and array context, void/invalid/valid argument
print "Testing: HtmlTop()\n" if $debug;
ok ( HtmlTop('$'), "<html>\n<head>\n<title>\$</title>\n</head>\n<body>\n<h1>\$</h1>\n" );    #234

# HtmlBot() - scalar and array context, void/invalid/valid argument
print "Testing: HtmlBot()\n" if $debug;
ok ( HtmlBot(), "</body>\n</html>\n" );    #235

# PrintVariables() - scalar and array context, void/invalid/valid argument
print "Testing: PrintVariables()\n" if $debug;
ok ( PrintVariables(\%field), qr/JaPh,/ );    #236

# PrintEnv() - scalar and array context, void/invalid/valid argument
print "Testing: PrintEnv()\n" if $debug;
ok ( PrintEnv(), qr/PATH_TRANSLATED/ );    #237

# CgiDie() - scalar and array context, void/invalid/valid argument

# CgiError() - scalar and array context, void/invalid/valid argument


################ Accessor Methods ################

restore_parameters();

# version() - scalar context, void argument
print "Testing: version()\n" if $debug;
ok ( version(), qr/[\d\.]+/ );    #238

# nph() - scalar context, void  argument
print "Testing: nph()\n" if $debug;
ok ( nph(), globals('NPH') );    #239

# nph() - scalar context, valid  argument
print "Testing: nph(42)\n" if $debug;
ok ( nph(42), 42 );    #240
ok ( globals('NPH'), 42 );    #241

# all_parameters() - array context, void/invalid/valid argument
print "Testing: all_parameters()\n" if $debug;
$sv = all_parameters();
@av = all_parameters();
ok ( $sv, 2 );    #242
ok ( (join' ',@av), 'name color' );    #243

# charset() - scalar context, void argument
print "Testing: charset()\n" if $debug;
$sv  = charset();
ok ( $sv, 'utf-7'); # should remain reset to this from header method    #244

# charset() - scalar context, void argument
print "Testing: charset()\n" if $debug;
$sv  = charset('Linear B');
ok ( $sv, 'Linear B');    #245
$sv  = charset();
ok ( $sv, 'Linear B');    #246

# crlf() - scalar context, void argument
print "Testing: crlf()\n" if $debug;
$sv = crlf();
ok ( $sv, qr/[\012\015]{1,2}/ );    #247

# globals() - scalar and array context, void argument
print "Testing: globals()\n" if $debug;
$sv  = globals();
ok ( $sv, 10 );    #248
@av  = globals();
ok ( (join' ',sort@av), 'DEBUG DISABLE_UPLOADS FATAL HEADERS_ONCE NO_NULL NO_UNDEF_PARAMS NPH POST_MAX USE_CGI_PM_DEFAULTS USE_PARAM_SEMICOLONS' );    #249

# globals() - scalar context, invalid argument
print "Testing: globals('FOO') - invalid arg\n" if $debug;
$sv  = globals('FOO');
ok ( $sv, undef );    #250

# globals() - scalar context, valid argument
print "Testing: globals('VERSION') - valid arg\n" if $debug;
ok( globals('VERSION', '3.1415' ), '3.1415' );    #251
ok( globals('VERSION'), '3.1415' );    #252

# auth_type() - scalar context, void argument
print "Testing: auth_type()\n" if $debug;
$sv  = auth_type();
ok ( $sv, 'PGP MD5 DES rot13' );    #253

# content_length() - scalar context, void argument
print "Testing: content_length()\n" if $debug;
$sv  = content_length();
ok ( $sv, '42' );    #254

# content_type() - scalar context, void argument
print "Testing: content_type()\n" if $debug;
$sv  = content_type();
ok ( $sv, 'application/x-www-form-urlencoded' );    #255

# document_root() - scalar context, void argument
print "Testing: document_root()\n" if $debug;
$sv  = document_root();
ok ( $sv, '/vs/www/foo' );    #256

# gateway_interface() - scalar context, void argument
print "Testing: gateway_interface()\n" if $debug;
$sv  = gateway_interface();
ok ( $sv, 'bleeding edge' );    #257

# path_translated() - scalar context, void argument
print "Testing: path_translated()\n" if $debug;
$sv  = path_translated();
ok ( $sv, '/usr/local/somewhere/else' );    #258

# referer() - scalar context, void argument
print "Testing: referer()\n" if $debug;
$sv  = referer();
ok ( $sv, 'xxx.sex.com' );    #259

# remote_addr() - scalar and array context, void/invalid/valid argument
print "Testing: remote_addr()\n" if $debug;
$sv  = remote_addr();
ok ( $sv, '127.0.0.1' );    #260

# remote_host() - scalar context, void argument
print "Testing: remote_host()\n" if $debug;
$sv  = remote_host();
ok ( $sv, 'localhost' );    #261

# remote_ident() - scalar context, void argument
print "Testing: remote_ident()\n" if $debug;
$sv  = remote_ident();
ok ( $sv, 'None of your damn business' );    #262

# remote_user() - scalar context, void argument
print "Testing: remote_user()\n" if $debug;
$sv  = remote_user();
ok ( $sv, 'Just another Perl hacker,' );    #263

# request_method() - scalar context, void argument
print "Testing: request_method()\n" if $debug;
$sv  = request_method();
ok ( $sv, 'GET' );    #264

# script_name() - scalar context, void argument
print "Testing: script_name()\n" if $debug;
$sv  = script_name();
ok ( $sv, '/cgi-bin/foo.cgi' );    #265

# server_name() - scalar context, void argument
print "Testing: server_name()\n" if $debug;
$sv  = server_name();
ok ( $sv, 'nowhere.com' );    #266

# server_port() - scalar context, void argument
print "Testing: server_port()\n" if $debug;
$sv  = server_port();
ok ( $sv, '8080' );    #267

# server_protocol() - scalar context, void argument
print "Testing: server_protocol()\n" if $debug;
$sv  = server_protocol();
ok ( $sv, 'HTTP/1.0' );    #268

# server_software() - scalar context, void argument
print "Testing: server_software()\n" if $debug;
$sv  = server_software();
ok ( $sv, 'Apache - accept no substitutes' );    #269

# user_name() - scalar context, void argument
print "Testing: user_name()\n" if $debug;
$sv  = user_name();
ok ( $sv, 'spammer@nowhere.com' );    #270

# user_agent() - scalar context, void argument
print "Testing: user_agent()\n" if $debug;
$sv  = user_agent();
ok ( $sv, 'LWP' );    #271

# user_agent() - scalar context, void argument
print "Testing: user_agent()\n" if $debug;
$sv  = user_agent('lwp');
ok ( $sv, 1 );    #272
$sv  = user_agent('mozilla');
ok ( $sv, '' );    #273

# virtual_host() - scalar context, void argument
print "Testing: virtual_host()\n" if $debug;
$sv  = virtual_host();
ok ( $sv, 'the.vatican.org' );    #274

# path_info() - scalar and array context, void/valid argument
print "Testing: path_info()\n" if $debug;
$sv  = path_info();
ok ( $sv, '/somewhere/else' );    #275
$sv  = path_info('somewhere/else/again');
ok ( $sv, '/somewhere/else/again' );    #276
$sv  = path_info();
ok ( $sv, '/somewhere/else/again' );    #277
path_info('/somewhere/else');

# Accept() - scalar and array context, void argument
print "Testing: Accept()\n" if $debug;
$sv  = Accept();
@av  = Accept();
ok ( $sv, 5 );    #278
ok ( (join' ',sort@av), '*/* image/gif image/jpg text/html text/plain' );    #279

# Accept() - scalar context, invalid argument (matches '*/*'
print "Testing: Accept('foo/bar')\n" if $debug;
$sv  = Accept('foo/bar');
ok ( $sv, '0.001' );    #280

# Accept() - scalar and array context, void argument
print "Testing: Accept()\n" if $debug;
$sv  = Accept('*/*');
ok ( $sv, '0.001' );    #281

# http() - scalar and array context, void argument
print "Testing: http()\n" if $debug;
$sv  = http();
@av  = http();
ok ( $sv > 0 );    #282
ok ( $av[0] =~ m/HTTP/ );    #283

# http() - scalar context, invalid arguments
print "Testing: http('invalid arg')\n" if $debug;
$sv  = http('http-hell');
ok ( $sv, undef );    #284
$sv  = http('hell');
ok ( $sv, undef );    #285

# http() - scalar context, valid arguments
print "Testing: http('valid arg')\n" if $debug;
$sv  = http('http-from');
ok ( $sv, 'spammer@nowhere.com' );    #286
$sv  = http('from');
ok ( $sv, 'spammer@nowhere.com' );    #287

# https() - scalar and array context, void argument
print "Testing: https()\n" if $debug;
$sv  = https();
ok ( $sv, 'ON' );    #288

# https() - scalar  context, invalid argument
print "Testing: https('invalid arg')\n" if $debug;
$sv  = https('hell');
ok ( $sv, undef );    #289

# https() - scalar context, valid arguments
print "Testing: https('valid arg')\n" if $debug;
$sv  = https('https-a');
ok ( $sv, 'A' );    #290
$sv  = https('a');
ok ( $sv, 'A' );    #291

# protocol() - scalar context, void arguments
print "Testing: protocol()\n" if $debug;
$sv  = protocol();
ok ( $sv, 'https' );    #292
$ENV{'HTTPS'} = 'OFF';
$ENV{'SERVER_PORT'} = '443';
$sv  = protocol();
ok ( $sv, 'https' );    #293
$ENV{'SERVER_PORT'} = '8080';
$sv  = protocol();
ok ( $sv, 'http' );    #294

# url() - scalar context, void argument
print "Testing: url()\n" if $debug;
$ENV{'HTTP_HOST'} = '';
ok( url(),  'http://nowhere.com:8080/cgi-bin/foo.cgi' );    #295

# url() - scalar context, valid argument
print "Testing: url()\n" if $debug;
ok( url(-absolute=>1), '/cgi-bin/foo.cgi','CGI::url(-absolute=>1)');    #296

# url() - scalar context, valid argument
print "Testing: url(-relative=>1)\n" if $debug;
ok( url(-relative=>1), 'foo.cgi' );    #297

# url() - scalar context, valid argument
print "Testing: url(-relative=>1,-path=>1)\n" if $debug;
ok( url(-relative=>1,-path=>1), 'foo.cgi/somewhere/else' );    #298

# url() - scalar context, valid argument
print "Testing: url(-relative=>1,-path=>1,-query=>1)\n" if $debug;
ok( url(-relative=>1,-path=>1,-query=>1), 'foo.cgi/somewhere/else?name=JaPh%2C&color=red&color=green&color=blue' );    #299

# self_url() - scalar context, void argument
print "Testing: self_url()\n" if $debug;
$sv  = self_url();
@av  = self_url();
ok( $sv , 'http://nowhere.com:8080/cgi-bin/foo.cgi/somewhere/else?name=JaPh%2C&color=red&color=green&color=blue' );    #300

# state() - scalar and array context, void/invalid/valid argument
print "Testing: state()\n" if $debug;
ok( state(), self_url() );    #301


################ Yet More Tests ################


print "Yet more tests\n" if $debug;
#$CGI::Simple::POST_MAX = 20;
#$ENV{'REQUEST_METHOD'} = 'POST';
#restore_parameters();
#ok( cgi_error(), '413 Request entity too large: 42 bytes on STDIN exceeds $POST_MAX!' );    #302

$ENV{'REQUEST_METHOD'} = 'HEAD';
$ENV{'QUERY_STRING'} = '';
$ENV{'REDIRECT_QUERY_STRING'} = 'name=JAPH&color=red&color=green&color=blue';
$CGI::Simple::POST_MAX = 50;
restore_parameters();
@av = param();
ok ( (join' ',@av), 'name color' );    #303
@av = param('color');
ok( (join' ',@av), 'red green blue' );    #304


################ Results ################


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
