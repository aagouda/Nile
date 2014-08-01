#	Copyright Infomation
#=========================================================#
#	Module	:	Nile
#	Author		:	Dr. Ahmed Amin Elsheshtawy, Ph.D.
#	Website	:	https://github.com/mewsoft/Nile, http://www.mewsoft.com
#	Email		:	mewsoft@cpan.org, support@mewsoft.com
#	Copyrights (c) 2014-2015 Mewsoft Corp. All rights reserved.
#=========================================================#
package Nile;

our $VERSION = '0.30';

=pod

=encoding utf8

=head1 NAME

Nile - Android Like Visual Web App Framework Separating Code From Design Multi Lingual And Multi Theme.

=head1 SYNOPSIS
	
	#!/usr/bin/perl

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
	);
	
	# set the application per single user session settings
	$app->start(
		# site language for user, auto detected if not set
		lang	=>	"en-US",

		# theme used
		theme	=>	"default",
		
		# load language files
		langs	=> [ qw(general) ],
		
		# charset for encoding/decoding and output
		charset => "utf-8",
	);

	# inline actions, return content. url: /forum/home
	$app->action("get", "/forum/home", sub {
		my ($self) = @_;
		# $self is set to the application context object same as $self->me in plugins
		my $content = "Host: " . $self->request->virtual_host ."<br>\n";
		$content .= "PSGI status: " . $self->psgi . "<br>\n";
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
		say "Host: " . $self->request->virtual_host || "" . "<br>\n";
		say "Request method: " . $self->request->request_method || "" . "<br>\n";
		say "PSGI status: " . $self->psgi . "<br>\n";
		say "Time: ". time . "<br>\n";
		say "Hello world from inline action with capture /accounts/login", "<br>\n";
		say $self->encode("أحمد الششتاوى") ."<br>\n";
		$self->response->encoded(1); # content already encoded
	});
	
	# run the application and return the PSGI response or print to the output
	# the run process will also run plugins with matched routes files loaded
	$app->run();

=head1 DESCRIPTION

Nile - Android Like Visual Web App Framework Separating Code From Design Multi Lingual And Multi Theme.

B<Alpha> version, do not use it for production. The project's homepage L<https://github.com/mewsoft/Nile>.

The main idea in this framework is to separate all the html design and layout from programming. 
The framework uses html templates for the design with special xml tags for inserting the dynamic output into the templates.
All the application text is separated in langauge files in xml format supporting multi lingual applications with easy translating and modifying all the text.
The framework supports PSGI and also direct CGI without any modifications to your applications.

=head1 EXAMPLE APPLICATION

Download and uncompress the module file. You will find an example application folder named B<app>.

=head1 URLs

This framework support SEO friendly url's, routing specific urls and short urls to actions.

The url routing system works in the following formats:

	http://domain.com/plugin/controller/action	# mapped from route file or to Plugin/Controller/action
	http://domain.com/plugin/action			# mapped from route file or to Plugin/Plugin/action or Plugin/Plugin/index
	http://domain.com/plugin			# mapped from route file or to Plugin/Plugin/plugin or Plugin/Plugin/index
	http://domain.com/index.cgi?action=plugin/controller/action
	http://domain.com/?action=plugin/controller/action
	http://domain.com/blog/2014/11/28	# route mapped from route file and args passed as request params

The following urls formats are all the same and all are mapped to the route /Home/Home/index or /Home/Home/home (/Plugin/Controller/Action):
	
	# direct cgi call, you can use action=home, route=home, or cmd=home
	http://domain.com/index.cgi?action=home

	# using .htaccess to redirect to index.cgi
	http://domain.com/?action=home

	# SEO url using with .htaccess. route is auto detected from url.
	http://domain.com/home

=head1 APPLICATION DIRECTORY STRUCTURE

Applications built with this framework must have basic folder structure. Applications may have any additional directories.

The following is the basic application folder tree that must be created manually before runing:

		├───config
		├───lang
		│   └───en-US
		├───lib
		│   └───Nile
		│       └───Plugin
		│           └───Home
		├───log
		├───route
		└───theme
			└───default
				├───image
				├───view
				└───widget

=head1 CREATING YOUR FIRST PLUGIN 'HOME' 

To create your first plugin called Home for your site home page, create a folder called B<Home> in your application path
C</path/lib/Nile/Plugin/Home>, then create the plugin Controller file say B<Home.pm> and put the following code:

	package Nile::Plugin::Home::Home;

	use Nile::Base;
	
	# plugin action, return content. url is routed direct or from routes files. url: /home
	sub home : GET Action {
		
		my ($self, $me) = @_;
		
		# $me is set to the application context object, same as $self->me inside any method
		#my $me = $self->me;

		my $view = $me->view("home");
		
		$view->var(
			fname			=>	'Ahmed',
			lname			=>	'Elsheshtawy',
			email			=>	'sales@mewsoft.com',
			website		=>	'http://www.mewsoft.com',
			singleline		=>	'Single line variable <b>Good</b>',
			multiline		=>	'Multi line variable <b>Nice</b>',
		);
		
		$view->block("first", "1st Block New Content ");
		$view->block("six", "6th Block New Content ");

		#say $me->dump($view->block->{first}->{second}->{third}->{fourth}->{fifth});
		
		return $view->out;
	}

	# run action and capture print statements, no returns. url: /home/news
	sub news: GET Capture {
		my ($self, $me) = @_;
		say qq{Hello world. This content is captured from print statements. The action must be marked by 'Capture' attribute. No returns.};
	}

	1;

