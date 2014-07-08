#	Copyright Infomation
#=========================================================#
#	Module	:	Nile::Dispatcher
#	Author		:	Dr. Ahmed Amin Elsheshtawy, Ph.D.
#	Website	:	https://github.com/mewsoft/Nile, http://www.mewsoft.com
#	Email		:	mewsoft@cpan.org, support@mewsoft.com
#	Copyrights (c) 2014-2015 Mewsoft Corp. All rights reserved.
#=========================================================#
package Nile::Dispatcher;

use Nile::Base;

our $VERSION = '0.10';
#=========================================================#
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
	#  if (exists $ENV{HTTP_X_REQUESTED_WITH} && lc $ENV{HTTP_X_REQUESTED_WITH} eq 'xmlhttprequest') {
	#   _do_some_ajaxian_stuff();
	#  }

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

1;