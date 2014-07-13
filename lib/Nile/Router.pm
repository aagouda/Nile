#	Copyright Infomation
#=========================================================#
#	Module	:	Nile::Router
#	Author		:	Dr. Ahmed Amin Elsheshtawy, Ph.D.
#	Website	:	https://github.com/mewsoft/Nile, http://www.mewsoft.com
#	Email		:	mewsoft@cpan.org, support@mewsoft.com
#	Copyrights (c) 2014-2015 Mewsoft Corp. All rights reserved.
#=========================================================#
package Nile::Router;

our $VERSION = '0.15';

=pod

=encoding utf8

=head1 NAME

Nile::Router - URL route manager.

=head1 SYNOPSIS
	
	# load routes file from the path/route folder. default file extension is xml.
	$self->me->router->load("route");
	
	# find route action and information if exist in the routes file.
	my ($action, $args, $uri, $query) = $self->me->router->match($route, $request_method);
	
	# or as hash ref
	my $route = $self->me->router->match($route, $request_method);
	$route->{action}, $route->{args}, $route->{query}, $route->{uri}

=head1 DESCRIPTION

Nile::Router - URL route manager.

This module uses L<Router::Generic> module to manage the routing table.

=head2 ROUTES FILES

Routes are stored in a special xml files in the application folder named B<route>. Below is a sample C<route.xml> file.

	<?xml version="1.0" encoding="UTF-8" ?>
	<register route="register" action="Accounts/Register/create" method="get" defaults="year=1900|month=1|day=23" />
	<post route="blog/post/{cid:\d+}/{id:\d+}" action="Blog/Article/post" method="post" />
	<browse route="blog/{id:\d+}" action="Blog/Article/browse" method="get" />
	<view route="blog/view/{id:\d+}" action="Blog/Article/view" method="get" />
	<edit route="blog/edit/{id:\d+}" action="Blog/Article/edit" method="get" />

Each route entry in the routes file has the following format:

	<name route="blog" action="Plugin/Controller/Action" method="get" defaults="k1=v1|k2=v2..." />

The following are the components of the route tag:
The route 'name', this must be unique name for the route.
The url 'route' or path that should match, see L<Router::Generic> for details about this.
The 'action' or target which should be executed if route matched the path.
The 'method' is optional and if provided will only match the route if request method matched it. Empty or '*' will match all.
The 'defaults' is optional and can be used to provide a default values for the route params if not exist. These params if exist will be added to the request params in the request object.

Routes are loaded and matched in the same order they exist in the file, the sort order is kept the same.

=cut

use Nile::Base;

use Router::Generic;
use Tie::IxHash;

#=========================================================#
=head2 router()
	
	$self->me->router->router;

This is a L<Router::Generic> object used internally.

=cut

has 'router' => (
      is      => 'rw',
      isa    => 'Router::Generic',
	  lazy	=> 1,
	  default => sub {Router::Generic->new}
  );
#=========================================================#
=head2 load()
	
	# load routes file. default file extension is xml. load route.xml file.
	$self->me->router->load("route");
	
	# add another routes file. load and add the file blog.xml file.
	$self->me->router->load("blog");

Loads and adds routes files. Routes files are XML files with specific tags. Everytime you load a route file
it will be added to the routes and does not clear the previously loaded files unless you call the clear method.
This method can be chained.

=cut

sub load {
	my ($self, $file) = @_;

	$file .= ".xml" unless ($file =~ /\.xml$/i);
	my $filename = $self->me->file->catfile($self->me->var->get("route_dir"), $file);
	
	# keep routes sorted
	$self->me->xml->keep_order(1);

	my $xml = $self->me->xml->get_file($filename);
	
	if (!$self->{route}) {
		$self->{route} = +{};
		tie(%{$self->{route}}, 'Tie::IxHash');
	}

	#$self->{route} = {%{$self->{route}}, %$xml};

	my ($regexp, $capture, $uri_template);
	my ($k, $v, $defaults, $key, $val);

	while (($k, $v) = each %{$xml}) {
		# <register route="register" action="Accounts/Register/register" method="get" defaults="year=1900|month=1|day=23" />
		
		$v->{-defaults} ||= "";
		$defaults = +{};
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
=head2 match()
	
	# find route action and information if exist in the routes file.
	my ($action, $args, $uri, $query) = $self->me->router->match($route, $request_method);
	
	# or as hash ref
	my $route = $self->me->router->match($route, $request_method);
	$route->{action}, $route->{args}, $route->{query}, $route->{uri}

Match routes from the loaded routes files. If route matched returns route target or action, default arguments if provided,
and uri and query information.

=cut

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
=head2 add_route()
	
	# add new route information to the router object
	$self->me->router->  $router->add_route(
							name  => "blogview",
							path  => "blog/view/{id:\d+}",
							target  => "/Blog/Blog/view",
							method  => "*", # get, post, *, put, delete
							defaults  => {
									id => 1
								}
						);

This method adds a new route information to the routing table. Routes must be unique, so you can't have two routes that both look like /blog/:id for example. 
An exception will be thrown if an attempt is made to add a route that already exists.

=cut

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
=head2 uri_for()

	my $route = $self->me->router->uri_for($route_name, \%params);

Returns the uri for a given route with the provided params.
=cut

sub uri_for {
	my ($self) = shift;
	return $self->router->uri_for(@_);
}
#=========================================================#
=head2 route_for()
	
	my $route = $self->me->router->route_for($path, [$method]);

Returns the route matching the path and method.

=cut

sub route_for {
	my ($self) = shift;
	return $self->router->route_for(@_);
}
#=========================================================#
=head2 url_decode()
	
	my $decode_url = $self->me->router->url_decode($url);

=cut

sub url_decode {
	my ( $self, $decode ) = @_;
    return () unless defined $decode;
    $decode =~ tr/+/ /;
    $decode =~ s/%([a-fA-F0-9]{2})/ pack "C", hex $1 /eg;
    return $decode;
}
#=========================================================#
=head2 url_encode()
	
	my $encoded_url = $self->me->router->url_encode($url);

=cut

  sub url_encode {
	my ( $self, $encode ) = @_;
	return () unless defined $encode;
	$encode =~ s/([^A-Za-z0-9\-_.!~*'() ])/ uc sprintf "%%%02x",ord $1 /eg;
	$encode =~ tr/ /+/;
	return $encode;
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