=head1 YOUR FIRST VIEW 'home'

Create an html file name it as B<home.html>, put it in the default theme folder B</path/theme/default/views>
and put in this file the following code:

	<vars type="widget" name="header" charset_name="UTF-8" lang_name="en" />
	  
	{first_name} <vars name="fname"/>
	{last_name} <vars name="lname" />
	{email} <vars type="var" name='email' />
	{website} <vars type="var" name="website" />

	{date_now} <vars type="plugin" name="Date::Date->date" format="%Y %M %D" />
	{time_now} <vars type="plugin" name="Date->now" format="%M %Y  %D" />
	{date_time} <vars type="plugin" name="date" format="%M %Y  %D" />

	Version: <vars type="perl"><![CDATA[print $self->me->VERSION; return;]]></vars>

	<vars type="perl">system ('dir c:\\*.bat');</vars>

	<vars type="var" name="singleline" width="400px" height="300px" content="ahmed<b>class/subclass">
		cdata start here is may have html tags and 'single' and "double" qoutes
	</vars>

	<vars type="var" name="multiline" width="400px" height="300px"><![CDATA[ 
		cdata start here is may have html tags <b>hello</b> and 'single' and "double" qoutes
		another cdata line
	]]></vars>

	<!--block:first-->
		<table border="1" style="color:red;">
		<tr class="lines">
			<td align="left" valign="<--valign-->">
				<b>bold</b><a href="http://www.mewsoft.com">mewsoft</a>
				<!--hello--> <--again--><!--world-->
				some html content here 1 top
				<!--block:second-->
					some html content here 2 top
					<!--block:third-->
						some html content here 3 top
						<!--block:fourth-->
						some html content here 4 top
							<!--block:fifth-->
								some html content here 5a
								some html content here 5b
							<!--endblock-->
						<!--endblock-->
						some html content here 3a
					some html content here 3b
				<!--endblock-->
			some html content here 2 bottom
			</tr>
		<!--endblock-->
		some html content here 1 bottom
	</table>
	<!--endblock-->
	some html content here1-5 bottom base

	<vars type="widget" name="footer" title="cairo" lang="ar" />

=head1 YOUR FIRST WIDGETS 'header' AND 'footer'

The framework supports widgets, widgets are small views that can be repeated in many views for easy layout and design.
For example, you could make the site header template as a widget called B<header> and the site footer template as a 
widget called B<footer> and just put the required xml special tag for these widgets in all the B<Views> you want.
Widgets files are html files located in the theme B<'widget'> folder

Example widget B<header.html>

	<!doctype html>
	<html lang="[:lang_name:]">
	 <head>
	  <meta http-equiv="content-type" content="text/html; charset=[:charset_name:]" />
	  <title>{page_title}</title>
	  <meta name="Keywords" content="{meta_keywords}" />
	  <meta name="Description" content="{meta_description}" />
	 </head>
	 <body>

Example widget B<footer.html>

	</body>
	</html>

then all you need to include the widget in the view is to insert these tags:

	<vars type="widget" name="header" charset_name="UTF-8" lang_name="en" />
	<vars type="widget" name="footer" />

You can pass args to the widget like B<charset_name> and B<lang_name> to the widget above and will be replaced with their values.


=head1 LANGUAGES

All application text is located in text files in xml format. Each language supported should be put under a folder named
with the iso name of the langauge under the folder path/lang.

Example langauge file B<'general.xml'>:

	<?xml version="1.0" encoding="UTF-8" ?>
	<site_name>Site Name</site_name>
	<home>Home</home>
	<register>Register</register>
	<contact>Contact</contact>
	<about>About</about>
	<copyright>Copyright</copyright>
	<privacy>Privacy</privacy>

	<page_title>Create New Account</page_title>
	<first_name>First name:</first_name>
	<middle_name>Middle name:</middle_name>
	<last_name>Last name:</last_name>
	<full_name>Full name:</full_name>
	<email>Email:</email>
	<job>Job title:</job>
	<website>Website:</website>
	<agree>Agree:</agree>
	<company>Email:</company>

=head1 Routing

The framework supports url routing, route specific short name actions like 'register' to specific plugins like Accounts/Register/create.

