#!/usr/bin/perl -w
#
use strict;

use FindBin;
use lib "$FindBin::Bin/../lib";

use Test::More qw(no_plan);

BEGIN {
	use_ok('Sunduk_curr');
}

can_ok('Sunduk_curr',('set_rate'));
can_ok('Sunduk_curr',('get_rate'));

