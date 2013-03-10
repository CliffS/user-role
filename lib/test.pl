#!/usr/bin/perl

use strict;
use warnings;
use 5.14.0;

use Data::Dumper;

use File::Basename qw(dirname);
use lib dirname(__FILE__);

use User::Role;

my $role = load User::Role(
    db	    => 'mysql:database=ifonic_ppipack;host=au.ifonic.net',
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
    printf "%-15s => %-15s : %s\n", $a, $b, $result ? 'true' : 'false';
}

check 'pension-editor', 'llpension-user';
