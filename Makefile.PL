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
    BUILD_REQUIRES => {
        'Test::More' => 0,
	'Test::Pod::Coverage'	=> 0,
	'Test::Pod' => 0,
    },
    PREREQ_PM => {
        'Tie::DBI'  => 0,
	'enum'	    => 0,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'User-Role-*' },
);
