use inc::Module::Install;

name     'Catalyst-Installation-local-lib';
all_from 'lib/Catalyst/Installation/local/lib.pm';
author   q{Blabos de Blebe <blabos@cpan.org>};
license  'perl';

build_requires 'Test::More';

auto_install;

WriteAll;

