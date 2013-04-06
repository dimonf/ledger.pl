#!/usr/bin/perl

package Sunduk_Data;

use strict;
use Exporter;
use vars qw($VERSION @ISA @EXPORT @EXPORT_OK %EXPORT_TAGS);

$VERSION			= 1.00;
@ISA				= qw(Exporter);
@EXPORT			= ();
@EXPORT_OK		= qw(pr_bin_search  bin_search  get_dates);
%EXPORT_TAGS	= ( ALL => [qw(pr_bin_search get_dates bin_search)],
		  				SEARCH => [qw(pr_bin_search bin_search)],
			 			);

use Data::Dumper;
use Test::Most;
use Time::HiRes qw/ tv_interval gettimeofday /;

sub bin_search {
     my ($array, $target) = @_;

     # $low is first element that is not too low;
     # $high is the first that is too high
     #
     my ( $low, $high ) = ( 0, scalar(@$array) );

     # Keep trying as long as there are elements that might work.
     #
     while ( $low < $high ) {
         # Try the middle element.

         use integer;
         my $cur = ($low+$high)/2;
         if ($array->[$cur] lt $target) {
	  		   $low  = $cur + 1;                     # too small, try higher
	 		} else {
	     		$high = $cur;                         # not too small, try lower
	 		} 
     }
     $low;
}

sub pr_bin_search {
    my ($array, $target) = @_;

	#proved to be in fact much slower than regular binary search (bin_search)


    # $low is first element that is not too low;
    # $high is the first that is too high
    # $common is the index of the last character tested for
    #    equality in the elements at $low-1 and $high.
    #    Rather than compare the entire string value, we only
    #    use the "first different character".
    #    We start with character position -1 so that character
    #    0 is the one to be compared.
    #
    my ( $low, $high, $common ) = ( 0, scalar(@$array), -1 );

    return 0 if $high == -1 || $array->[0] ge $target;
    return $high if $array->[$high-1] lt $target;
    --$high;

    my ($low_ch,  $high_ch,  $targ_ch ) = (0, 0);
    my ($low_ord, $high_ord, $targ_ord);

    # Keep trying as long as there are elements that might work.
    #
    while( $low < $high ) {
        if ($low_ch eq $high_ch) {
            while ($low_ch eq $high_ch) {
                return $low if $common == length($array->[$high]);
                ++$common;
                $low_ch  = substr( $array->[$low],  $common, 1 );
                $high_ch = substr( $array->[$high], $common, 1 );
            }
            $targ_ch = substr( $target, $common, 1 );
            $low_ord  = ord( $low_ch  );
            $high_ord = ord( $high_ch );
            $targ_ord = ord( $targ_ch );
        }
        # Try the proportional element (the preceding code has
        # ensured that there is a nonzero range for the proportion
        # to be within).

        my $cur = $low;
        $cur += int( ($high - 1 - $low) * ($targ_ord - $low_ord)
                        / ($high_ord - $low_ord) );
        my $new_ch = substr( $array->[$cur], $common, 1 );
        my $new_ord = ord( $new_ch );

        if ($new_ord < $targ_ord
                || ($new_ord == $targ_ord
                    && $array->[$cur] lt $target) ) {
            $low  = $cur+1;       # too small, try higher
            $low_ch  = substr( $array->[$low], $common, 1 );
            $low_ord = ord( $low_ch );
        } else {
            $high = $cur;         # not too small, try lower
            $high_ch  = $new_ch;
            $high_ord = $new_ord;
        }
    }
    return $low;
}

sub get_dates {
	#quick and dirty way to compile sorted list of dates within 
	#given range. Each month has 31 days. All pints are equal.
	my ($start_date, $stop_date) = @_;
	my @start_a = ($start_date =~ /(\d{4}).(\d{2}).(\d{2})/);
	my @stop_a = ($stop_date =~ /(\d{4}).(\d{2}).(\d{2})/);
	my ($years, $months, $days) = (102,12,31);
	my @dates;

	my ($year,$month,$day) = @start_a;
	my ($month_str, $day_str);
	
	while ($year <= $stop_a[0]) {
		$months = $stop_a[1] if $year == $stop_a[0];
		while ($month <= $months) {
			$days = $stop_a[2] if $year == $stop_a[0] && $month == $stop_a[1];
			while ($day <= $days) {
				$day_str = length($day) == 1 ? "0$day": $day;
				$month_str = length($month) == 1 ? "0$month": $month;
				push (@dates, "$year-$month_str-$day_str");
				$day ++;
			}
			$day = 1;
			$month++;
		 }
		 $month = 1;
		 $year ++;
	}
	@dates;
}