Below is B<route.xml> file example should be created under the path/route folder.

	<?xml version="1.0" encoding="UTF-8" ?>
	<home route="/home" action="/Home/Home/home" method="get" />
	<register route="/register" action="/Accounts/Register/register" method="get" defaults="year=1900|month=1|day=23" />
	<post route="/blog/post/{cid:\d+}/{id:\d+}" action="/Blog/Article/Post" method="post" />
	<browse route="/blog/{id:\d+}" action="/Blog/Article/Browse" method="get" />
	<view route="/blog/view/{id:\d+}" action="/Blog/Article/View" method="get" />
	<edit route="/blog/edit/{id:\d+}" action="/Blog/Article/Edit" method="get" />

=head1 CONFIG

The framework supports loading and working with config files in xml formate located in the folder 'config'.

Example config file path/config/config.xml:

	<?xml version="1.0" encoding="UTF-8" ?>
	<admin>
		<user>admin_user</user>
		<password>admin_pass</password>
	</admin>
	<database>
		<driver>mysql</driver>
		<host>localhost</host>
		<dsn></dsn>
		<port>3306</port>
		<name>blog</name>
		<user>blog</user>
		<pass>pass1234</pass>
		<attribute>
		</attribute>
		<encoding>utf8</encoding>
	</database>


=head1 APPLICATION INSTANCE SHARED DATA

The framework is fully Object-oriented to allow multiple separate instances, we use the shared B<var> method
on the main object to access all application shared data. The plugin modules files will have the following features.

Moose enabled
Strict and Warnings enabled.
a Moose attribute called 'me' or 'nile' injected in the same plugin class holds the
application singleton instance to access all the shared data and methods.

you will be able to access from the plugin class the shared vars as:
	
	$self->me->var->get("lang");

you also can use auto getter/setter
	
	$self->me->var->lang;


=head1 URL REWRITE .htaccess

To hide the script name B<index.cgi> from the url and allow nice SEO url routing, you need to turn on url rewrite on
your web server and have .htaccess file in the application folder with the index.cgi.

Below is a sample .htaccess which redirects all requests to index.cgi file.

	# Don't show directory listings for URLs which map to a directory.
	Options -Indexes -MultiViews

	# Follow symbolic links in this directory.
	Options +FollowSymLinks

	#Note that AllowOverride Options and AllowOverride FileInfo must both be in effect for these directives to have any effect, 
	#i.e. AllowOverride All in httpd.conf
	Options +ExecCGI
	AddHandler cgi-script cgi pl 

	# Set the default handler.
	DirectoryIndex index.cgi index.html index.shtml

	# save this file as UTF-8 and enable the next line for utf contents
	#AddDefaultCharset UTF-8

	# REQUIRED: requires mod_rewrite to be enabled in Apache.
	# Please check that, if you get an "Internal Server Error".
	RewriteEngine On

	#=========================================================#
	# force use www with http and https so http://domain.com redirect to http://www.domain.com
	#add www with https support - you have to put this in .htaccess file in the site root folder
	# skip local host
	RewriteCond %{HTTP_HOST} !^localhost
	# skip IP addresses
	RewriteCond %{HTTP_HOST} ^([a-z.]+)$ [NC]
	RewriteCond %{HTTP_HOST} !^www\. 
	RewriteCond %{HTTPS}s ^on(s)|''
	RewriteRule ^ http%1://www.%{HTTP_HOST}%{REQUEST_URI} [L,R=301]
	#=========================================================#
	RewriteCond %{REQUEST_FILENAME} !-f
	RewriteCond %{REQUEST_FILENAME} !-d
	RewriteCond %{REQUEST_URI} !=/favicon.ico
	RewriteRule ^(.*)$ index.cgi [L,QSA]

=head1 REQUEST

The http request is available as a shared object extending the L<CGI::Simple> module. This means that all methods supported
by L<CGI::Simple> is available with the additions of these few methods:

	is_ajax
	is_post
	is_get
	is_head
	is_put
	is_delete
	is_patch

You access the request object by $self->me->request.

=head1 ERRORS, WARNINGS, ABORTING
	
To abort the application at anytime with optional message and stacktrace, call the method:
	
	$self->me->abort("application error, can not find file required");

For fatal errors with custom error message
	
	$self->me->error("error message");

For fatal errors with custom error message and  full starcktrace
	
	$self->me->errors("error message");

For displaying warning message

	$self->me->warning("warning message");

=head1 LOGS

The framework supports a log object which is a L<Log::Tiny> object which supports unlimited log categories, so simply
you can do this:

	$self->me->log->info("application run start");
	$self->me->log->DEBUG("application run start");
	$self->me->log->ERROR("application run start");
	$self->me->log->INFO("application run start");
	$self->me->log->ANYTHING("application run start");

=head1 FILE

The file object provides tools for reading files, folders, and most of the functions in the modules L<File::Spec> and L<File::Basename>.

to get file content as single string or array of strings:
	
	$content = $self->me->file->get($file);
	@lines = $self->me->file->get($file);

supports options same as L<File::Slurp>.

