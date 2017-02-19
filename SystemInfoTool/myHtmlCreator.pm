package My::HTMLCreator;
use strict;
use warnings;

use Exporter qw( import );

our @EXPORT_OK = qw( GenerateSystemHtml );

sub GenerateSystemHtml {
    my $targetFileHandle = shift or die "No Target file to write HTML report to.";
    my %dataToInsert = shift or return;
    my $fileInAString;
    {
        local $/ = undef;
        $fileInAString = <$targetFileHandle>;
    }
    # put file in string
    # perform subsitutions.
    # return new string.
    return "blabla";
}
