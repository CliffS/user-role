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

=head1 VERSION

This document describes User::Role version 0.9.0

=head1 SYNOPSIS

This needs writing.

=head1 DESCRIPTION

This needs writing.

=cut

=head1 METHODS

=head2 Creating a new User:Role object

=head3 new

    my $roles = new User::Role('superuser');

The parameter is the "root" role which always returns true.

=cut

sub new
{
    my $class = shift;
    my $root = shift;
    my $self = $root ?  { root => $root } : {};
    bless $self, $class;
}

@Tie::DBI::CARP_NOT = (__PACKAGE__);

=head3 load

    my $roles = User::Role->load(%parameters);

The parameters are:

=over

=item db, table, key, user, password

These are passed directly to L<Tie::DBI>.

=item root

This is the "root" role, see L</new>.

=back

=cut

sub load
{
    my $class = shift;
    my %params = @_;	# db, table, key, user, password, root
    my $self = $class->new($params{root});
    delete $params{root};
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
    my ($required, $possesses) = @_;
    if (ref $required  eq 'ARRAY')
    {
	my $_;
	return true if $self->check($_) foreach @$required;
    }
    if (ref $possesses eq 'ARRAY')
    {
	foreach (@$possesses)
	{
	    return true if $self->check($required, $_);
	}
    }
    elsif ($possesses eq $self->{root})
    {
	return true;
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
	return true if defined $possesses and ($required eq $possesses);
    }
    return false;
}



    


1;
