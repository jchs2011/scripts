#!/usr/bin/perl
=head1 Author: Martin (bumby) Stenberg <bumbyn@gmail.com>
Name: transrecipfy
Description: Translate crazy unit-recipes to metric
Start date: 2001-something-something
Last updated Date: 2002-something-something
=cut
use warnings;
use strict;
use CGI;

my $q = $ARGV[0] || 1.0;
my @lines;
while(<STDIN>) {
    push @lines, $_;
}

print transrecipf($_) for @lines;

sub transrecipf {
	my %types = (
		# weight
		"([\\d\\.\\/\\s]+)(oz|ounces?)"		=> sub {return prefixify(round(shift()*28.3495231), 'g');},
		"([\\d\.\\/\\s]+)(lbs|pounds?)"		=> sub {return prefixify(round(shift()*453.59237), 'g');},
		# volume
		"([\\d\\.\\/\\s]+)(cups?)"		=> sub {return prefixify(round(shift()*0.236588237),'l');},
		"([\\d\\.\\/\\s]+)(gallon?)"		=> sub {return prefixify(round(shift()*3.7854118), 'l');},
		"([\\d\.\\/\\s]+)(sticks?)"		=> sub {return prefixify(round(shift()*0.118294119), 'l');},
		# length
		"([\\d\\.\\/\\s]+)(inch(es)?)"		=> sub {return prefixify(round(shift()*0.0254), 'm');},
		"([\\d\\.\\/\\s]+)((foot|feets?))"	=> sub {return prefixify(round(shift()*0.3048), 'm');},
		"([\\d\\.\\/\\s]+)(yards?)"		=> sub {return prefixify(round(shift()*0.9144), 'm');},
		# temperature
		"([\\d\\.]+)\\s*((degrees)?\\s*f)"	=> sub {return prefixify(round((shift()-32)*(5.0/9.0)), 'c');},

	);

	my $data = shift;
	foreach my $rk (keys %types) {
		while($data =~ /$rk/i){
			my $num = 0.0;
			foreach my $n (split /\s+/, $1){
				$num += eval($n) if $n;
			}

			my $ret = &{$types{$rk}}($num);
			$data =~ s/$rk/ $ret/i;
		}
	}

	return $data;
}

sub prefixify {
	my ($n, $t) = @_;

	my $p = '';
	# weight
	if($t eq 'g'){
		$p = 'g';
		if($n<0.1){
			$p = 'mg';
			$n = $n*1000.0;
		}elsif($n>1000){
			$p = 'kg';
			$n = $n/1000.0;
		}
	# volume
	}elsif($t eq 'l'){
		$p = 'l';
		if($n<1 and $n>=0.1){
			$p = 'dl';
			$n = $n*10.0;
		}elsif($n<0.1 and $n>=0.01){
			$p = "cl";
			$n = $n*100.0;
		}elsif($n<0.01 and $n>=0.001){
			$p = "ml";
			$n = $n*1000.0;
		}elsif($n<0.001){
			$p = "micro liters";
			$n = $n*1000000.0;
		}
	# length
	}elsif($t eq 'm'){
		$p = 'm';
		if($n<1 and $n>=0.1){
			$p = 'dm';
			$n = $n*10.0;
		}elsif($n<0.1 and $n>=0.01){
			$p = "cm";
			$n = $n*100.0;
		}elsif($n<0.01 and $n>=0.001){
			$p = "mm";
			$n = $n*1000.0;
		}elsif($n<0.001){
			$p = " micro meters";
			$n = $n*1000000.0;
		}
	# temperature
	}elsif($t eq 'c'){
		$p = 'C';
	}

	return "$n$p";
}

sub round {
	sprintf "%.2f", shift;
}
