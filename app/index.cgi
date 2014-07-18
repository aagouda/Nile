#!C:\perl\bin\perl.exe
#!/usr/bin/perl
#=========================================================#
#	Copyright Infomation
#=========================================================#
#	Module	:	index.cgi
#	Author		:	Dr. Ahmed Amin Elsheshtawy, Ph.D.
#	Website	:	https://github.com/mewsoft/Nile, http://www.mewsoft.com
#	Email		:	mewsoft@cpan.org, support@mewsoft.com
#	Copyrights (c) 2014-2015 Mewsoft Corp. All rights reserved.
#=========================================================#
	print "Content-type: text/html;charset=utf-8\n\n";

	use Data::Dumper;
	use Benchmark qw(:all);
	
	use File::Spec;
	use File::Basename;
	BEGIN {
		push @INC, File::Spec->catfile(dirname(dirname(File::Spec->rel2abs(__FILE__))), "lib");
	}

	use Nile;

	my $app = Nile->new();

	$app->init(
					
					# base application path, auto detected if not set
					path		=>	dirname(File::Spec->rel2abs(__FILE__)),

					# site language for user, auto detected if not set
					lang		=>	"en-US",

					# theme used
					theme		=>	"default",
				);
	
	#$app->run();
	#exit;
	
	my $config = $app->config;
	$config->load("config.xml");
	#$app->dump($config);

	# connect to the database. pass the connection params or try to load it from the config object.
	#$app->connect();
	#$app->connect(%params);
	
	# load langauge file general.xml
	$app->lang->load("general");
	
	# load routes file route.xml
	$app->router->load("route");
	
	# inline actions
	$app->action("get", "/forum/home", sub {
		my ($self) = @_;
		# $self is set to the application context object same as $self->me in plugins
		say $self->request->virtual_host;
		say "Hello world from inline actions forum/home.";
	});

	$app->action("get", "/accounts/login", sub {
		my ($self) = @_;
		say "Hello world from inline actions accounts/login.";
	});

	$app->dispatcher->dispatch;
	
	# run any plugin action or route
	#$app->dispatcher->dispatch('/accounts/register/create');
	#$app->dispatcher->dispatch('/accounts/register/create', 'POST');
	
	# disconnect from database
	#$app->disconnect();

	#$app->bm->lap("start");
	#sleep 1;	
	#$app->bm->lap("end");
	#$app->bm->stop;
	#print $app->bm->summary;
	#print $app->bm->total_time;

	#$app->debug->off;
	#say $app->debug(1),"  ,  ", $app->debug;

	exit;
#=========================================================#
sub test_paginate {

	my $paginate = $app->paginate(
			total_entries       => 100,
			entries_per_page    => 10, 
			current_page        => 4,
			pages_per_set       => 7,
			mode => "slide", #modes are 'slide', 'fixed', default is 'slide'
		);

	# Print the page numbers of the current set (visible pages)
	foreach my $page (@{$paginate->pages_in_set()}) {
		($page == $paginate->current_page())? print "[$page] " : print "$page ";
	}

	say "\n";
	# rendering
	say "out: " . $paginate->out, "\n";
	say "showing: " . $paginate->showing, "\n";
	say "showing list: " . $paginate->showing_list, "\n";
}
#=========================================================#
