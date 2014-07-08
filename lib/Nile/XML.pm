#	Copyright Infomation
#=========================================================#
#	Module	:	Nile::XML
#	Author		:	Dr. Ahmed Amin Elsheshtawy, Ph.D.
#	Website	:	https://github.com/mewsoft/Nile, http://www.mewsoft.com
#	Email		:	mewsoft@cpan.org, support@mewsoft.com
#	Copyrights (c) 2014-2015 Mewsoft Corp. All rights reserved.
#=========================================================#
package Nile::XML;

use Nile::Base;
use XML::TreePP;

our $VERSION = '0.10';
#=========================================================#
has 'xml' => (
	is			=> 'rw',
    default	=> sub {XML::TreePP->new()},
  );

has 'file' => (
	is			=> 'rw',
  );

has 'encoding' => (
	is			=> 'rw',
    default	=> 'UTF-8',
  );

has 'indent' => (
	is			=> 'rw',
    default	=> 4,
  );

#=========================================================#
sub AUTOLOAD {
	my ($self) = shift;

    my ($class, $method) = our $AUTOLOAD =~ /^(.*)::(\w+)$/;
	#return if $method eq 'DESTROY'; 

    if ($self->can($method)) {
		return $self->$method(@_);
    }

	if (@_) {
		$self->set($method, $_[0]);
	}
	else {
		return $self->get($method);
	}
}
#=========================================================#
sub load {
	
	my ($self, $file) = @_;
	
	$file .= ".xml" unless ($file =~ /\.[^.]*$/i);
	($file && -f $file) || $self->me->abort("Error reading file $file. $!");
	$self->file($file);
	
	my $xml = $self->xml->parsefile($file);
	#$self->{vars} ||= {};
	#$self->{vars} = {%{$self->{vars}}, %$xml};
	$self->{vars} = $xml;
	$self;
}
#=========================================================#
sub keep_order {
	my ($self, $status) = @_;
	# This option keeps the order for each element appeared in XML. Tie::IxHash module is required.
	# This makes parsing performance slow. (about 100% slower than default)
	$self->xml->set(use_ixhash => $status);
	return $self;
}
#=========================================================#
sub set {
	my ($self, %vars) = @_;
	map { $self->{vars}->{$_} = $vars{$_}; } keys %vars;
	$self;
}
#=========================================================#
sub val {
	my ($self, $name, $default) = @_;
	exists $self->{vars}->{$name}? $self->{vars}->{$name} : $default;
}
#=========================================================#
=head2 list()

  ($users, $views, $items) = list( qw( users views items ) );

Returns list of config values.
=cut
sub list {
	my ($self, @n) = @_;
	my @v;
	push @v, $self->get($_) for @n;
	return @v
}
#=========================================================#
sub get {
	my ($self, $path, $default) = @_;
	if ($path !~ /\//) {
		return exists $self->{vars}->{$path}? $self->{vars}->{$path} : $default;
	}
	#---------------------------------------
	$path =~ s/^\/+|\/+$//g;
	my @path = split /\//, $path;
	my $v = $self->{vars};
	
	while (my $k = shift @path) {
		if (!exists $v->{$k}) {
			return $default;
		}
		 $v = $v->{$k};
	}

	return $v;
}
#=========================================================#
sub var {
	my ($self) = @_;
	return $self->{vars};
}
#=========================================================#
sub delete {
	my ($self, @vars) = @_;
	delete $self->{vars}->{$_} for @vars;
	$self;
}
#=========================================================#
sub clear {
	my ($self) = @_;
	$self->{vars} = {};
	$self;
}
#=========================================================#
sub update {
	my ($self, %vars) = @_;
	$self->set(%vars);
	$self->save();
	$self;
}
#=========================================================#
sub save {
	my ($self, $file) = @_;
	$self->xml->set(indent => $self->indent);
	$self->xml->writefile($file || $self->file, $self->{vars}, $self->encoding);
	$self;
}
#=========================================================#
sub get_file {
	my ($self, $file) = @_;
	($file && -f $file) || $self->me->abort("Error reading file '$file'. $!");
	my $xml = $self->xml->parsefile($file);
	return wantarray? %{$xml} : $xml;
}
#=========================================================#
sub add_file {
	my ($self, $file) = @_;
	my $xml = $self->get_file($file);
	while (my ($k, $v) = each %{$xml}) {
		$self->{vars}->{$k} = $v;
	}
	$self;
}
#=========================================================#
sub DESTROY {
}
#=========================================================#
1;
