use warnings;
use strict;

my %keys = ( "1", "read", "2", "blue", "3", "green", "4", "yellow" );

my $testString = "My favoprit colors are 1 2 3 4.";

print "$testString\n";

foreach my $key (sort keys %keys) {
    $testString =~ s/$key/$keys{$key}/g;
    print "$testString\n";
}

print "$testString\n";
