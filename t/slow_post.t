use lib qw(t/lib blib/lib blib/arch);
use Test;
use Config;
use strict;
$|++;
BEGIN { plan tests => 3, }

use CGI::Simple;
ok(1);    # test 1

my ( $q, $sv );
$CGI::Simple::POST_MAX = -1;

if ($Config{d_fork}) {
    $ENV{REQUEST_METHOD}='POST';
    $ENV{CONTENT_LENGTH}=10_005;
    if (open(CHILD,"|-")) {  # cparent
        print CHILD 'SLOW=';
        for(1..10) {
            print CHILD 'X'x1000;
            sleep 1;
        }
        close CHILD;
        exit 0;
    }
    # at this point, we're in a new (child) process
    $q = new CGI::Simple;
    $sv = $q->param('SLOW');
    ok(length $sv, 10_000);
    ok($sv, 'X'x10_000);
} else {
    skip("Can't fork on this OS",1);
    skip("Can't fork on this OS",1);
}
