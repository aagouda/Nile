#	Copyright Infomation
#=========================================================#
#	Module	:	Nile::Vars
#	Author		:	Dr. Ahmed Amin Elsheshtawy, Ph.D.
#	Website	:	https://github.com/mewsoft/Nile, http://www.mewsoft.com
#	Email		:	mewsoft@cpan.org, support@mewsoft.com
#	Copyrights (c) 2014-2015 Mewsoft Corp. All rights reserved.
#=========================================================#
package Nile::Vars;

our $VERSION = '0.13';

=pod

=encoding utf8

=head1 NAME

Nile::Vars - Application Shared variables.

=head1 SYNOPSIS
		

=head1 DESCRIPTION

Nile::Vars - Application Shared variables.

=cut

use Nile::Base;

#=========================================================#
sub AUTOLOAD {
my ($self) = shift;

    my ($class, $method) = our $AUTOLOAD =~ /^(.*)::(\w+)$/;

    if ($self->can($method)) {
		return $self->$method(@_);
    }

	if (@_) {
		$self->{vars}->{$method} = $_[0];
	}
	else {
		return $self->{vars}->{$method};
	}
}
#=========================================================#
sub clear {
	my ($self) = @_;
	$self->{vars} = {};
}
#=========================================================#
sub vars {
	my ($self) = @_;
	return $self->{vars};
}
#=========================================================#
sub set {
	my ($self, %vars) = @_;
	map { $self->{vars}->{$_} = $vars{$_}; } keys %vars;
	$self;
}
#=========================================================#
sub get {
	my ($self, $name, $default) = @_;
	exists $self->{vars}->{$name}? $self->{vars}->{$name} : $default;
}
#=========================================================#
sub list {
	my ($self, @n) = @_;
	@{$self->{vars}}{@n};
}
#=========================================================#
sub keys {
	my ($self) = @_;
	(keys %{$self->{vars}});
}
#=========================================================#
sub exists {
	my ($self, $name) = @_;
	exists $self->{vars}->{$name};
}
#=========================================================#
sub delete {
	my ($self, @n) = @_;
	delete $self->{vars}->{$_} for @n;
}
#=========================================================#
sub DESTROY {
}
#=========================================================#

=pod

=head1 Bugs

This project is available on github at L<https://github.com/mewsoft/Nile>.

=head1 HOMEPAGE

Please visit the project's homepage at L<https://metacpan.org/release/Nile>.

=head1 SOURCE

Source repository is at L<https://github.com/mewsoft/Nile>.

=head1 AUTHOR

Ahmed Amin Elsheshtawy,  احمد امين الششتاوى <mewsoft@cpan.org>
Website: http://www.mewsoft.com

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2014-2015 by Dr. Ahmed Amin Elsheshtawy احمد امين الششتاوى mewsoft@cpan.org, support@mewsoft.com,
L<https://github.com/mewsoft/Nile>, L<http://www.mewsoft.com>

This library is free software; you can redistribute it and/or modify it under the same terms as Perl itself.

=cut

1;
