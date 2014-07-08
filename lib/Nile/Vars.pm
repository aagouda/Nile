#	Copyright Infomation
#=========================================================#
#	Module	:	Nile::Vars
#	Author		:	Dr. Ahmed Amin Elsheshtawy, Ph.D.
#	Website	:	https://github.com/mewsoft/Nile, http://www.mewsoft.com
#	Email		:	mewsoft@cpan.org, support@mewsoft.com
#	Copyrights (c) 2014-2015 Mewsoft Corp. All rights reserved.
#=========================================================#
package Nile::Vars;

use Nile::Base;

our $VERSION = '0.10';
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

1;