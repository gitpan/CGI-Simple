#!/usr/bin/perl -w

use strict;

sub unindent;

my @common;
my $show_comments = 0;
my $cgi = 'c:/usr/lib/cgi.pm';
my $simp = 'c:/usr/lib/cgi/simple.pm';

$cgi  = get_file($cgi);
$simp = get_file($simp);

my %com  = get_comments($cgi);  # get comments from CGI.pm
my @cgi  = get_subs($cgi);      # get subs from CGI.pm
my @simp = get_subs($simp);     # get subs from CGI::Simple.pm

# map sub names to array index
my $i = 0;
my %cgi = map { ($_,$i++) }@cgi;
$i = 0;
my %simp = map { ($_,$i++) }@simp;

# do a diff betwen the programs
for my $sub ( sort { $simp{$a} <=> $simp{$b} }keys %simp ) {
    if ( exists $cgi{$sub} ) {
        push @common, $sub;
        delete $cgi{$sub};
        delete $simp{$sub};
    }
}

# concur_test(@common);
# simp_test(@simp);

my $line = ("#" x 60)."\n\n";
print "$line Common subs\n\n$line";
for ( @common ) {
    print "$_()\n";
    #print "$com{$_}\n" if $show_comments;
}
print "\n$line Unique to CGI\n\n$line";
for ( sort { $a<=>$b } values %cgi ) {
    print "$cgi[$_]()\n";
    print "$com{$cgi[$_]}\n" if $show_comments;
}
print "\n$line New in CGI::Simple\n\n$line";
for (sort { $a<=>$b } values %simp ) {
    print "$simp[$_]()\n";
}
print "\n$line All in CGI::Simple\n\n$line";
print "$_\n" for @simp;

################# Subs ################

# skeleton test frame for CGI <=> CGI::Simple comparison
sub concur_test {
    my @common = @_;
    for my $sub (@common) {
        print unindent <<"        END";
        # $sub() - scalar and array context, void/invalid/valid argument
        print "Testing: $sub()\\n" if \$debug;
        \$cgi  = \$q->$sub();
        \$simp = \$s->$sub();
        \@cgi  = \$q->$sub();
        \@simp = \$s->$sub();
        #ok ( \$simp, \$cgi );
        #ok ( \$simp =~ m//, \$cgi =~ m// );
        #ok ( (join'',\@simp), (join'',\@cgi) );

        END
    }
}

# skeleton test frame for CGI::Simple
sub simp_test {
    my @simp = @_;
    for my $sub (@simp) {
        print unindent <<"        END";
        # $sub() - scalar and array context, void/invalid/valid argument
        print "Testing: $sub()\\n" if \$debug;
        \$sv  = \$q->$sub();
        \@av  = \$q->$sub();
        #ok ( \$simp, '' );
        #ok ( \$simp, qr// );
        #ok ( (join'',\@av), '' );
        #ok ( \$q->(), '' );
        #ok ( (join'',\@av), '' );
        #ok ( \$q->query_string, '' );

        END
    }
}
exit;

sub unindent { @_[0] =~ s/^ +//gm; @_[0]; }

sub get_file {
   my $file = shift;
   open F, $file or die "Can't read $file: $!";
   local $/;
      my $file = <F>;
   close F;
  return $file
}

sub get_subs {
   my @file = shift =~ /^\s*sub\s+(\w+)/gm;
 return @file;
}

sub get_comments {
   my $file = shift;
   my %meth = $file =~ /^#+ +Method: +(\w+)\n((?:^#.*\n)+)(?:^#+\n)/gm;
   my %com  = $file =~ /\s*\n((?:^#.*\n)+)sub +(\w+)/gm;
   %com = reverse %com;
 return %meth, %com;
}
   