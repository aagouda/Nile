#	Copyright Infomation
#=========================================================#
#	Module	:	Nile::Registry
#	Author		:	Dr. Ahmed Amin Elsheshtawy, Ph.D.
#	Website	:	https://github.com/mewsoft/Nile, http://www.mewsoft.com
#	Email		:	mewsoft@cpan.org, support@mewsoft.com
#	Copyrights (c) 2014-2015 Mewsoft Corp. All rights reserved.
#=========================================================#
package Nile::Registry;

our $VERSION = '0.11';

=pod

=encoding utf8

=head1 NAME

Nile::Registry - Application registry table manager.

=head1 SYNOPSIS
		

=head1 DESCRIPTION

Nile::Registry - Application registry table manager.

=cut

use Nile::Base;

#=========================================================#
has 'table' => (
	is			=> 'rw',
    default	=> 'settings',
  );

has 'name' => (
	is			=> 'rw',
    default	=> 'name',
  );

has 'value' => (
	is			=> 'rw',
    default	=> 'value',
  );
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
sub load {
	my ($self, $table, $name, $value) = @_;
	$self->table($table) if ($table);
	$self->name($name) if ($name);
	$self->value($value) if ($value);
	$self->{vars} = $self->me->db->colhash(qq{select $self->name($name), $self->value($value) from $self->table($table)});
	$self;
}
#=========================================================#
sub clean {
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
	my ($name, $value, $n, $v);
	
	while (($name, $value) = each %vars) {
		$n = $self->me->db->quote($name);
		$v = $self->me->db->quote($value);
		if (exists $self->{vars}->{$name}) {
			$self->me->db->run(qq{update $self->table set $self->name=$n, $self->value=$v});
		}
		else {
			$self->me->db->run(qq{insert into $self->table set $self->name=$n, $self->value=$v});
		}
		$self->{vars}->{$name} = $value;
	}
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
	$self->me->db->run(qq{delete from $self->table where $self->name=} . $self->me->db->quote($_)) for @n;
	delete $self->{vars}->{$_} for @n;
}
#=========================================================#
sub clear {
	my ($self, $confirm) = @_;
	return unless ($confirm);
	$self->me->db->run(q{delete from $self->table});
	$self->{vars} = {};
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
