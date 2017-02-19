package My::HTMLCreator;
use strict;
use warnings;

use Exporter qw( import );
use Data::Dumper qw(Dumper); #for debug

our @EXPORT_OK = qw( GenerateSystemHtml );

sub GenerateSystemHtml {

    #test function parameters
    my $_targetFileHandle = shift or die "No Target file to write HTML report to.";
    my %_dataToInsert = @_ or return;
    # print Dumper \%_dataToInsert; #for debug
    my $fileInAString;
    {
        #open a source master file
        my $sourceFileName = "htmlMsater.html";
        open ( my $sourceFileHandle, "<" , $sourceFileName ) or die "Cannot open '$sourceFileName'.";

        # put file in string
        local $/ = undef;
        $fileInAString = <$sourceFileHandle>;
        close $sourceFileHandle;
    }

    # perform subsitutions.
    foreach my $key ( keys %_dataToInsert ) {
        my $target = "@" . $key . "@";
        $fileInAString =~ s/$target/$_dataToInsert{ $key }/g;
    }

    # write new file.
    print $_targetFileHandle $fileInAString;
    return;
}
