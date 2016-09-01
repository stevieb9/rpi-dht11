use ExtUtils::MakeMaker;

WriteMakefile(
    NAME              => 'RPi::DHT11',
    VERSION_FROM      => 'lib/RPi/DHT11.pm',
    PREREQ_PM         => {},
    ($] >= 5.005 ?
      (ABSTRACT_FROM  => 'lib/RPi/DHT11.pm',
       AUTHOR         => 'Steve Bertrand <steveb@cpan.org>') : ()),
    LIBS              => ['-lwiringPi'],
    DEFINE            => '',
    INC               => '-I.',
);
