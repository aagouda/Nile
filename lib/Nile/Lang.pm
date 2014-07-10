#	Copyright Infomation
#=========================================================#
#	Module	:	Nile::Lang
#	Author		:	Dr. Ahmed Amin Elsheshtawy, Ph.D.
#	Website	:	https://github.com/mewsoft/Nile, http://www.mewsoft.com
#	Email		:	mewsoft@cpan.org, support@mewsoft.com
#	Copyrights (c) 2014-2015 Mewsoft Corp. All rights reserved.
#=========================================================#
package Nile::Lang;

our $VERSION = '0.13';

=pod

=encoding utf8

=head1 NAME

Nile::Lang - Language file manager.

=head1 SYNOPSIS
		
	package Nile::Plugin::Home::Home;

	use Nile::Base;

	sub home  : GET Action {
		my ($self) = @_;
	}
	
	1;

=head1 DESCRIPTION

Nile::Lang - Language file manager.

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
		$self->{vars}->{$self->{lang}}->{$method} = $_[0];
	}
	else {
		return $self->{vars}->{$self->{lang}}->{$method};
	}
}
#=========================================================#
sub  lang {
my ($self, $lang) = @_;
	$self->{lang} = $lang if ($lang);
	$self->{lang} ||= $self->me->var->get("lang");
	return $self->{lang};
}
#=========================================================#
sub load {
my ($self, $file, $lang) = @_;

	$file .= ".xml" unless ($file =~ /\.xml$/i);
	$lang ||= $self->{lang} ||= $self->me->var->get("lang");

	my $filename = $self->me->file->catfile($self->me->var->get("langs_dir"), $lang, $file);

	my $xml = $self->me->xml->get_file($filename);
	$self->{vars}->{$lang} ||= {};
	$self->{vars}->{$lang} = {%{$self->{vars}->{$lang}}, %$xml};
	$self;
}
#=========================================================#
sub clear {
my ($self, $lang) = @_;
	($lang)? $self->{vars}->{$lang} = {} : $self->{vars} = {};
	$self;
}
#=========================================================#
 sub vars {
my ($self, $lang) = @_;
	if ($lang) {
		return wantarray? %{$self->{vars}->{$lang}} : $self->{vars}->{$lang};
	}
	else {
		return wantarray? %{$self->{vars}} : $self->{vars};
	}
}
#=========================================================#
sub set {
my ($self, %vars) = @_;
	map {$self->{vars}->{$self->{lang}}->{$_} = $vars{$_}} keys %vars;
	$self;
}
#=========================================================#
sub get {
my ($self, $name, $lang) = @_;
	$lang ||= $self->{lang} ||= $self->me->var->get("lang");
	$self->{vars}->{$lang}->{$name};
}
#=========================================================#
sub list {
my ($self, @n) = @_;
	@{$self->{vars}->{$self->{lang}}}{@n};
}
#=========================================================#
sub keys {
my ($self) = @_;
	(keys %{$self->{vars}->{$self->{lang}}});
}
#=========================================================#
sub exists {
my ($self, $name) = @_;
	exists $self->{vars}->{$self->{lang}}->{$name};
}
#=========================================================#
sub delete {
my ($self, @n) = @_;
	delete $self->{vars}->{$self->{lang}}->{$_} for @n;
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
