use inc::Module::Install;

name     'Hascheme';
all_from 'lib/Hascheme.pm';
author   'Raimon Grau <raimonster@gmail.com>';
license  'perl';

build_requires 'Test::More';

auto_install;

WriteAll;

