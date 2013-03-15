#!/usr/bin/perl

use strict;

use FindBin;
use lib "$FindBin::Bin/../lib";
use Sunduk_Data qw(pr_bin_search bin_search get_dates);

use Data::Dumper;
use Test::Most;
use Time::HiRes qw/ tv_interval gettimeofday /;


my @list;
my @dates_range = ('2002-05-15', '2011-12-31');
my $number_of_invocation = 1000;
my @records;
my @log;

sub timefor(&$) {
		  my $start =  [gettimeofday];
		  $_[0]->();
		  explain sprintf "$_[1] took %s time" => tv_interval($start);
}


timefor {
			@list = get_dates(@dates_range);
} "composition of array we search in ";

timefor {
		  my %t=();
		  my $t;
		  while (scalar keys %t <= $number_of_invocation) {
				 $t = $list[rand @list];	
				 $t{$t} = 1;
		  }
			@records = (keys %t);
} "composition of record's list";



timefor {
		  push @log, "2008-07-$_ ::" . bin_search(\@list, "2008-07-$_") foreach @records;
}
"binary search, executed ". $#records . " times on ".scalar(@list).' items ';

timefor {
		  push @log, "2008-07-$_ : " . pr_bin_search(\@list, "2008-07-$_") foreach  @records;
}
"proportional binary search, executed " . $#records . " times on ".scalar(@list).' items ';
#printf "$_\n" foreach @log;
