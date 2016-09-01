# this test ensures that if we set up with this module, RPi::WiringPi
# won't barf when we set it up next

# dht11 => pin 18 (gpio)
# led => pin 21 (gpio)

use warnings;
use strict;
use feature 'say';

use RPi::DHT11;
use RPi::WiringPi;
use RPi::WiringPi::Constant qw(:all);

my $e = RPi::DHT11->new(18);
my $pi = RPi::WiringPi->new;

say $e->temp;

my $pin = $pi->pin(21);
$pin->mode(OUTPUT);
$pin->write(HIGH);

sleep 1;
$pi->cleanup;
