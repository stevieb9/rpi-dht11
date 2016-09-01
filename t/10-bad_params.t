use strict;
use warnings;

use RPi::DHT11;
use Test::More;

use constant {
    DHT => 4,
    TEMP => 1,
    HUM => 5,
};

my $mod = 'RPi::DHT11';

{ # bad params

    my $env;

    my $ok = eval { $env = $mod->new; 1; };
    ok ! $ok, "new() dies with no pin param";
}

done_testing();
