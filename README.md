# NAME

User::Role - Define recursive user roles

# VERSION

This document describes User::Role version 0.9.0

# SYNOPSIS

This needs writing.

# DESCRIPTION

This needs writing.

# METHODS

## Creating a new User:Role object

### new

    my $roles = new User::Role('superuser');

The parameter is the "root" role which always returns true.

### load

    my $roles = User::Role->load(%parameters);

The parameters are:

- db, table, key, user, password

    These are passed directly to [Tie::DBI](http://search.cpan.org/perldoc?Tie::DBI).

- root

    This is the "root" role, see ["new"](#new).

### add

    $role->add('new_role', 'parent');

### check

    my $ok = $role->check($required, $possesses);

- $required

    This is either a string or a reference to an array of strings.
    Each string represents a role that is required.  Note, the check
    will pass if the user possesses __any__ of the required roles or
    a role having a required role as a parent.

- $possesses

    Again, this is either a string or a reference to an array of strings.
    Each string represents a role possessed by the user.

### enforce

    $role->enforce($required, $possesses);

This works the same way as [check](http://search.cpan.org/perldoc?check) but will die unless
the check succeeds.

### is

    $role->is($required, $possesses);

This works similarly to [check](http://search.cpan.org/perldoc?check).  The difference is that
`$required` __must__ be a simple string and that the check is
made without reference to the parentage of the `$required`
string.