To get list of files in a specific folder:
	
	#files($dir, $match, $relative)
	@files = $self->me->file->files("c:/apache/htdocs/nile/", "*.pm, *.cgi");
	
	#files_tree($dir, $match, $relative, $depth)
	@files = $self->me->file->files_tree("c:/apache/htdocs/nile/", "*.pm, *.cgi");

	#folders($dir, $match, $relative)
	@folders = $self->file->folders("c:/apache/htdocs/nile/", "", 1);

	#folders_tree($dir, $match, $relative, $depth)
	@folders = $self->file->folders_tree("c:/apache/htdocs/nile/", "", 1);

=head1 XML

Loads xml files into hash tree using L<XML::TreePP>
	
	$xml = $self->me->xml->load("configs.xml");

=head1 DATABASE

The database class provides methods for connecting to the sql database and easy methods for sql operations.

=cut

BEGIN {
	$|=1;
	use CGI::Carp qw(fatalsToBrowser set_message);
	use Devel::StackTrace;
	use Devel::StackTrace::AsHTML;
	use PadWalker;
	use Devel::StackTrace::WithLexicals;
	sub handle_errors {
		#print "Content-type: text/html;charset=utf-8\n\n";
		my $msg = shift;
		#my $trace = Devel::StackTrace->new;
		my $trace = Devel::StackTrace::WithLexicals->new(indent => 1, message => $msg);
		print $trace->as_html;
	}
	set_message(\&handle_errors);
}

use Moose;
use MooseX::MethodAttributes;
use namespace::autoclean;
#use MooseX::ClassAttribute;

use utf8;
use File::Spec;
use File::Basename;
use Cwd;
use URI;
use Encode ();
use URI::Escape;
use Crypt::RC4;
#use Crypt::CBC;
use Capture::Tiny ();
use Time::Local;
use File::Slurp;
use Time::HiRes qw(gettimeofday tv_interval);
use MIME::Base64 3.11 qw(encode_base64 decode_base64 decode_base64url encode_base64url) ; #3.11

use Data::Dumper;
$Data::Dumper::Deparse = 1; #stringify coderefs
#use LWP::UserAgent;
#use Log::Tiny;
#use CGI::Simple;
use HTTP::AcceptLanguage;

#no warnings qw(void once uninitialized numeric);

#use Nile::Autouse;

#use  later 'Nile::View'; #load module at runtime, overrides AUTOLOAD in the module.
use Nile::Abort;
use Nile::Say;
use Nile::View;
use Nile::XML;
use Nile::Var;
use Nile::File;
use Nile::Lang;
use Nile::Config;
use Nile::Router;
use Nile::Dispatcher;
use Nile::Paginate;
use Nile::Database;
use Nile::Setting;
use Nile::HTTP::Request;
use Nile::HTTP::Response;

#use base 'Import::Base';
use Import::Into;
use Module::Load;
use Module::Runtime qw(use_module);
our @EXPORT_MODULES = (
		#strict => [],
		#warnings => [],
		Moose => [],
		utf8 => [],
		#'File::Spec' => [],
		#'File::Basename' => [],
		Cwd => [],
		'Nile::Say' => [],
		'MooseX::MethodAttributes' => [],
	);

use base 'Exporter';
our @EXPORT = qw();
our @EXPORT_OK = qw();

our $nile;
our %vars;
#=========================================================#
sub import {
	my ($class, @args) = @_;
	my ($package, $script) = caller;
	
	# import list of modules to the calling package
	my @modules = @EXPORT_MODULES;
    while (@modules) {
        my $module = shift @modules;
        my $imports = ref $modules[0] eq 'ARRAY' ? shift @modules : [];
        use_module($module)->import::into($package, @{$imports});
    }
	#------------------------------------------------------
	$class->detect_script_path($script);
	#------------------------------------------------------
	my $caller = $class.'::';
	{
		no strict 'refs';
		@{$caller.'EXPORT'} = @EXPORT;
		foreach my $sub (@EXPORT) {
			next if (*{"$caller$sub"}{CODE});
			*{"$caller$sub"} = \*{$sub};
		}
	}

	$class->export_to_level(1, $class, @args);
	#------------------------------------------------------
  }
