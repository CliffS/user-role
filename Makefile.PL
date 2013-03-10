use 5.006;
use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'User::Role',
    AUTHOR              => q{Cliff Stanford <cliff@may.be>},
    VERSION_FROM        => 'lib/User/Role.pm',
    ABSTRACT_FROM       => 'lib/User/Role.pm',
    ($ExtUtils::MakeMaker::VERSION >= 6.3002
      ? ('LICENSE'=> 'perl')
      : ()),
    PL_FILES            => {},
    PREREQ_PM => {
        'Test::More' => 0,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'User-Role-*' },
);
