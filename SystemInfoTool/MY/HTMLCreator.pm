package My::HTMLCreator;
use strict;
use warnings;

use Exporter qw( import );
use Data::Dumper qw(Dumper); #for debug

our @EXPORT_OK = qw( GenerateSystemHtml );

sub GenerateSystemHtml {

    #get parameters into vars
    my ( $_targetFileHandle, $_dataToInsertRef, $_disksDataRef) = @_;

    #dereferance hashes
    my %dataToInsert = %{ $_dataToInsertRef };
    my %diskData = %{ $_disksDataRef };

    my $fileInAString;
    {
        #open a source master file
        my $sourceFileHandle = OpenFile( "htmlMsater.html" );

        # put file in string
        local $/ = undef;
        $fileInAString = <$sourceFileHandle>; #put entire file into a string.
        # close $sourceFileHandle; will close at end of scope
    }
    my $drivesDataString = GetDrivesDataString( %diskData );
    my $drivesTarget = "\@DRIVES\@";
    $fileInAString =~ s/$drivesTarget/$drivesDataString/g;
    # perform subsitutions.
    foreach my $key ( keys %dataToInsert ) {
        my $target = "@" . $key . "@";
        $fileInAString =~ s/$target/$dataToInsert{ $key }/g;
    }

    # write new file.
    print $_targetFileHandle $fileInAString;
    return;
}

##############################################
######### start of sub block  ################
##############################################

sub OpenFile {
    my $fileName = shift;
    open ( my $sourceFileHandle, "<" , $fileName ) or die "Cannot open '$fileName'.";
    return $sourceFileHandle;
}

sub GetDrivesDataString {
    my %_disksData = @_;

    # my $sourceFileHandle = OpenFile( "diskData.html" ) or die "Cannot find disk data template";
    my $diskDataTemplate;
    {
        #open a source master file
        my $sourceFileHandle = OpenFile( "diskData.html" );

        # put file in string
        local $/ = undef;
        $diskDataTemplate = <$sourceFileHandle>; #put entire file into a string.
        # close $sourceFileHandle; will close at end of scope
    }
    my $allDisksDataString;
    foreach my $singleDiskLetter ( sort keys %_disksData ) {
        my $currentDiskDataString = $diskDataTemplate;
        my $driveLetterTarget = "\@DRIVE_LETTER\@";
        $currentDiskDataString =~ s/$driveLetterTarget/$singleDiskLetter/g;
        foreach my $key ( keys %{ $_disksData{ $singleDiskLetter } } ) {
            my $target = "@" . $key . "@";
            $currentDiskDataString =~ s/$target/$_disksData{ $singleDiskLetter }{ $key }/g;
        }
        $allDisksDataString = $allDisksDataString . $currentDiskDataString;
    }
    return $allDisksDataString;
}
