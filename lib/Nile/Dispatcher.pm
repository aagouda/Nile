#	Copyright Infomation
#=========================================================#
#	Module	:	Nile::Dispatcher
#	Author		:	Dr. Ahmed Amin Elsheshtawy, Ph.D.
#	Website	:	https://github.com/mewsoft/Nile, http://www.mewsoft.com
#	Email		:	mewsoft@cpan.org, support@mewsoft.com
#	Copyrights (c) 2014-2015 Mewsoft Corp. All rights reserved.
#=========================================================#
package Nile::Dispatcher;

our $VERSION = '0.11';

=pod

=encoding utf8

=head1 NAME

Nile::Dispatcher - Application action dispatcher.

=head1 SYNOPSIS
		
	package Nile::Plugin::Home::Home;

	use Nile::Base;

	sub home  : GET Action {
		my ($self) = @_;
	}
	
	1;

=head1 DESCRIPTION

Nile::Dispatcher - Application action dispatcher.

=cut

use Nile::Base;

#=========================================================#

=head2 dispatch()
	
	# dispatch the default route or detect route from request
	$self->dispatcher->dispatch;

	# dispatch specific route and request method
	$self->me->dispatcher->dispatch($route, $request_method);

=cut

sub dispatch {

	my ($self, $route, $request_method) = @_;
	
	$request_method ||= $self->me->request->request_method;
	$request_method ||= "ajax" if ($self->me->request->is_ajax);
	$request_method ||= "*";

	$route = $self->route($route);

	my ($target, $args, $uri, $query) = $self->me->router->match($route, $request_method);
	if ($target) {
		$route = $target;
		while (my($k, $v) = each %$args) {
			$self->me->request->add_param($k, $v);
		}
	}

	#say "route match:  ($action, $args, $uri, $query)";

	$route ||= $self->me->var->get("default_route");
	$route ||= $self->me->abort(qq{Application Error: No route defined.});

	my ($plugin, $controller, $action) = $self->action($route);
	#say "(plugin=$plugin, controller=$controller, action=$action)";

	my $class = "Nile::Plugin:\:$plugin:\:$controller";
	
	eval "use $class;";

	if ($@) {
		$self->me->abort("Plugin '$class' does not exist.");
	}
	
	my $object = $class->new();

	if (!$object->can($action)) {
		# try /Accounts => Accounts/Accounts/Accounts
		if (($plugin eq $controller) && ($action eq "index")) {
			# try /Accounts => Accounts/Accounts/Accounts
			if ($object->can($plugin)) {
				$action = $plugin;
			}
			# try /Accounts => Accounts/Accounts/accounts
			elsif ($object->can(lc($plugin))) {
				$action = lc($plugin);
			}
		}
		else {
			$self->me->abort("Plugin '$class' action '$action' does not exist.");
		}
	}
	
	my $meta = $object->meta;

	# sub foo : Bar Baz('corge') { ... } => ["Bar", "Baz('corge')"]
	my $attrs = $meta->get_method($action)->attributes;
	
	if (!grep(/^(action|public)$/i, @$attrs)) {
		$self->me->abort("Plugin '$class' method '$action' is not marked as 'action'.");
	}
	
	#Methods: HEAD, POST, GET, PUT, DELETE, PATCH

	if ($request_method ne "*" && !grep(/^$request_method$/i, @$attrs)) {
			$self->me->abort("Plugin '$class' action '$action' request method '$request_method' is not allowed.");
	}

	#$meta->add_method( 'hello' => sub { return "Hello inside hello method. @_" } );
	
	# add method "me" to module, if module has method "me" then add "nile" instead.
	if (!$object->can("me")) {
		$meta->add_attribute( 'me' => ( is => 'rw', default => sub{$self->me}) );
		$object->me($self->me);
	}
	else {
		$meta->add_attribute( 'nile' => ( is => 'rw', default => sub{$self->me}) );
		$object->nile($self->me);
	}

	$object->$action();
}
#=========================================================#

=head2 action()
	
	my ($plugin, $controller, $action) = $self->me->dispatcher->action($route);
	#route /plugin/controller/action returns (Plugin, Controller, action)
	#route /plugin/action returns (Plugin, Plugin, action)
	#route /plugin returns (Plugin, Plugin, index)

Find the action plugin, controller and method name from the provided route.

=cut

sub action {

	my ($self, $route) = @_;

	$route || return;

	my ($plugin, $controller, $action);

	my @parts = split (/\//, $route);

	if (@parts == 3) {
		($plugin, $controller, $action) = @parts;
	}
	elsif (@parts == 2) {
		$plugin = $parts[0];
		$controller = $parts[0];
		$action = $parts[1];
	}
	elsif (@parts == 1) {
		$plugin = $parts[0];
		$controller = $parts[0];
		$action = "index";
	}

	return (ucfirst($plugin), ucfirst($controller), $action);
}
#=========================================================#

=head2 route()
	
	my $route = $self->me->dispatcher->route($route);
	
Detects the current request path if not provided from the request params named as
'action', 'route', or 'cmd' in the post or get methods:
	
	# uri route
	/blog/?action=register
	
	# form route
	<input type="hidden" name="action" value="register" />

If not found, it will try to detect the route from the request uri after the path part
	
	# assuming application path is /blog, so /register will be the route
	/blog/register

=cut

sub route {
	my ($self, $route) = @_;
	
	# if no route, try to find route from the request param named by action_name
	if (!$route) {
		# allow multiple names separated with commas, i.e. 'action', 'action,route,cmd'.
		my @action_name = split(/\,/, $self->me->var->get("action_name"));
		foreach (@action_name) {
			last if ($route = $self->me->request->param($_));
		}
	}
	
	# if no route, get the route from the query string in the REQUEST_URI
	if (!$route) {
		my ($path, $script_name) = $self->me->request->script_name =~ m#(.*)/(.*)$#;
		my ($request_uri, $params) = split /\?/, $ENV{REQUEST_URI} || '';
		if ($request_uri) {
			$route = $request_uri;
		
			# remove path part from the route
			$route =~ s/^$path//;

			#remove script name from route
			$route =~ s/$script_name\/?$//;
		}
		#say "($path, $script_name)($request_uri, $params)$ENV{REQUEST_URI}";
	}
	
	if ($route) {
		$route =~ s!^/!!g;
		$route =~ s!/$!!g;
	}

	return $route;
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
