package RPi::DHT11;
use strict;
use warnings;

use Carp qw(croak);

our $VERSION = '0.07_02';

require XSLoader;
XSLoader::load('RPi::DHT11', $VERSION);

sub new {
    my ($class, $pin) = @_;

    croak "you must supply a pin number\n" if ! defined $pin;

    my $self = bless {}, $class;
    $self->_pin($pin);

    sanity();

    return $self;
}
sub temp {
    my ($self, $want) = @_;
    my $temp = c_temp($self->_pin);

    if (defined $want && $want =~ /f/i){
        $temp = $temp * 9 / 5 + 32;
    }
    return int($temp + 0.5);
}
sub humidity {
    my $self = shift;
    return c_humidity($self->_pin);
}
sub cleanup {
    my $self = shift;
    return c_cleanup($self->_pin);
}
sub _pin {
    # set/get the pin number
    if (@_ == 2){
        $_[0]->{pin} = $_[1];
    }
    return $_[0]->{pin};
}
sub DESTROY {
    my $self = shift;
    $self->cleanup;
}
1;
__END__

=head1 NAME

RPi::DHT11 - Fetch the temperature/humidity from the DHT11 hygrometer sensor on
Raspberry Pi

=head1 SYNOPSIS

    use RPi::DHT11;

    my $pin = 26;

    my $env = RPi::DHT11->new($pin);

    my $temp     = $env->temp;
    my $humidity = $env->humidity;

=head1 DESCRIPTION

This module is an interface to the DHT11 temperature/humidity sensor when
connected to a Raspberry Pi's GPIO pins.

Due to the near-realtime access requirements of reading the input pin of the
sensor, the core of this module is written in XS (C).

This module requires the L<wiringPi|http://wiringpi.com/> library to be
installed, and uses WiringPi's GPIO pin numbering scheme (see C<gpio readall>
at the command line).

=head1 METHODS

=head2 new($pin)

Parameters:

=head3 $pin

Mandatory. Pin number for the DHT11 sensor's DATA pin (values are 0-40).

=head2 temp($f)

Fetches the current temperature (in Celcius).

Returns an integer of the temperature, in celcius by default.

Parameters:

=head3 $f

Send in the string char C<'f'> to receive the temp in Farenheit.

=head2 humidity

Fetches the current humidity.

Returns the humidity as either an integer of the current humidity level.

=head2 cleanup

Returns the pin back to default state if it's not already. Called automatically
by C<DESTROY()>.

=head1 C TYPEDEFS

=head2 EnvData

Stores the temperature and humidity float values.

    typedef struct env_data {
        int temp;
        int humidity;
    } EnvData;

=head1 C FUNCTIONS

=head2 c_temp

    int c_temp(int spin);

Called by the C<temp()> method.

=head2 c_humidity

    int c_humidity(int spin);

Called by the C<humidity()> method.

=head2 c_cleanup

    int c_cleanup(int spin, int tpin, int hpin);

Called by the C<cleanup()> method, and is always called upon C<DESTROY()>.

=head2 read_env()

    EnvData read_env(int spin);

Not available to Perl.

Polls the pin in a loop until valid data is fetched, then  returns an C<EnvData>
struct containing the temp and humidity float values.

If for any reason the poll of the DHT11 sensor fails (eg: the CRC is incorrect
for either temp or humidity), we will loop and block until valid data is
retrieved.

=head2 noboard_test()

    bool noboard_test();

Checks whether the C<RDE_NOBOARD_TEST> environment variable is set to a true
value. Returns true if so, and false if not. This bool is used for testing
purposes only.

Not available to Perl.

=head2 sanity()

    void sanity();

If we're on a system that isn't a Raspberry Pi, things break. We call this in
C<new()>, and if sanity checks fail, we exit (unless in RDE_NOBOARD_TEST
environment variable is set to true).

Called only from the C<new()> method.

=head1 ENVIRONMENT VARIABLES

There are a couple of env vars to help prototype and run unit tests when not on
a RPi board.

=head2 RDE_HAS_BOARD

Set to C<1> to tell the unit test runner that we're on a Pi.

=head2 RDE_NOBOARD_TEST

Set to C<1> to tell the system we're not on a Pi. Most methods/functions will
return default (ie. non-live) data when in this mode.

=head1 SEE ALSO

- L<wiringPi|http://wiringpi.com/>

=head1 AUTHOR

Steve Bertrand, E<lt>steveb@cpan.org<gt>

=head1 LICENSE AND COPYRIGHT

Copyright 2016 Steve Bertrand.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See L<http://dev.perl.org/licenses/> for more information.
