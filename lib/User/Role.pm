package User::Role;

use strict;
use warnings;
use 5.14.0;

use version; our $VERSION = qv('v0.1.0');

use Tie::DBI;
use Data::Dumper;

use enum qw{ false true };

=head1 NAME

User::Role - Define recursive user roles

=cut

sub new
{
    my $class = shift;
    my $self = {};
    bless $self, $class;
}

sub load
{
    my $class = shift;
    my %params = @_;	# db, table, key, user, password
    my $self = new $class;
    tie my %table, 'Tie::DBI', \%params;
    $self->add($_, $table{$_}{parent}) foreach keys %table;
    return $self;
}

sub add
{
    my $self = shift;
    my ($id, $parent) = @_;
    $self->{$id} = $parent;
}

sub check
{
    my $self = shift;
    my ($role, $against) = @_;
    if (ref $against eq 'ARRAY')
    {
	foreach (@$against)
	{
	    return true if $self->check($role, $_);
	}
    }
    else {
	while (defined $role)
	{
	    last unless exists $self->{$role};	# No such role
	    return true if ($role eq $against);
	    $role = $self->{$role};
	}
    }
    return false;
}

sub is
{
    my $self = shift;
    my ($role, $against) = @_;
    if (ref $against eq 'ARRAY')
    {
	foreach (@$against)
	{
	    return true if $self->is($role, $_);
	}
    }
    else {
	return true if ($role eq $against);
    }
    return false;
}



    


1;
