package My::HTMLCreator;
use strict;
use warnings;

use Exporter qw( import );

our @EXPORT_OK = qw( GenerateSystemHtml );

sub GenerateSystemHtml {

    #test function parameters
    my $_targetFileHandle = shift or die "No Target file to write HTML report to.";
    my %_dataToInsert = shift or return;
    my $fileInAString;
    {
        #open a source master file
        my $sourceFileName = "htmlMaster.html";
        open ( my $sourceFileHandle, "<" , $sourceFileName ) or die "Cannot open '$sourceFileName'.";

        # put file in string
        local $/ = undef;
        $fileInAString = <$sourceFileHandle>;
        close $sourceFileHandle;
    }

    # perform subsitutions.
    foreach my $key ( keys %_dataToInsert ) {
        $fileInAString =~ s/"@$key@"/$_dataToInsert{ $key }/g;
    }

    # write new file.
    print $_targetFileHandle $fileInAString;
    return;
}
