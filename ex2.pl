use 5.010;
use strict;
use warnings;



my $firstNum = <STDIN>; 
chomp $firstNum;



my $secondNum = <STDIN>; 
chomp $secondNum; 


print "\n\n\n";
say "You typed $firstNum and $secondNum."; 
my $sum = $firstNum + $secondNum; 
say "The sum of the numbers you typed is: $sum.";