use strict;
use warnings;
use Test::More;

# Loading and the method API need no hardware (the module installs only where
# the BuildCheck confirmed wiringPi), so this runs unconditionally.
use_ok('RPi::DHT11');

my $mod = 'RPi::DHT11';
can_ok $mod, 'temp';
can_ok $mod, 'humidity';
can_ok $mod, 'cleanup';

done_testing();
