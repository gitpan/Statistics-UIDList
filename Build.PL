use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new(
    name                => 'Statistics-UIDList',
    module_name         => 'Statistics::UIDList',
    license             => 'perl',
    dist_author         => 'Dai Okabayashi <bayashi@cpan.org>',
    dist_version_from   => 'lib/Statistics/UIDList.pm',
    configure_requires  => {
        'Module::Build' => 0.38,
    },
    build_requires      => {
        'Test::More' => 0.88,
    },
    requires => {
        'perl' => '5.008001',
        'Carp' => 0,
    },
    add_to_cleanup      => [ 'Statistics-UIDList-*' ],
    meta_merge     => {
      resources => {
        repository  => 'http://github.com/bayashi/Statistics-UIDList',
        bugtracker  => 'http://github.com/bayashi/Statistics-UIDList/issues',
      }
    },
    recursive_test_files => 1,
    test_files => (-d '.git' || $ENV{RELEASE_TESTING}) ? ['t/', 'xt/'] : ['t/'],
);

$builder->create_build_script();
