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
	#print "Content-type: text/html;charset=utf-8\n\n";

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
					#path		=>	dirname(File::Spec->rel2abs(__FILE__)),
				);
	
	$app->run();
	
	exit;
	
	# to generate directory tree C:\apache\htdocs\nile>tree

	#my $view = $app->view("home", "default");
	#my $view = $app->view("home");
	#$view->set("name", "Ahmed");
	#$view->FirstName("Ahmed amin");
	#print  "Get First name: [". $view->FirstName ."]\n";

	#my $config = $app->config;
	#$config->xml->keep_order(1);
	#$config->load($app->file->catfile($app->var->get("config_dir"), "config.xml"));

	#$app->dbh($app->db->connect());
	#$app->connect();

	#$config->set("LastName", "Elsheshtawy");
	#$config->clear;
	#say "config get LastName: ". $config->val("LastName"),"\n";
	#$config->delete( qw( database admin LastName) );
	#$config->var->{"MiddleName"}->{"Grandpa"}  = "Gouda";
	#say "config get MiddleName: ". $config->var->{"MiddleName"}->{"Grandpa"},"\n";
	#say "config get database: ". $config->get("database"),"\n";
	#say "config get database user: ". $config->var->{"database"}->{user},"\n";
	#say Dumper($config->var);
	#say Dumper($config->get("LastName"));
	#say "database/setting/encoding: " . ($config->get("database/setting/encoding", "def"));
	#my ($user, $pass, $name) = $config->list("database/name", "database/user", "database/password");
	#say "($user, $pass, $name)";
	#say Dumper($config->get("database")->{user});
	#$config->save("config.xml");
	#say "FName: ".$config->FName;
	#$config->LName("Gouda");
	#say "LName: ".$config->LName;
	
	#my $var = $app->var;
	#$var->Body("Body variable");
	#say "var: ". $var->set("Title", "Hello world Title")->get("Title");
	#say Dumper ($var->vars);
	#say $var->keys;
	
	#my $request = $app->request;
	#say "request script_name: ". $request->script_name;
	#say "request fullname: ". $request->param("fullname");
	#say $app->msg;

	#print join "\n", (keys %Mew::);

	#say "script_name: " .$app->{script_name};
	#my $lang = $app->lang;
	#$lang->lang("en-US");
	#$lang->load("general");
	#$lang->load("register");
	#say "lang home: ". $lang->home;
	
	#say "config cdata: ". $config->get("perl");
	#say Dumper $config->var->{perl};
	
	#say Dumper $view->{block}->{first}->{second}->{third}->{content};
	#say Dumper $view->{block}->{first}->{second}->{third}->{match};
	#say Dumper $view->{block}->{first}->{second}->{third}->{fourth};
	#say Dumper $view->{block}->{first}->{second}->{third}->{fourth}->{fifth};
	#say Dumper $view->{block}->{six}->{seven}->{eight};
	
	#my $router = $app->router;
	#$router->load("route.xml");

	#my ($action, $args, $query) = $route->match("blog/post/123/456", "post");
	#say "route match: $action, $query " . $app->dump($args);
	#my $route = $router->match("blog/post/123/456", "post");
	#my $route = $router->match("blog/posts", "post");
	#say "route match: ". $route->{action}, ", " . $route->{query} . ", " . $app->dump($route->{args});
	#$route = $router->route_for('blog/post/123/456');
	#say "route for uri: " . $app->dump($route);

	#my $dispatcher = $app->dispatcher;
	#$dispatcher->dispatch;
	
	#my @langs = $app->lang_list;
	#say "langs list: @langs";
	#my @themes = $app->theme_list;
	#say "themes list: @themes";

	#my $log = $app->log;
	#$log->log("this is the first message in my new log");
	#$log->DEBUG("this is the first message in my new log");
	
	#test_paginate();

	#my @text = $app->file->get("config.xml", binmode=>":utf8", chomp=>0);
	#say @text;
	#say "File: ". $app->file->catdir("C:", "apache", "htdocs");
	#say "Files: ". join ", ",$app->file->files('C:/apache/htdocs/Nile/Lib/Nile', "*.pm", 1); #$dir, $match, $relative
	#say "Files: ". join "\n ",$app->file->files_tree('C:/apache/htdocs/Nile/', "*", 0); #$dir, $match, $relative, $depth
	#say "Folders: \n". join "\n ",$app->file->folders('C:/apache/htdocs/Nile/', "", 1); # $dir, $match, $relative
	#say "Folders: \n". join "\n ",$app->file->folders_tree('C:/apache/htdocs/Nile/', "", 1); # $dir, $match, $relative, $depth

	#say "DS: ". $app->file->ds;
	
	#my($name, $dir, $ext, $nameext) = $app->file->path_info('C:/apache/htdocs/Nile/Nile.pm.tar.gz');
	#say "path_info: ($name, $dir, $ext, $nameext)" ;
	#my($name, $dir, $ext, $nameext) = $app->file->fileparse('C:/apache/htdocs/Nile/Nile.pm.tar.gz');
	#say "fileparse: ($name, $dir, $ext, $nameext)" ;
	#say "basename: " . $app->file->basename('C:/apache/htdocs/Nile/Nile.pm');
	#say "dirname: " . $app->file->dirname('C:/apache/htdocs/Nile/Nile.pm');
	
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
}
#=========================================================#
