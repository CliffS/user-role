package User::Role;

use strict;
use warnings;
use 5.14.0;

use version; our $VERSION = qv('v0.2.0');

use Tie::DBI;
use Carp;
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

@Tie::DBI::CARP_NOT = (__PACKAGE__);

sub load
{
    my $class = shift;
    my %params = @_;	# db, table, key, user, password
    my $self = new $class;
    my %table;
    tie %table, 'Tie::DBI', \%params;
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
    my ($required, $possesses) = @_;
    if (ref $possesses eq 'ARRAY')
    {
	foreach (@$possesses)
	{
	    return true if $self->check($required, $_);
	}
    }
    else {
	while (defined $possesses)
	{
	    last unless exists $self->{$possesses};	# No such role
	    return true if ($required eq $possesses);
	    $possesses = $self->{$possesses};
	}
    }
    return false;
}

sub enforce
{
    my $self = shift;
    my $ok = $self->check(@_);
    die "unenforceable" unless $ok;
}

sub is
{
    my $self = shift;
    my ($required, $possesses) = @_;
    if (ref $possesses eq 'ARRAY')
    {
	foreach (@$possesses)
	{
	    return true if $self->is($required, $_);
	}
    }
    else {
	return true if ($required eq $possesses);
    }
    return false;
}



    


1;