#=========================================================#
sub detect_script_path {

	my ($self, $script) = @_;
	$script ||= (caller)[1];

	my ($vol, $dirs, $name) =	File::Spec->splitpath(File::Spec->rel2abs($script));

    if (-d (my $fulldir = File::Spec->catdir($dirs, $name))) {
        $dirs = $fulldir;
        $name = "";
    }

	my $path = $vol? File::Spec->catpath($vol, $dirs) : File::Spec->catdir($dirs);
	
	#print "\n vol=$vol\n dirs=$dirs\n name=$name\n path=$path \n";
	$ENV{NILE_APP_DIR} = $path;
	return ($path);
}
#=========================================================#
sub error {
	my $self = shift;
	goto &CGI::Carp::croak;
}
sub errors {
	my $self = shift;
	goto &CGI::Carp::confess;
}
sub warn {
	my $self = shift;
	goto &CGI::Carp::carp;
}
sub warns {
	my $self = shift;
	goto &CGI::Carp::cluck;
}
#=========================================================#
sub BUILD { # our sub new {..}
	my ($self, $args) = @_;

	#$self->error(" ...  error   ...  ");
	#$self->warn(" ...  warn   ...  ");
}
#=========================================================#
sub init {

	my ($self, %arg) = @_;
	
	my ($package, $script) = caller;
	
	$arg{path} ||= $self->detect_script_path($script);

	$self->var->set(
			# app directories
			'path'					=>	$arg{path},
			
			'lib_dir'				=>	$self->file->catdir($arg{path}, "lib"),
			'log_dir'				=>	$self->file->catdir($arg{path}, "log"),
			'config_dir'			=>	$self->file->catdir($arg{path}, "config"),
			'route_dir'			=>	$self->file->catdir($arg{path}, "route"),
			
			'log_file'				=>	$arg{log_file} || "log.pm",
			'action_name'		=>	$arg{action_name} || "action,route,cmd",
			'default_route'	=>	$arg{default_route} || "/Home/Home/index",
		);
	
	push @INC, $self->var->get("lib_dir");
	#------------------------------------------------------
	# detect and load request and response handler classes
	$arg{mode} ||= "cgi";
	$arg{mode} = lc($arg{mode});
	$self->mode($arg{mode});
	
	#$self->log->debug("mode: $arg{mode}");

	# force PSGI if PLACK_ENV is set
	if ($ENV{'PLACK_ENV'}) {
		$self->mode("psgi");
	}
	#$self->log->debug("mode after PLACK_ENV: $arg{mode}");
	
	# FCGI sets $ENV{GATEWAY_INTERFACE }=> 'CGI/1.1' inside the accept request loop but nothing is set before the accept loop
	# command line invocations will not set this variable also
	if ($self->mode ne "psgi") {
		if (exists $ENV{GATEWAY_INTERFACE} ) {
			# CGI
			$self->mode("cgi");
		}
		else {
			# FCGI or command line
			$self->mode("fcgi");
		}
	}
	
	#$self->log->debug("mode to run: $arg{mode}");

	if ($self->mode eq "psgi") {
		load Nile::HTTP::RequestPSGI;
		load Nile::Handler::PSGI;
	}
	elsif ($self->mode eq "fcgi") {
		load Nile::HTTP::Request;
		load Nile::Handler::CGI;
		load Nile::Handler::FCGI;
	}
	else {
		load Nile::HTTP::Request;
		load Nile::Handler::CGI;
	}
	#------------------------------------------------------
	# load config files
	foreach (@{$arg{config}}) {
		#$self->config->xml->keep_order(1);
		$self->config->load($_);
	}

	# load route files
	foreach (@{$arg{route}}) {
		$self->router->load($_);
	}

}
#=========================================================#
sub start {

	my ($self, %arg) = @_;

	$arg{lang} ||= "";
	$arg{theme} ||= "default";
	
	my $path = $self->var->get("path");

	$self->var->set(
			'langs_dir'			=>	$self->file->catdir($path, "lang"),
			'lang_dir'				=>	$self->file->catdir($path, "lang", $arg{lang}),
			'themes_dir'		=>	$self->file->catdir($path, "theme"),
			'theme_dir'			=>	$self->file->catdir($path, "theme", $arg{theme}),
			
			# app default settings
			'lang'					=>	$arg{lang},
			'theme'					=>	$arg{theme},
		);
	
	if (!$arg{lang}) {
		$arg{lang} = $self->detect_user_language;
		$self->var->set("lang", $arg{lang});	
		$self->var->set("lang_dir", $self->file->catdir($arg{path}, "lang", $arg{lang}));
	}

	# load language files
	#$self->lang->load("general");
	
	# load language files
	foreach (@{$arg{langs}}) {
		$self->lang->load($_);
	}

}
#=========================================================#
sub run {

	my ($self, %arg) = @_;
	
	#$self->log->info("application run start in mode: ".$self->mode);
	
	if ($self->mode eq "psgi") {
		# PSGI handler
		#$self->log->debug("PSGI handler start");
		my $psgi = $self->object("Nile::Handler::PSGI")->start();
		return $psgi;
	}
	elsif ($self->mode eq "fcgi") {
		# FCGI handler
		#$self->log->debug("FCGI handler start");
		$self->object("Nile::Handler::FCGI")->start();
		#$self->log->debug("FCGI handler end");
	}
	else {
		# CGI handler
		#$self->log->debug("CGI handler start");
		$self->object("Nile::Handler::CGI")->start();
		#$self->log->debug("CGI handler end");
	}

	#$self->log->log("application run end");
}
#=========================================================#
sub content_type_text {
	my ($self, $content_type) = @_;
	return $content_type =~ /(\bx(?:ht)?ml\b|text|json|javascript)/;
}
#=========================================================#
sub action {
	my $self = shift;
	my ($method, $route, $action) = $self->action_args(@_);
	$self->router->add_route(
							name  => "",
							path  => $route,
							target  => $action,
							method  => $method,
							defaults  => {
									#id => 1
								},
							attributes => undef,
						);
}
#=========================================================#
sub capture {
	my $self = shift;
	my ($method, $route, $action) = $self->action_args(@_);
	$self->router->add_route(
							name  => "",
							path  => $route,
							target  => $action,
							method  => $method,
							defaults  => {
									#id => 1
								},
							attributes => "capture",
						);

}
#=========================================================#
sub action_args {
	
	my $self = shift;

	#my @methods = qw(get post put patch delete options head);

	my ($method, $route, $action);

	if (@_ == 1) {
		#$app->action(sub {});
		($action) = @_;
	}
	elsif (@_ == 2) {
		#$app->action("/home", sub {});
		($route, $action) = @_;
	}
	elsif (@_ == 3) {
		#$app->action("get", "/home", sub {});
		($method, $route, $action) = @_;
	}
	else {
		$self->abort("Action error. Empty action and route. Syntax \$app->action(\$method, \$route, \$coderef) ");
	}

	$method ||= "";
	$route ||= "/";
	
	if (ref($action) ne "CODE") {
		$self->abort("Action error, must be a valid code reference. Syntax \$app->action(\$method, \$route, \$coderef) ");
	}
	
	return ($method, $route, $action);
}
#=========================================================#
sub is_cli {
	# return 1 if called from browser, 0 if called from command line
	if  (exists $ENV{REQUEST_METHOD} || defined $ENV{GATEWAY_INTERFACE} ||  exists $ENV{HTTP_HOST}){
		return 0;
	}
	return 1;
	#if (-t STDIN) { }
	#use IO::Interactive qw(is_interactive interactive busy);if ( is_interactive() ) {print "Running interactively\n";}
}
#=========================================================#
sub utf8_safe {
	my ($self, $str) = @_;
	if (utf8::is_utf8($str)) {
		utf8::encode($str);
	}
	$str;
}
#=========================================================#
sub encode {
	my ($self, $data) = @_;
	return Encode::encode($self->charset, $data);
}
#=========================================================#
sub decode {
	my ($self, $data) = @_;
	return Encode::decode($self->charset, $data);
}
#=========================================================#
=head2 bm()
	
	$app->bm->lap("start task");
	....
	$app->bm->lap("end task");
	
	say $app->bm->stop->summary;

	# NAME			TIME		CUMULATIVE		PERCENTAGE
	# start task		0.123		0.123			34.462%
	# end task		0.234		0.357			65.530%
	# _stop_		0.000		0.357			0.008%
	
	say "Total time: " . $app->bm->total_time;

