use strict;
use warnings;
use Test::More;

use RPi::DHT11;

# HW-free: new() croaks on a missing pin before any setup, so this needs no gate.
my $ok = eval { RPi::DHT11->new; 1 };
ok ! $ok, 'new() dies with no pin param';
like $@, qr/must supply a pin/, '  ...error ok';

done_testing();
