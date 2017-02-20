package My::SysInfoCollector;
use strict;
use warnings;

use Exporter qw( import );
use Win32::SystemInfo();

# use Data::Dumper qw(Dumper); #for debug

our @EXPORT_OK = qw( GetCpuInfo GetMemoryInfo );


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

sub GetMemoryInfo {
  my %memoryDataHash;
  Win32::SystemInfo::MemoryStatus( %memoryDataHash,"GB" );
  return %memoryDataHash;
}