Benchmark specific parts of your code. This is a L<Benchmark::Stopwatch> object.

=cut

has 'debug' => (
      is      => 'rw',
      isa     => 'Bool',
      default => 0,
  );

has 'bm' => (
      is      => 'rw',
      isa    => 'Benchmark::Stopwatch',
	  lazy	=> 1,
	  default => sub{
		  #autoload, load CGI, ':all';
		  load Benchmark::Stopwatch;
		  Benchmark::Stopwatch->new->start;
	  }
  );

has 'mode' => (
      is      => 'rw',
      isa     => 'Str',
      default => "cgi",
  );

=head2 ua()
	
	my $response = $app->ua->get('http://example.com/');
	say $response->{content} if length $response->{content};
	
	$response = $app->ua->get($url, \%options);
	$response = $app->ua->head($url);
	
	$response = $app->ua->post_form($url, $form_data);
	$response = $app->ua->post_form($url, $form_data, \%options);

Simple HTTP client. This is a L<HTTP::Tiny> object.

=cut

has 'ua' => (
      is      => 'rw',
      isa    => 'HTTP::Tiny',
	  lazy	=> 1,
	  #trigger => sub {shift->clearer},
	  default => sub {
		  load HTTP::Tiny;
		  HTTP::Tiny->new;
	  }
  );

has 'uri' => (
      is      => 'rw',
      isa    => 'URI',
	  lazy	=> 1,
	  default => sub {
		  load URI;
		  URI->new;
	  }
  );

has 'charset' => (
      is      => 'rw',
	  lazy	=> 1,
      default => 'utf8'
  );

has 'freeze' => (
      is      => 'rw',
      isa    => 'Nile::Serializer',
	  lazy	=> 1,
	  default => sub {
		  load Nile::Serializer;
		  Nile::Serializer->new;
	  }
  );
sub serialize {shift->freeze(@_);}

has 'thaw' => (
      is      => 'rw',
      isa    => 'Nile::Deserializer',
	  lazy	=> 1,
	  default => sub {
		  load Nile::Deserializer;
		  Nile::Deserializer->new;
	  }
  );
sub deserialize {shift->thaw(@_);}

has 'file' => (
      is      => 'rw',
	  isa    => 'Nile::File',
	  default => sub {
			my $self = shift;
			$self->object("Nile::File", @_);
		}
  );

has 'xml' => (
      is      => 'rw',
	  lazy	=> 1,
	  default => sub {
			my $self = shift;
			$self->object("Nile::XML", @_);
		}
  );

