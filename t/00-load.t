#!perl -T

use Test::More tests => 1;

BEGIN {
    use_ok( 'User::Role' ) || print "Bail out!\n";
}

diag( "Testing User::Role $User::Role::VERSION, Perl $], $^X" );
