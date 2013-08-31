package User::Role;

use strict;
use warnings;
use 5.14.0;

use version; our $VERSION = qv('v0.2.0');

use Tie::DBI;
use Carp;
use Data::Dumper;

use enum qw{ false true };

use version 0.77; our $VERSION = qv(v0.9.0);

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

=head3 add

    $role->add('new_role', 'parent');

=cut

sub add
{
    my $self = shift;
    my ($id, $parent) = @_;
    $self->{$id} = $parent;
}

=head3 check

    my $ok = $role->check($required, $possesses);

=over

=item $required

This is either a string or a reference to an array of strings.
Each string represents a role that is required.  Note, the check
will pass if the user possesses B<any> of the required roles or
a role having a required role as a parent.

=item $possesses

Again, this is either a string or a reference to an array of strings.
Each string represents a role possessed by the user.

=back

=cut

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

=head3 enforce

    $role->enforce($required, $possesses);

This works the same way as L<check> but will die unless
the check succeeds.

=cut

sub enforce
{
    my $self = shift;
    my $ok = $self->check(@_);
    die "unenforceable" unless $ok;
}

=head3 is

    $role->is($required, $possesses);

This works similarly to L<check>.  The difference is that
C<$required> B<must> be a simple string and that the check is
made without reference to the parentage of the C<$required>
string.

=cut

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
