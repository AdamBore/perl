package My::HTMLCreator;
use strict;
use warnings;

use Exporter qw( import );

our @EXPORT_OK = qw( GenerateSystemHtml );

sub GenerateSystemHtml {
    my %dataToInsert = shift;
    if( not %dataToInsert )
    {
        return;
    }

    open file
    put file in string
    perform subsitutions.
    return new string.
    return "blabla";
}
