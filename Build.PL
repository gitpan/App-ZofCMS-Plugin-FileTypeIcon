use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new(
    module_name         => 'App::ZofCMS::Plugin::FileTypeIcon',
    license             => 'perl',
    dist_author         => q|Zoffix <'zoffix@cpan.org'>|,
    dist_version_from   => 'lib/App/ZofCMS/Plugin/FileTypeIcon.pm',
    build_requires => {
        'Test::More' => 0,
    },
    build_recommends => {
        'App::ZofCMS::Test::Plugin' => 0.0104,
    },
    requires => {
        'App::ZofCMS'               => 0.0211,
        'File::Spec'                => 3.2701,
        'App::ZofCMS::Plugin::Base' => 0.0102,
    },
    add_to_cleanup      => [ 'App-ZofCMS-Plugin-FileTypeIcon-*' ],
    create_makefile_pl => 'traditional',
);

$builder->create_build_script();