has 'config' => (
      is      => 'rw',
	  isa    => 'Nile::Config',
	  lazy	=> 1,
	  default => sub {
			my $self = shift;
			$self->object("Nile::Config", @_);
		}
  );

has 'var' => (
      is      => 'rw',
	  isa    => 'Nile::Var',
	  lazy	=> 1,
	  default => sub {
			my $self = shift;
			$self->object ("Nile::Var", @_);
		}
  );

has 'setting' => (
      is      => 'rw',
	  isa    => 'Nile::Setting',
	  lazy	=> 1,
	  default => sub {
			my $self = shift;
			$self->object("Nile::Setting", @_);
		}
  );

has 'env' => (
	is => 'rw',
	isa => 'HashRef',
	default => sub { +{} }
);


has 'request' => (
	is      => 'rw',
	lazy	=> 1,
	default => sub {undef},
);

has 'response' => (
      is      => 'rw',
      isa    => 'Nile::HTTP::Response',
	  lazy	=> 1,
	  default => sub {
			shift->object("Nile::HTTP::Response", @_);
		}
  );

has 'mime' => (
      is      => 'rw',
      isa    => 'Nile::MIME',
	  lazy	=> 1,
	  default => sub {
			load Nile::MIME;
			shift->object("Nile::MIME", only_complete => 1);
		}
  );

has 'lang' => (
      is      => 'rw',
	  isa    => 'Nile::Lang',
	  lazy	=> 1,
	  default => sub {
			shift->object("Nile::Lang", @_);
		}
  );

has 'router' => (
      is      => 'rw',
	  isa    => 'Nile::Router',
	  lazy	=> 1,
	  default => sub {
			shift->object("Nile::Router", @_);
		}
  );

has 'dispatcher' => (
      is      => 'rw',
	  isa    => 'Nile::Dispatcher',
	  lazy	=> 1,
	  default => sub {
			shift->object("Nile::Dispatcher", @_);
		}
  );

#=========================================================#
has 'logger' => (
      is      => 'rw',
	  lazy	=> 1,
	  default => sub {
			my $self = shift;
			load Log::Tiny;
			Log::Tiny->new($self->file->catfile($self->var->get("log_dir"), $self->var->get("log_file") || 'log.pm'));
		}
  );
sub log {
	my $self = shift;
	$self->start_logger if (!$self->logger);
	$self->logger(@_);
}
sub start_logger {
	my $self = shift;
	$self->stop_logger;
	$self->logger(Log::Tiny->new($self->file->catfile($self->var->get("log_dir"), $self->var->get("log_file") || 'log.pm')));
}
sub stop_logger {
	my $self = shift;
	# close log file
	$self->logger(undef);
}
#=========================================================#
has 'dbh' => (
      is      => 'rw',
  );

has 'db' => (
      is      => 'rw',
	  isa    => 'Nile::Database',
	  lazy	=> 1,
	  default => sub {
				my $self = shift;
				my $db = $self->object("Nile::Database");
				#my $dbh = $db->connect(@_);
				#$self->dbh($dbh);
				return $db;
		}
  );

