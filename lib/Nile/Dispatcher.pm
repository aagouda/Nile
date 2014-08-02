#	Copyright Infomation
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#	Module	:	Nile::Dispatcher
#	Author		:	Dr. Ahmed Amin Elsheshtawy, Ph.D.
#	Website	:	https://github.com/mewsoft/Nile, http://www.mewsoft.com
#	Email		:	mewsoft@cpan.org, support@mewsoft.com
#	Copyrights (c) 2014-2015 Mewsoft Corp. All rights reserved.
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
package Nile::Dispatcher;

our $VERSION = '0.31';

=pod

=encoding utf8

=head1 NAME

Nile::Dispatcher - Application action dispatcher.

=head1 SYNOPSIS
		
	# dispatch the default route or detect route from request
	$app->dispatcher->dispatch;

	# dispatch specific route and request method
	$app->dispatcher->dispatch($route, $request_method);
	$app->dispatcher->dispatch('/accounts/register/create');
	$app->dispatcher->dispatch('/accounts/register/save', 'POST');

=head1 DESCRIPTION

Nile::Dispatcher - Application action dispatcher.

=cut

use Nile::Base;
use Capture::Tiny ();
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
=head2 dispatch()
	
	# dispatch the default route or detect route from request
	$app->dispatcher->dispatch;

	# dispatch specific route and request method
	$app->dispatcher->dispatch($route, $request_method);

Process the action and send output to client.

=cut

sub dispatch {

	my $self = shift;
	
	my $content = $self->dispatch_action(@_);

	return $content;

}
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
=head2 dispatch_action()
	
	# dispatch the default route or detect route from request
	$content = $app->dispatcher->dispatch_action;

	# dispatch specific route and request method
	$content = $app->dispatcher->dispatch_action($route, $request_method);

Process the action and return output.

=cut

sub dispatch_action {

	my ($self, $route, $request_method) = @_;
	
	$request_method ||= $self->me->request->request_method;
	$request_method ||= "ajax" if ($self->me->request->is_ajax);
	$request_method ||= "*";

	$route = $self->route($route);
	$route ||= "";

	# beginning slash. forum/topic => /forum/topic
	$route = "/$route" if ($route !~ /^\//);

	#$match->{action}, $match->{args}, $match->{query}, $match->{uri}, $match->{code}, $match->{route}
	my $match = $self->me->router->match($route, $request_method);
	#$self->me->dump($match);
	
	if ($match->{action}) {
		$route =  $match->{action};
		while (my($k, $v) = each %{$match->{args}}) {
			$self->me->request->add_param($k, $v);
		}
	}
	#------------------------------------------------------
	my ($content, @result);
	#------------------------------------------------------
	# inline actions. $app->action("get", "/home", sub {...});
	# inline actions. $app->capture("get", "/home", sub {...});
	if (ref($route) eq "CODE") {
		if (defined $match->{route}->{attributes} && $match->{route}->{attributes} =~ /capture/i) {
			# run the action and capture output of print statements
			($content, @result) = Capture::Tiny::capture_merged {eval {$route->($self->me)}};
			#say "caputre code....";
		}
		else {
			#say "not caputre code....";
			# run the action and get the returned content
			$content = eval {$route->($self->me)};
		}

		if ($@) {
			$self->me->abort("Dispatcher error. Inline action dispatcher error for route '$route'.\n\n$@");
		}

		return $content;
	}
	#------------------------------------------------------
	# if route is '/' then use the default route
	if (!$route || $route eq "/") {
		$route = $self->me->var->get("default_route");
	}

	$route ||= $self->me->abort("Dispatcher error. No route defined.");
	
	my ($plugin, $controller, $action) = $self->action($route);

	my $class = "Nile::Plugin:\:$plugin:\:$controller";
	
	eval "use $class;";

	if ($@) {
		$self->me->abort("Dispatcher error. Plugin error for route '$route' class '$class'.\n\n$@");
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
			$self->me->abort("Dispatcher error. Plugin '$class' action '$action' does not exist.");
			#$@ , "
			#return "Dispatcher error. Plugin '$class' action '$action' does not exist.";
		}
	}
	
	my $meta = $object->meta;

	my $attrs = $meta->get_method($action)->attributes;
	#say "attr: [$action], ". $self->me->dump($attrs);
	
	# sub home: Action/Capture/Public {...}
	if (!grep(/^(action|public|capture)$/i, @$attrs)) {
		$self->me->abort("Dispatcher error. Plugin '$class' method '$action' is not marked as 'Action' or 'Capture'.");
	}

	#Methods: HEAD, POST, GET, PUT, DELETE, PATCH, [ajax]

	if ($request_method ne "*" && !grep(/^$request_method$/i, @$attrs)) {
		$self->me->abort("Dispatcher error. Plugin '$class' action '$action' request method '$request_method' is not allowed.");
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
	
	if (grep(/^(capture)$/i, @$attrs)) {
		# run the action and capture output of print statements. sub home: Capture {...}
		($content, @result) = Capture::Tiny::capture_merged {eval {$object->$action($self->me)}};
		#say "caputre plugin...";
	}
	else {
		#say "not caputre plugin...";
		# run the action and get the returned content sub home: Action {...}
		$content = eval {$object->$action($self->me)};
	}

	#my ($content, @result) = Capture::Tiny::capture_merged {eval {$object->$action()}};
	#$content .= join "", @result;
	if ($@) {
		$content = "Plugin error: $@\n$content\n";
	}

	return $content;
}
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
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
	
	$route =~ s/^\/+//;
	
	my @parts = split(/\//, $route);

	if (scalar @parts == 3) {
		($plugin, $controller, $action) = @parts;
	}
	elsif (scalar @parts == 2) {
		$plugin = $parts[0];
		$controller = $parts[0];
		$action = $parts[1];
	}
	elsif (scalar @parts == 1) {
		$plugin = $parts[0];
		$controller = $parts[0];
		$action = "index";
	}
	
	$plugin ||= "";
	$controller ||= "";
	
	return (ucfirst($plugin), ucfirst($controller), $action);
}
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
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
		my ($request_uri, $params) = split(/\?/, ($ENV{REQUEST_URI} || $self->me->env->{REQUEST_URI} || ''));
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
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
sub object {
	my $self = shift;
	$self->me->object(__PACKAGE__, @_);
}
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

=pod

=head1 Bugs

This project is available on github at L<https://github.com/mewsoft/Nile>.

=head1 HOMEPAGE

Please visit the project's homepage at L<https://metacpan.org/release/Nile>.

=head1 SOURCE

Source repository is at L<https://github.com/mewsoft/Nile>.

=head1 SEE ALSO

See L<Nile> for details about the complete framework.

=head1 AUTHOR

Ahmed Amin Elsheshtawy,  احمد امين الششتاوى <mewsoft@cpan.org>
Website: http://www.mewsoft.com

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2014-2015 by Dr. Ahmed Amin Elsheshtawy احمد امين الششتاوى mewsoft@cpan.org, support@mewsoft.com,
L<https://github.com/mewsoft/Nile>, L<http://www.mewsoft.com>

This library is free software; you can redistribute it and/or modify it under the same terms as Perl itself.

=cut

1;
