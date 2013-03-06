#!/usr/bin/perl

use Log::Message::Simple qw[msg error debug carp croak cluck confess];
use Log::Message::Simple qw[:STD :CARP];
use Data::Dumper;
use Getopt::Long;
use strict;


my $fl_data;
my $flh_data;
my @posts;
my @trans;
my $rates;

## journal constants
## terminology: 1 transaction has many records


sub read_data_in {
	#regexp tokens:
	my $rx_date = '\(d{4}).(\d{2}).(\d{2})';
	my $rx_curr = '[a-zA-Z\$]+';
	my $rx_amount = '\d[\d.,]*';
	my $is_transaction;
	my $trans_ind;
	my $date_tr_start;
	my $date_tr_end;
	while (my $line = <$flh_data>) {
		if ($is_transaction) {
			if ($line =~ /^\s+(.+)\s{2,}(($rx_curr)\s*($rx_amount))?\s+(@@\s*(a-zA-Z\$+)\s*(\d[\d.,]+))?/) {
				#'acc:acc:acc'[two or more spaces] CURR AMOUNT
				print $line;
				push(@trans,{'acc'=>$1,'curr'=>$3, 'amount'=>$4, $6 => $7});
				print Dumper($trans[-1]);
 			} elsif ($line =~/^\s+;(.+)\s*/) {
				#comments

			} else {
				$is_transaction = 0;
		 }


		} elsif ($line =~ /^$rx_date\s*([!*])?\s*(\(\S+\))?\s*(.+)\s*?/) {
			#YYYY/MM/DD [*|!] [(243)] Details of post 
			push(@posts,{'date'=>"$1-$2-$3",'status'=>$4,'id'=>$5,'narr'=>$6});

			$trans_ind = scalar @posts;
			$is_transaction = 1;
		} elsif ($line =~ /^P\s+($rx_date)\s+($rx_curr)\s+($rx_curr)\s*($rx_amount)/) {
				  #$rates->{$4}->{$5}->
	}
}

sub report {
	open $flh_data, "<$fl_data";
	read_data_in();
}


sub print_dates {
	my $dates = shift;

	my $out;
	my $out_str = shift;
	if ($out_str) {
		open($out,">$out_str") or die "can't open $out_str: $!\n";
	} else {
		$out = *STDOUT;
	}

	for $d (@$dates) {
		print $out $d, "\n";
	}
}

#my @dates = get_list_of_dates('2001/02/03/','2012/05/02');
#print_dates(\@dates, 'out');
############
$fl_data = shift;
report();
