use strict;use warnings;
use Module::Build;

my $builder = Module::Build->new(
    sign              => 1,
    module_name       => 'WWW::Google::PageSpeedOnline',
    license           => 'perl',
    dist_author       => q{Mohammad S Anwar <mohammad.anwar@yahoo.com>},
    dist_version_from => 'lib/WWW/Google/PageSpeedOnline.pm',
    add_to_cleanup    => [ 'WWW-Google-PageSpeedOnline-*' ],
    build_requires    => {
        'Test::More' => 0,
        'Readonly'   => 0,
        'Moose'      => '0.89',
        'JSON'       => '2.15',
        'HTTP::Request'  => '1.40',
        'LWP::UserAgent' => '2.33',
        'Data::Validate::URI' => '0.05',
        'Moose::Util::TypeConstraints' => '0.89',
    },
);

$builder->create_build_script();