sub connect {
	my $self = shift;
	$self->dbh($self->db->connect(@_));
	$self->db;
}
#=========================================================#
sub new_request {
	
	my ($self, $env) = @_;

	if (defined($env) && ref ($env) eq "HASH") {
		$self->mode("psgi");
		#load Nile::HTTP::PSGI;
		$self->request($self->object("Nile::HTTP::RequestPSGI", $env));
	}
	else {
		$self->request($self->object("Nile::HTTP::Request"));
	}
	
	$self->request;
}
#=========================================================#
sub paginate {
	my ($self) = shift;
	return $self->object("Nile::Paginate", @_);
}
#=========================================================#
sub view {
	my ($self) = shift;
	return $self->object("Nile::View", @_);
}
#=========================================================#
sub database {
	my ($self) = shift;
	return $self->object("Nile::Database", @_);
}
#=========================================================#
sub object {

	my ($self, $class, @args) = @_;
	my (%args, $obj);
	
	if (@args == 1 && ref($args[0]) eq "HASH") {
		# Moose single arguments must be hash ref
		$obj = $class->new(@args);
	}
	elsif (@args && @args % 2) {
		# Moose needs args as hash, so convert odd size arrays to even for hashing
		push @args, undef;
		%args = @args;
		pop @args;
		$obj = $class->new(%args);
	}
	else {
		%args = @args;
		$obj = $class->new(%args);
	}

	my $meta = $obj->meta;

	#$meta->add_method( 'hello' => sub { return "Hello inside hello method. @_" } );
	#$meta->add_class_attribute( $_, %options ) for @{$attrs}; #MooseX::ClassAttribute
	#$meta->add_class_attribute( 'cash', ());

	# add method "me" to module, if module has method "me" then add "nile" instead.
	if (!$obj->can("me")) {
		$meta->add_attribute('me' => (is => 'rw', default => sub{$self}));
		$obj->me($self);
	}
	else {
		$meta->add_attribute('nile' => ( is => 'rw', default => sub{$self}));
		$obj->nile($self);
	}
	
	# if class has defined "main" method, then call it
	if ($obj->can("main")) {
		$obj->main(@args);
	}
		
	#no strict 'refs';
	#*{"$obj"."::me"} = \&me;
	#${"${package}::$var_name"} = 1;
	
	return $obj;
}
#=========================================================#
sub theme_list {
	my ($self) = @_;
	my @folders = ($self->file->folders($self->var->get("themes_dir"), "", 1));
	return grep (/^[^_]/, @folders);
}
#=========================================================#
sub lang_list {
	my ($self) = @_;
	my @folders = ($self->file->folders($self->var->get("langs_dir"), "", 1));
	return grep (/^[^_]/, @folders);
}
#=========================================================#
sub detect_user_language {
	my ($self) = @_;
	#my $lang = $self->request->param("lang") || $self->request->cookie("userlang") || $self->reg->get("lang");
	my $lang = $self->request->param("lang");#

	# detect user browser language settings
	my (@langs);
	if (!$lang) {
		@langs = $self->lang_list();
		$lang = HTTP::AcceptLanguage->new($ENV{HTTP_ACCEPT_LANGUAGE})->match(@langs);
	}

	$lang ||= $langs[0] ||= "en-US";
	return $lang;
}
#=========================================================#
sub dump {
	my $self = shift;
	say Dumper (@_);
	return "";
}
#=========================================================#
sub trim {
	my ($self) = shift;
	my (@out) = @_;
	for (@out) {
		s/^\s+//;
		s/\s+$//;
	}
	return (scalar @out >1)? @out : $out[0];
}
#=========================================================#
sub ltrim {
	my ($self) = shift;
	my (@out) = @_;
	for (@out) {
		s/^\s+//;
	}
	return (scalar @out >1)? @out : $out[0];
}
#=========================================================#
sub rtrim {
	my ($self) = shift;
	my (@out) = @_;
	for (@out) {
		s/\s+$//;
	}
	return (scalar @out >1)? @out : $out[0];
}
#=========================================================#
sub trims {
	my ($self) = shift;
	my $str =  $_[0];
	$str =~ s/\s+//g;
	return $str;
}
#=========================================================#
sub max {
	my ($self, $max, @vars) = @_;
	for (@vars) {
		$max = $_ if $_ > $max;
	}
	return $max;
}
#=========================================================#
sub min {
	my ($self, $min, @vars) = @_;
	for (@vars) {
		$min = $_ if $_ < $min;
	}
	return $min;
}
#=========================================================#
sub digit {
	my ($self) = shift;
	my $str =  $_[0];
	$str =~ s/\D+//g;
	$str += 0;
	return $str;
}
#=========================================================#
sub number {
	my ($self) = shift;
	my $str =  $_[0];
	#if ($str =~ /(\+|-)?([0-9]+(\.[0-9]+)?)/) {
	if ($str =~ /(-)?([0-9]+(\.[0-9]+)?)/) {
		return "$1$2";
	}
	return "";
}
#=========================================================#
sub commify {
	my ($self) = shift;
	my $str =  reverse $_[0];
	$str =~ s/(\d\d\d)(?=\d)(?!\d*\.)/$1,/g;
	return scalar reverse $str;
}
#=========================================================#
sub capture_output {
my ($self, $code) = @_;
	
	my ($merged, @result) = Capture::Tiny::capture_merged {eval $code};
	#$merged .= join "", @result;
	if ($@) {
		$merged  = "Embeded Perl code error: $@\n$code\n$merged\n";
	}
	return $merged;
}
#=========================================================#
sub abort {
	my ($self) = shift;
	Nile::Abort->abort(@_);
}
#=========================================================#
#__PACKAGE__->meta->make_immutable;#(inline_constructor => 0)
#=========================================================#


=head1 Sub Modules

Views	L<Nile::View>.

Shared Vars	L<Nile::Var>.

Langauge	L<Nile::Lang>.

Request	L<Nile::HTTP::Request>.

Request	L<Nile::HTTP::RequestPSGI>.

Request	L<Nile::HTTP::PSGI>.

Response	L<Nile::HTTP::Response>.

Dispatcher L<Nile::Dispatcher>.

Router L<Nile::Router>.

File Utils L<Nile::File>.

Paginatation L<Nile::Paginate>.

Database L<Nile::Database>.

XML L<Nile::XML>.

Settings	L<Nile::Setting>.

Serializer L<Nile::Serializer>.

Deserializer L<Nile::Deserializer>.

Serialization L<Nile::Serialization>.

MIME L<Nile::MIME>.

Abort L<Nile::Abort>.

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

Copyright (C) 2014-2015 by Dr. Ahmed Amin Elsheshtawy mewsoft@cpan.org, support@mewsoft.com,
L<https://github.com/mewsoft/Nile>, L<http://www.mewsoft.com>

This library is free software; you can redistribute it and/or modify it under the same terms as Perl itself.

=cut


1;