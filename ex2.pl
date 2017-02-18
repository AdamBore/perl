use 5.010;
use strict;
use warnings;

#get the first number 
say "Please type a number"; 
my $firstNum = <STDIN>; 
chomp $firstNum;

# get the second number
say "Please type another number";
my $secondNum = <STDIN>; 
chomp $secondNum; 

# print the result
print "\n\n\n";
say "You typed $firstNum and $secondNum."; 
my $sum = $firstNum + $secondNum; 
say "The sum of the numbers you typed is: $sum.";