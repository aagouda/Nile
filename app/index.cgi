#!/usr/bin/perl
#!C:\perl\bin\perl.exe
#=========================================================#
#	Copyright Infomation
#=========================================================#
#	Module	:	index.cgi
#	Author		:	Dr. Ahmed Amin Elsheshtawy, Ph.D.
#	Website	:	https://github.com/mewsoft/Nile, http://www.mewsoft.com
#	Email		:	mewsoft@cpan.org, support@mewsoft.com
#	Copyrights (c) 2014-2015 Mewsoft Corp. All rights reserved.
#=========================================================#
	#print "Content-type: text/html;charset=utf-8\n\n";
	use Data::Dumper;
	use utf8;
	#======================================================
	# push the local Nile module folder on Perl @INC, remove if Nile module installed
	use File::Spec;
	use File::Basename;
	BEGIN {
		push @INC, File::Spec->catfile(dirname(dirname(File::Spec->rel2abs(__FILE__))), "lib");
	}
	#======================================================
	use Nile;

	my $app = Nile->new();
	
	# initialize the application with the shared sessions settings
	$app->init(
		# base application path, auto detected if not set
		path		=>	dirname(File::Spec->rel2abs(__FILE__)),

		# load config files
		config		=> [ qw(config) ],

		# load route files
		route		=> [ qw(route) ],

		# log file name
		log_file	=>	"log.pm",

		# url action name i.e. index.cgi?action=register
		action_name	=>	"action,route,cmd",

		# app home page plugin/module/method
		default_route	=>	"/Home/Home/index",
		
		# force run mode if not auto detected by default. modes: "psgi", "fcgi" (direct), "cgi" (direct)
		#mode	=>	"fcgi", # psgi, cgi, fcgi
	);
	
	# set the application per single user session settings
	$app->start(
		# site language for user, auto detected if not set
		lang	=>	"en-US",

		# theme used
		theme	=>	"default",
		
		# load language files
		langs	 => [ qw(general) ],
		
		# charset for encoding/decoding and output
		charset => "utf-8",
	);

	# inline actions, return content. url: /forum/home
	$app->action("get", "/forum/home", sub {
		my ($self) = @_;
		# $self is set to the application context object same as $self->me in plugins
		my $content = "Host: " . ($self->request->virtual_host || "") ."<br>\n";
		$content .= "Request method: " . ($self->request->request_method || "") . "<br>\n";
		$content .= "App Mode: " . $self->mode . "<br>\n";
		$content .= "Time: ". time . "<br>\n";
		$content .= "Hello world from inline action /forum/home" ."<br>\n";
		$content .= "أحمد الششتاوى" ."<br>\n";
		$self->response->encoded(0); # encode content
		return $content;
	});
	
	# inline actions, capture print statements, no returns. url: /accounts/login
	$app->capture("get", "/accounts/login", sub {
		my ($self) = @_;
		# $self is set to the application context object same as $self->me in plugins
		say "Host: " . ($self->request->virtual_host || "") . "<br>\n";
		say "Request method: " . ($self->request->request_method || "") . "<br>\n";
		say "App Mode: " . $self->mode . "<br>\n";
		say "Time: ". time . "<br>\n";
		say "Hello world from inline action with capture /accounts/login", "<br>\n";
		say $self->encode("أحمد الششتاوى ") ."<br>\n";
		$self->response->encoded(1); # content already encoded
	});

	# connect to the database. pass the connection params or try to load it from the config object.
	#$app->connect();
	#$app->connect(%params);
	# disconnect from database
	#$app->disconnect();
	
	# run the application and return the PSGI response or print to the output
	# the run process will also run plugins with matched routes files loaded
	$app->run();

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
