use warnings;
use strict;
use feature 'say';

use RPi::DHT11;

my $e = RPi::DHT11->new(18);

say $e->temp('f');


