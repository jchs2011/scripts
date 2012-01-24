#!/usr/bin/perl
use strict;
use warnings;

my $TempEnd = 80;
my $VolTot = 200;
my $TempCold = 20;

print "How much tea would you like? (ml)\n";
$VolTot = <STDIN>;chop $VolTot;
print "What temperature should the tea be? (Celcius)\n";
$TempEnd = <STDIN>;chop $TempEnd;
print "How cold is your tap-water? (Celcius)\n";
$TempCold = <STDIN>;chop $TempCold;

my $VolDelta = (($TempEnd-100)*$VolTot)/($TempCold-$TempEnd-100);

printf("Boil %.1f ml water. Add %.1f ml %.1f C water. You now have %.1f ml %.1f C water\n", $VolTot-$VolDelta, $VolDelta, $TempCold, $VolTot, $TempEnd);
