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
					#path		=>	dirname(File::Spec->rel2abs(__FILE__)),
				);
	
	$app->run();

	exit;
	
	#my $config = $app->config;
	#$config->xml->keep_order(1);
	#$config->load($app->file->catfile($app->var->get("config_dir"), "config.xml"));

	#$app->dbh($app->db->connect());
	#$app->connect();

	#my $var = $app->var;
	#$var->Body("Body variable");
	#say "var: ". $var->set("Title", "Hello world Title")->get("Title");
	
	#my $request = $app->request;
	#say "request script_name: ". $request->script_name;
	#say "request fullname: ". $request->param("fullname");

	#say "block: " . $app->dump($view->block("first/second/third")->{match});
	#say Dumper $view->block->{first}->{second}->{third}->{fourth}->{fifth};
	#say Dumper $view->block->{six}->{seven}->{eight}->{content};
	
	#my @langs = $app->lang_list;
	#say "langs list: @langs";
	#my @themes = $app->theme_list;
	#say "themes list: @themes";

	#my @text = $app->file->get("config.xml", binmode=>":utf8", chomp=>0);
	
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
