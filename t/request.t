#!/usr/local/bin/perl -w

# This is the original function.t file distributed with CGI.pm 2.78
# The only change is to change the use statement and change references
# from CGI to CGI::Simple

# Test ability to retrieve HTTP request info
######################### We start with some black magic to print on failure.
use lib '../blib/lib','../blib/arch';

BEGIN {$| = 1; print "1..33\n"; }
END {print "not ok 1\n" unless $loaded;}

# during testing we get a warning about ambiguous use of *{CGI::Simple::url_decode}...
# this is a test problem not a module problem so we kill warnings until after we
# have used CGI::Simple.

BEGIN { $^W = 0 }

use CGI::Simple (-default);

$^W = 1; # OK for warnings again...

use Config;
$loaded = 1;
print "ok 1\n";

######################### End of black magic.

# util
sub test {
    local($^W) = 0;
    my($num, $true,$msg) = @_;
    print($true ? "ok $num\n" : "not ok $num $msg\n");
}

# Set up a CGI environment
$ENV{REQUEST_METHOD}  = 'GET';
$ENV{QUERY_STRING}    = 'game=chess&game=checkers&weather=dull';
$ENV{PATH_INFO}       = '/somewhere/else';
$ENV{PATH_TRANSLATED} = '/usr/local/somewhere/else';
$ENV{SCRIPT_NAME}     = '/cgi-bin/foo.cgi';
$ENV{SERVER_PROTOCOL} = 'HTTP/1.0';
$ENV{SERVER_PORT}     = 8080;
$ENV{SERVER_NAME}     = 'the.good.ship.lollypop.com';
$ENV{REQUEST_URI}     = "$ENV{SCRIPT_NAME}$ENV{PATH_INFO}?$ENV{QUERY_STRING}";
$ENV{HTTP_LOVE}       = 'true';

$q = new CGI::Simple;
test(2,$q,"CGI::Simple::new()");
test(3,$q->request_method eq 'GET',"CGI::Simple::request_method()");
test(4,$q->query_string eq 'game=chess;game=checkers;weather=dull',"CGI::Simple::query_string()");
test(5,$q->param() == 2,"CGI::Simple::param()");
test(6,join(' ',sort $q->param()) eq 'game weather',"CGI::Simple::param()");
test(7,$q->param('game') eq 'chess',"CGI::Simple::param()");
test(8,$q->param('weather') eq 'dull',"CGI::Simple::param()");
test(9,join(' ',$q->param('game')) eq 'chess checkers',"CGI::Simple::param()");
test(10,$q->param(-name=>'foo',-value=>'bar'),'CGI::Simple::param() put');
test(11,$q->param(-name=>'foo') eq 'bar','CGI::Simple::param() get');
test(12,$q->query_string eq 'game=chess;game=checkers;weather=dull;foo=bar',"CGI::Simple::query_string() redux");
test(13,$q->http('love') eq 'true',"CGI::Simple::http()");
test(14,$q->script_name eq '/cgi-bin/foo.cgi',"CGI::Simple::script_name()");
test(15,$q->url eq 'http://the.good.ship.lollypop.com:8080/cgi-bin/foo.cgi',"CGI::Simple::url()");
test(16,$q->self_url eq
     'http://the.good.ship.lollypop.com:8080/cgi-bin/foo.cgi/somewhere/else?game=chess;game=checkers;weather=dull;foo=bar',
     "CGI::Simple::url()");
test(17,$q->url(-absolute=>1) eq '/cgi-bin/foo.cgi','CGI::Simple::url(-absolute=>1)');
test(18,$q->url(-relative=>1) eq 'foo.cgi','CGI::Simple::url(-relative=>1)');
test(19,$q->url(-relative=>1,-path=>1) eq 'foo.cgi/somewhere/else','CGI::Simple::url(-relative=>1,-path=>1)');
test(20,$q->url(-relative=>1,-path=>1,-query=>1) eq
     'foo.cgi/somewhere/else?game=chess;game=checkers;weather=dull;foo=bar',
     'CGI::Simple::url(-relative=>1,-path=>1,-query=>1)');
$q->delete('foo');
test(21,!$q->param('foo'),'CGI::Simple::delete()');

$q->_reset_globals;
$ENV{QUERY_STRING}='mary+had+a+little+lamb';
test(22,$q=new CGI::Simple,"CGI::Simple::new() redux");
test(23,join(' ',$q->keywords) eq 'mary had a little lamb','CGI::Simple::keywords');
test(24,join(' ',$q->param('keywords')) eq 'mary had a little lamb','CGI::Simple::keywords');
test(25,$q=new CGI::Simple('foo=bar&foo=baz'),"CGI::Simple::new() redux");
test(26,$q->param('foo') eq 'bar','CGI::Simple::param() redux');
test(27,$q=new CGI::Simple({'foo'=>'bar','bar'=>'froz'}),"CGI::Simple::new() redux 2");
test(28,$q->param('bar') eq 'froz',"CGI::Simple::param() redux 2");

# test tied interface
my $p = $q->Vars;
test(29,$p->{bar} eq 'froz',"tied interface fetch");
$p->{bar} = join("\0",qw(foo bar baz));
test(30,join(' ',$q->param('bar')) eq 'foo bar baz','tied interface store');

# test posting
$q->_reset_globals;
if ($Config{d_fork}) {
  $test_string = 'game=soccer&game=baseball&weather=nice';
  $ENV{REQUEST_METHOD}='POST';
  $ENV{CONTENT_LENGTH}=length($test_string);
  $ENV{QUERY_STRING}='big_balls=basketball&small_balls=golf';
  if (open(CHILD,"|-")) {  # cparent
    print CHILD $test_string;
    close CHILD;
    exit 0;
  }
  # at this point, we're in a new (child) process
  test(31,$q=new CGI::Simple,"CGI::Simple::new() from POST");
  test(32,$q->param('weather') eq 'nice',"CGI::Simple::param() from POST");
  test(33,$q->url_param('big_balls') eq 'basketball',"CGI::url_param()");
} else {
  print "ok 31 # Skip Can't fork on this OS\n";
  print "ok 32 # Skip Can't fork on this OS\n";
  print "ok 33 # Skip Can't fork on this OS\n";
}
