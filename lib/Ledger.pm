#!/usr/bin/perl

use Log::Message::Simple qw[msg error debug carp croak cluck confess];
use Log::Message::Simple qw[:STD :CARP];
use Data::Dumper;
use Getopt::Long;
use Pod::Usage;
use strict;

package Ledger;

my $fl_data;
my $flh_data;
my @posts;
my @trans;
my $rates;

# on syntax read comments in data file 
sub read_data_in {
	#regexp tokens:
	my $rx_date = '\d{4}.\d{2}.\d{2}';
	my $rx_curr = '[a-zA-Z\$]+';
	my $rx_amount = '\d[\d.,]*';
	my $is_transaction;
	my $trans_ind;
	my $date_tr_start;
	my $date_tr_end;
	my $rates_tr={}; #rates determined in a transaction
	my $rx_record="^\s+(.+)\s{2,}(($rx_curr)\s*($rx_amount))?\s+(@@\s*($rx_curr)\s*($rx_amount))?";
	$rx_record .= "()?";
	while (my $line = <$flh_data>) {
		if ($line =~ /^\s*[;#]/) {
			#comment. do nothing
 		} elsif ($is_transaction) {
			if ($line =~ //) {
				#'acc:acc:acc'[two or more spaces] CURR AMOUNT [@@ CURR AMOUNT | @ CURR RATE] [; comment]
				print $line;
				push(@trans,{'acc'=>$1,'curr'=>$3, 'amount'=>$4, $6 => $7});
				print Dumper($trans[-1]);
 			} elsif ($line =~/^\s+;(.+)\s*/) {
				#comments

			} else {
				$is_transaction = 0;
		 }

		} elsif ($line =~ /^($rx_date)\s*([!*])?\s*(\(\S+\))?\s*(.+)\s*?/) {
			#YYYY/MM/DD [*|!] [(243)] Details of post 
			push(@posts,{'date'=>"$1",'status'=>$2,'id'=>$3,'narr'=>$4});

			$trans_ind = scalar @posts;
			$is_transaction = 1;
		} elsif ($line =~ /^P\s+($rx_date)\s+($rx_curr)\s+($rx_curr)\s*($rx_amount)/) {
				  #$rates->{$4}->{$5}->
		}
	}
}


sub run_from_cli{
	Getopt::Long::Configure("bundling");
	my $h = {};

	GetOptions($h, 'file|f=s', 'level:s', 'help');
	pod2usage(1) if $h->{'help'};
	$fl_data = $h->{'file'};

	open $flh_data, "<$fl_data" or die "unable to open data file $fl_data $!";
	read_data_in();
}

############
run_from_cli();


__END__
=head1 NAME

ledger.pl - command line application for parsing text data file wiht accounting records and producing varios reports.

=head1 SYNOPSIS

ledger.pl command [options]

  Options:
	-help		brief help message
	-man 		full documentation

=head1 OPTIONS

=over 8

=item B<-help>

Prints brief help message and exits.

=item B<-man>

Prins manual page and exits

=cut


