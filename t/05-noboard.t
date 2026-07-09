use strict;
use warnings;
use Test::More;

use RPi::DHT11;

# HW-free: RDE_NOBOARD_TEST makes the whole lifecycle skip wiringPi - new()'s
# setup(), the temp/humidity reads and cleanup() all return default data - so
# this runs anywhere the module installs, with no Pi and no sensor attached.
BEGIN { $ENV{RDE_NOBOARD_TEST} = 1; }

my $mod = 'RPi::DHT11';

my $env = $mod->new(4);
isa_ok $env, $mod;

is $env->temp, 0, 'temp(): returns 0 in noboard mode';
is $env->temp('f'), 32, "temp('f'): 0C converts to 32F";
is $env->temp('F'), 32, "temp('F'): the 'f' flag is case-insensitive";
is $env->humidity, 0, 'humidity(): returns 0 in noboard mode';
is $env->cleanup, 0, 'cleanup(): returns 0 without touching wiringPi';

done_testing();
