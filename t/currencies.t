#!/usr/bin/perl -w
#
use strict;

use FindBin;
use lib "$FindBin::Bin/../lib";

use Test::Most qw(no_plan);

BEGIN {
	use_ok('Ledger::Base');
	use_ok('Ledger::Rates');
}

require_ok('Ledger::Base');
require_ok('Ledger::Rates');

can_ok('Ledger::Rates',('set_rate'));
can_ok('Ledger::Base',('get_dates'));

my $h_l={};
my $g_s={};
my @all_dates;

my @date_range = ('2001-01-08', '2011-02-20');
my @currencies = ('USD', 'EUR', 'RUB', 'GBP');
my $number_of_curr_rates = 10;

sub set_init_data {
	my @all_dates = get_dates(@date_range);
	#
}




sub set_init_data {
	my @all_dates = get_dates(@date_range);

	#mimic normal program functioning - getting rates
	for my $c (@currencies) {
		for my $s_c (@currencies) {
			get_rate($c, $s_c);
		}
	}
	#get random dates from @all_dates;
	foreach my $c (sort keys %$h_l) {
		my $h_t = $h_l->{$c};
		foreach my $s_c (sort keys %$h_t) {
			my %a = ();
			while (keys %a <= $number_of_curr_rates) {
				my $t	 = $all_dates[ rand @all_dates];
				$a{$t} = scalar keys %a;
				#print "keys ". scalar(keys %a). "\n";
	 }
			#print Dumper(\%a);
			$h_l->{$c}->{$s_c}->{'arr_rates'} = \%a;
			$h_l->{$c}->{$s_c}->{'arr_dates'} = [ sort keys %a];
		}
	}
}



set_init_data;
print Dumper($h_l);
