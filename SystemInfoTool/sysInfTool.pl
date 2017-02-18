use strict;
use warnings;
use 5.010;

use Win32::SystemInfo;
use Data::Dumper qw(Dumper); #for debug

my $logFileName = shift or die "Usage is: %0 LOG_FILE_NAME"; # make sure we got a target file.

open( my $logFileHandle, ">" , $logFileName ) or die "Cannot open log file: '$logFileName'."; #make sure we have a place to write to.

my %cpuDataHash = GetCpuInfo();
my %memoryDataHash = GetMemoryInfo();
# print Dumper \%cpuDataHash; #for debug
PrintHash( %cpuDataHash );
PrintHash( %memoryDataHash );


close $logFileHandle;

##############################################
######### start of sub block  ################
##############################################


sub GetMemoryInfo {
  my %memoryDataHash;
  Win32::SystemInfo::MemoryStatus( %memoryDataHash,"MB" );
  return %memoryDataHash;
}

sub PrintHash {
    my %_hashForPrinting = @_;
    # print Dumper \%_hashForPrinting; #for debug
    if( %_hashForPrinting ){
        foreach my $key ( sort keys %_hashForPrinting ){
            print "$key $_hashForPrinting{$key}.\n";
        }
    }
}



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
