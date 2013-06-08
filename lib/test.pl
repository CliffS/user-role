#!/usr/bin/perl

use strict;
use warnings;
use 5.14.0;

use Data::Dumper;

use File::Basename qw(dirname);
use lib dirname(__FILE__);

use User::Role;

my $role = load User::Role(
    db	    => 'mysql:database=ifonic_pristine_test;host=au.ifonic.net',
    table   => 'user_role',
    key	    => 'role_id',
    user    => 'cliff',
    password => '2gw7h&1C',
);

print Dumper $role;

sub check($$)
{
    my ($a, $b) = @_;
    my $result = $role->check($a, $b);
    my $is = $role->is($a, $b);
    $b = qq("@$b") if ref $b eq 'ARRAY';
    printf "   is: %-15s => %-15s : %s\n", $a, $b, $is ? 'true' : 'false';
    printf "check: %-15s => %-15s : %s\n\n", $a, $b, $result ? 'true' : 'false';
}

check 'superadmin', [ 'superadmin' ];
check 'ppi-salvage', [ 'ppi-user' ];
check 'ppi-user', [ 'left', 'guest', 'ppi-salvage', ];
check 'ppi-user', [ 'ppi-salvage', 'ppi-user' ];
check 'ppi-admin', 'ppi-user';
check 'ppi-user', 'ppi-admin';
