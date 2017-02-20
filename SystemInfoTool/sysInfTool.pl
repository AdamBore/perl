use strict;
use warnings;
use 5.010;

use Win32::SystemInfo();
use Win32::DriveInfo();

use File::Basename qw(dirname);
use Cwd  qw(abs_path);
use lib dirname(dirname abs_path $0) . '/lib';
use My::HTMLCreator;


# use Data::Dumper qw(Dumper); #for debug

my $logFileName = shift or die "Usage is: $0 LOG_FILE_NAME"; # make sure we got a target file.

open( my $logFileHandle, ">" , $logFileName ) or die "Cannot open log file: '$logFileName'."; #make sure we have a place to write to.

my %cpuDataHash = GetCpuInfo();
my %memoryDataHash = GetMemoryInfo();

foreach my $key ( keys %memoryDataHash ) {
    $memoryDataHash{ $key } = RoundToTwoPlaces( $memoryDataHash{ $key } );
}

my %dataForHTML = ( %cpuDataHash, %memoryDataHash );


my %drivesData;
foreach my $driveLetter ( GetDriveInfo() ) {
    my %singleDriveData = GetDriveData( $driveLetter );
    # print Dumper \%singleDriveData; #for debug
    $drivesData{ $driveLetter } = \%singleDriveData;
    # print Dumper \%drivesData; #for debug

}

#create html from data *could create another pm later on to save data.
My::HTMLCreator::GenerateSystemHtml( $logFileHandle, \%dataForHTML, \%drivesData );

close $logFileHandle;

##############################################
######### start of sub block  ################
##############################################

sub GetDriveData {
    my @singleDriveData =  Win32::DriveInfo::DriveSpace( shift );
    my @parameterNames = qw( SectorsPerCluster BytesPerSector NumberOfFreeClusters TotalNumberOfClusters
                                FreeBytesAvailableToCaller TOTAL_SPACE FREE_SPACE );
    my %singleDriveDataMap;
    while ( @parameterNames ) {
        my $key = shift @parameterNames;
        my $value = shift @singleDriveData;
        $singleDriveDataMap{ $key } = $value;
    }

    $singleDriveDataMap{ TOTAL_SPACE } = ConvertBytesToGiga( $singleDriveDataMap{ TOTAL_SPACE } );
    $singleDriveDataMap{ FREE_SPACE } = ConvertBytesToGiga( $singleDriveDataMap{ FREE_SPACE } );
    $singleDriveDataMap{ FreeBytesAvailableToCaller } = ConvertBytesToGiga( $singleDriveDataMap{ FreeBytesAvailableToCaller } );
    # print Dumper \%singleDriveDataMap; #for debug

    return %singleDriveDataMap;
}

sub ConvertBytesToGiga {
    my $bytsInGiga = 1024 * 1024 * 1024;
    my $dataInBytes = shift;
    my $places = 2;
    my $factor = 10**$places;
    return RoundToTwoPlaces( $dataInBytes / $bytsInGiga );
}

sub RoundToTwoPlaces {
    my $number = shift @_;
    my $places = 2;
    my $factor = 10**$places;
    return int( $number * $factor ) / $factor;
}


sub GetDriveInfo {
    return Win32::DriveInfo::DrivesInUse();
}

sub GetMemoryInfo {
  my %memoryDataHash;
  Win32::SystemInfo::MemoryStatus( %memoryDataHash,"GB" );
  return %memoryDataHash;
}

# sub PrintHash {
#     my %_hashForPrinting = @_;
#     # print Dumper \%_hashForPrinting; #for debug
#     if( %_hashForPrinting ){
#         foreach my $key ( sort keys %_hashForPrinting ){
#             print $logFileHandle "$key $_hashForPrinting{$key}.\n";
#         }
#     }
# }

sub GetCpuInfo {
    my %cpuDataHash;
    Win32::SystemInfo::ProcessorInfo( %cpuDataHash );

    my %parsedCPUData;
    $parsedCPUData{ NumProcessors } = $cpuDataHash{ NumProcessors };

    foreach my $key ( keys %{$cpuDataHash{ Processor0 }} )
    {
        # print "$key = $cpuDataHash{ Processor0 }{$key}\n"; #for debug
        $parsedCPUData{ $key } = $cpuDataHash{ Processor0 }{$key};
    }
    # print Dumper \%parsedCPUData; #for debug
    return %parsedCPUData;
}
