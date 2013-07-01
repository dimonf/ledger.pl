
package Ledger::Rates;
our $VERSION='0.1';


use strict;
use warnings;

use Exporter;
use vars qw($VERSION @ISA @EXPORT @EXPORT_OK %EXPORT_TAGS);

$VERSION			= 1.00;
@ISA				= qw(Exporter);
@EXPORT			= qw($gl_rates get_rate set_rate);
@EXPORT_OK		= qw($gl_rates get_rate set_rate);
%EXPORT_TAGS	= ( ALL => [qw($gl_rates get_rate set_rate)],
			 			);

use Ledger::Data qw/bin_search/;
$gl_rates={};

=head1 SYNOPSIS 

currency module contains all functionality for storing, manipulation and acquiring rates (prices) for commodities. 

=cut

=head1 DATA STRUCTURE

To avoid uncertainty, for a given pair of currencies only there is only one combination {currency_a}->{currency_b} maintained, which unambiguosly represents the pair.  This is achieved by adhere to the following principle: C<$currency_a lt $currency_b> is always TRUE. It is important however, whenever possible, to avoid 1/rate conversion, which entails rounding. Thus, generally 2 values are stored under given currencies pair: direct and reverse rate

global var %gl_rates is of the following structure:

	$gl_rates->{currency_a}->{currency_b}->{
		'dates' => [--sorted array of YYYY-MM-DD--],
		'rates' => {'YYYY-MM-DD'->{d=>1.253, r=>0.798, dr=>0, rr=>0 ,ds=>N, rs=>N}, ... }}

=over1

		d - direct
		r - reverse
		dr - rank for direct rate
		rr - rank for reverse rate
		ds - source of direct rate (line number of data file)
		rs - source of reverse rate (line number of data file)

=back

	By default rank of a rate is determined by the source of the rate:

=over1

	0	-	explicitly defined by "P" directive (highest rank)
	1	-	defined within a transaction by @ 
	2	-	implicitly derived within a transaction from a) transaction amount, and b) equivalent in base 
			currency, denoted by @@
	11 - the same as 2, but for the rate, application of which is limited to the transaction scope
	12 - the same as 2, but for the rate, application of which is limited to the transaction scope

=back

Ranks 11 and 12 are given for rates, recorded within tranactions, by applying @ or @@ syntax, where the
number is negative. This means that the user intentionally wants to restrict use of the rate to the
transaction's scope. This rate is the last resort in global scope, if nothing suitable is found somewhere else.

=cut



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


=cut

sub set_rate {	
	my ($curr_b, $curr_p, $rate, $date, $rank, $line) = @_;

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






