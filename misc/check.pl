#!/usr/bin/perl -w
use strict;

# this script will check if a script is using any features of CGI.pm that are
# not supported by CGI::Simple.pm Call it from the command line: check.pl <files>

my @problems;

die "Useage check.pl <files>\n" unless @ARGV;

my @subs = qw(  MULTIPART SERVER_PUSH URL_ENCODED _compile _compile_all
                _make_tag_func _script _set_values_and_labels _setup_symbols
                _style _tableize _textfield add_parameter asString autoEscape
                binmode button checkbox checkbox_group comment compare compile
                default_dtd defaults end_form end_html end_multipart_form
                endform eof expand_tags filefield fillBuffer get_fields hidden
                image_button import_names init initialize_globals isindex
                new_MultipartBuffer nosticky parse_params password_field
                popup_menu previous_or_default private_tempfiles radio_group
                read readBody readHeader read_from_client read_multipart
                register_parameter reset save_request scrolling_list
                self_or_CGI self_or_default start_form start_html
                start_multipart_form startform submit textarea
                textfield tmpFileName to_filehandle uploadInfo );

my @globals = qw( AUTOLOADED_ROUTINES AUTOLOAD_DEBUG BEEN_THERE CRLF
                DEFAULT_DTD EBCDIC FH FILLUNIT IIS IN INITIAL_FILLUNIT
                JSCRIPT MAC MAXTRIES MOD_PERL NOSTICKY OS OVERLOAD PERLEX
                PRIVATE_TEMPFILES Q QUERY_CHARSET QUERY_FIELDNAMES
                QUERY_PARAM SCRATCH SL SPIN_LOOP_MAX SUBS TEMP TIMEOUT
                TMPDIRECTORY XHTML );
my @pragmas = qw( any compile nosticky no_xhtml private_tempfiles );

my $subs    = join '|', @subs;
$subs       = qr/$subs/;
my $globals = join '|', @globals;
$globals    = qr/$globals/;
my $pragmas = join '|', @pragmas;
$pragmas    = qr/$pragmas/;

for my $file (@ARGV) {
    print "File: $file\n\n";
    open SEARCH, $file or die "Can't read $file: $!\n";
    while (<SEARCH>) {
      last if  /^__END__/;  # ignore stuff after __END__ token
      next if m/^\s*#/;     # very basic comment skip
        s/^\s+//;
        &problems, next if m/\b($subs)\s*\(/;
        &problems, next if m/CGI::($subs)\b/;
        &problems, next if m/->\s*($subs)\b/;
        &problems, next if m/([\$%@]CGI::$globals)\b/;
        &problems, next if /use\s+CGI.*($pragmas)/;
    }
    print "$_ " for @problems;
    print "\n\n\n";
}

sub problems { push @problems, "$.: Problem:'$1'\t$_" }
