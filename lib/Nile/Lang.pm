#	Copyright Infomation
#=========================================================#
#	Module	:	Nile::Lang
#	Author		:	Dr. Ahmed Amin Elsheshtawy, Ph.D.
#	Website	:	https://github.com/mewsoft/Nile, http://www.mewsoft.com
#	Email		:	mewsoft@cpan.org, support@mewsoft.com
#	Copyrights (c) 2014-2015 Mewsoft Corp. All rights reserved.
#=========================================================#
package Nile::Lang;

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

1;