package My::DiskDataCollector;
use strict;
use warnings;

use Exporter qw( import );
use Win32::DriveInfo();

# use Data::Dumper qw(Dumper); #for debug

our @EXPORT_OK = qw( GetDriveData GetDriveInfo );

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

#########################################
###### Internal Subrutine block #########
#########################################

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
