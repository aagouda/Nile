#	Copyright Infomation
#=========================================================#
#	Module	:	Nile::Router
#	Author		:	Dr. Ahmed Amin Elsheshtawy, Ph.D.
#	Website	:	https://github.com/mewsoft/Nile, http://www.mewsoft.com
#	Email		:	mewsoft@cpan.org, support@mewsoft.com
#	Copyrights (c) 2014-2015 Mewsoft Corp. All rights reserved.
#=========================================================#
package Nile::Router;

use Nile::Base;

use Router::Generic;
use Tie::IxHash;

our $VERSION = '0.10';
#=========================================================#
has 'router' => (
      is      => 'rw',
      isa    => 'Router::Generic',
	  lazy	=> 1,
	  default => sub {Router::Generic->new}
  );
#=========================================================#
sub load {
	my ($self, $file) = @_;

	$file .= ".xml" unless ($file =~ /\.xml$/i);
	my $filename = $self->me->file->catfile($self->me->var->get("route_dir"), $file);
	
	# keep routes sorted
	$self->me->xml->keep_order(1);

	my $xml = $self->me->xml->get_file($filename);
	
	if (!$self->{route}) {
		$self->{route} = {};
		tie(%{$self->{route}}, 'Tie::IxHash');
	}

	#$self->{route} = {%{$self->{route}}, %$xml};

	my ($regexp, $capture, $uri_template);
	my ($k, $v, $defaults, $key, $val);

	while (($k, $v) = each %{$xml}) {
		# <register route="register" action="Accounts/Register/register" method="get" defaults="year=1900|month=1|day=23" />
		
		$v->{-defaults} ||= "";
		$defaults = {};
		foreach (split (/\|/, $v->{-defaults})) {
			($key, $val) = split (/\=/, $_);
			$defaults->{$key} = $val;
		}

		$self->router->add_route(
					name  => $k,
					path  => $v->{-route},
					target  => $v->{-action},
					method  => $v->{-method} || '*',
					defaults  => $defaults,
				);
	}

	$self;
}
#=========================================================#
sub match {
	my ($self, $route, $method) = @_;
	
	$route || return;
	my $uri = $self->router->match($route, $method);
	$uri || return;
	
	#$uri = /blog/view/?lang=en&locale=us&Article=Home
	my ($action, $query) = split (/\?/, $uri);
	
	my ($args, $k, $v);

	foreach (split(/&/, $query)) {
		($k, $v) = split (/=/, $_);
		$args->{$k} = $self->url_decode($v);
	}

	return wantarray? ($action, $args, $uri, $query) : {action=>$action, args=>$args, query=>$query, uri=>$uri};
}
#=========================================================#
sub add_route {
	my ($self) = shift;
	return $self->router->add_route(@_);
}
#=========================================================#
sub replace_route {
	my ($self) = shift;
	return $self->router->replace_route(@_);
}
#=========================================================#
sub uri_for {
	my ($self) = shift;
	return $self->router->uri_for(@_);
}
#=========================================================#
sub route_for {
	my ($self) = shift;
	return $self->router->route_for(@_);
}
#=========================================================#
sub url_decode {
	my ( $self, $decode ) = @_;
    return () unless defined $decode;
    $decode =~ tr/+/ /;
    $decode =~ s/%([a-fA-F0-9]{2})/ pack "C", hex $1 /eg;
    return $decode;
}
#=========================================================#
  sub url_encode {
	my ( $self, $encode ) = @_;
	return () unless defined $encode;
	$encode =~ s/([^A-Za-z0-9\-_.!~*'() ])/ uc sprintf "%%%02x",ord $1 /eg;
	$encode =~ tr/ /+/;
	return $encode;
  }
#=========================================================#

1;