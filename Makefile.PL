use strict;use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME          => 'WWW::Google::PageSpeedOnline',
    AUTHOR        => q{Mohammad S Anwar <mohammad.anwar@yahoo.com>},
    VERSION_FROM  => 'lib/WWW/Google/PageSpeedOnline.pm',
    ABSTRACT_FROM => 'lib/WWW/Google/PageSpeedOnline.pm',
    dist          => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean         => { FILES => 'WWW-Google-PageSpeedOnline-*' },
    PREREQ_PM     => {
        'Test::More' => 0,
        'Readonly'   => 0,
        'Moose'      => '0.89',
        'JSON'       => '2.15',
        'HTTP::Request'  => '1.40',
        'LWP::UserAgent' => '2.33',
        'Data::Validate::URI' => '0.05',
        'Moose::Util::TypeConstraints' => '0.89',
    },
    ($ExtUtils::MakeMaker::VERSION >= 6.3002
      ? ('LICENSE'=> 'perl')
      : ()),
);