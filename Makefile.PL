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
        'Moose'      => '2.0006',
        'JSON'       => '2.15',
        'HTTP::Request'  => '1.40',
        'LWP::UserAgent' => '2.33',
        'Data::Validate::URI' => '0.05',
        'namespace::clean'    => '0.20',
        'Moose::Util::TypeConstraints' => '2.0006',
    },
    ($ExtUtils::MakeMaker::VERSION >= 6.3002
      ? ('LICENSE'=> 'perl')
      : ()),
);