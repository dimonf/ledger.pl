
package Sunduk_curr;


use strict;
use warnings;

use Exporter;
use vars qw($VERSION @ISA @EXPORT @EXPORT_OK %EXPORT_TAGS);

$VERSION			= 1.00;
@ISA				= qw(Exporter);
@EXPORT			= ();
@EXPORT_OK		= qw($gl_rates);
%EXPORT_TAGS	= ( ALL => [qw(pr_bin_search get_dates bin_search)],
			 			);

=head1 SYNOPSIS 

currency module contains all data and functionality for storing, manipulation and acquiring rates (prices) for commodities. 

=cut

=head1 DATA STRUCTURE

global var %gl_rates is of the following structure:

	$gl_rates->{currency_a}->{currency_b}->{
		'dates' => [--sorted array of YYYY-MM-DD--],
		'rates' => {'YYYY-MM-DD' => rate, ... }}

Within $gl_rates combination currency_a/currency_b is unique, and the following is always true: C<$currency_a lt $currency_b>. This serves to avoid duplication of a give currencies pair in reverse order (for example, $gl_rates->{'USD'}->{'RUB'} and $gl_rates->{'RUB'}->{'USD'}. At the same time, upon storing a rate in $gl_rates, to avoid immediate conversion of a rate, in case the given currencies pair is in 'wrong' order (ie C<$currency_a gt $currency_b>), in such a case the rate is stored as negative float. This results in:
 RUB/USD  0.03601   will be stored as   $gl_rates->{RUB}->{USD}-{rates}->{YYYY-MM-DD} => 0.03601
 USD/RUB  27.77   will be stored as   $gl_rates->{RUB}->{USD}-{rates}->{YYYY-MM-DD} => -27.77 
It is important, whenever possible, to avoid 1/rate conversion, which entails rounding.

=cut

our $gl_rates;

use Data::Dumper;
use Test::Most;
use Time::HiRes qw/ tv_interval gettimeofday /;

use Sunduk_Data qw/bin_search/;

=head2
	get_rate takes arguments:

=over 1

=item 1. $curr_b - 'base currency', which is evaluated in terms of the second argument: 

=item 2. $curr_p - 'price currency',

=item 3. $date - the function returns rate for the date, if available. The latest previous rate is served otherwise.

=back

or how many units of $curr_p can be exchanged for 1 unit of $curr_b:
$curr_b = EUR, $curr_p = USD, exch_rate = 1.35

=cut

sub get_rate {
	my ($curr_b, $curr_p, $date) = @_;

	my $rate;

	if $curr_b gt $curr_p {
		($curr_b, $curr_p) = ($curr_p, $curr_b);
	}

	if ($rate = $gl_rates->{$curr_b}->{$curr_p}->{'rates'}->{$date}->[0]) {
	}

	eval { 
		$rate = $gl_rates->{$curr_b}->{$curr_p}->{'rates'}->{$date}->[0];
	} or do {
		my $latest_date = bin_search($gl_rates->{$curr_b}

}

=head2
	set_rate takes arguments:

=over 1

=item 1. $curr_b

=item 2. $curr_p

=item 3. $rate

=item 4. $date

=item 5. $note: context, in which the rates has been recorded: 

=over 2

=item   'P' - for explicit separate journal entry: 'P EUR USD 1.33'

=item 'R' - for explicit rate in a record within transaction:  C<Assets:Bank:1    USD300 @EUR0.769>

=item 'S' - for calculated rate in a record within transaction: C<Assets:Bank:1    USD300 @@ EUR230.77>

The context note is used to set priority for a rate: rate of the higher priority overrides the rate of the lower.  The highest priority is 'P'.

=back

=back

=cut

sub set_rate {	
	my ($curr_b, $curr_p, $rate, $date, $priority) = @_;

	if $curr_b gt $curr_p {
		($curr_b, $curr_p) = ($curr_p, $curr_b);
		$rate = -$rate;
	}
	
	my $r = $gl_rates->{$curr_b}->{$curr_p}->{'rates'};

	if ($r->{$date}->{'priority'} gt $priority) {
		$r->{$date}={'rate'=>$rate, 'priority'=>$priority};
	


	if (!exists $r->{$date}) {
		$r->{$date}={'rate'=>$rate, 'priority'=>$priority};
		#no sorting is applied to 'dates' array to save on CPU: this shall be done
		#once as soon as update of rates database is complete.
		push @{$gl_rates->{$curr_b}->{$curr_p}->{'dates'}}, $date;
	} elsif ($r->{$date}->{'priority'} gt $priority) {
		$r->{$date}={'rate'=>$rate, 'priority'=>$priority};
	}

}

1;

__END__






