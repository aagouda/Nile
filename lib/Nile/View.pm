#	Copyright Infomation
#=========================================================#
#	Module	:	Nile::View
#	Author		:	Dr. Ahmed Amin Elsheshtawy, Ph.D.
#	Website	:	https://github.com/mewsoft/Nile, http://www.mewsoft.com
#	Email		:	mewsoft@cpan.org, support@mewsoft.com
#	Copyrights (c) 2014-2015 Mewsoft Corp. All rights reserved.
#=========================================================#
package Nile::View;

our $VERSION = '0.13';

=pod

=encoding utf8

=head1 NAME

Nile::View - The template processing system.

=head1 SYNOPSIS
		
		# get view home.html in current theme
		my $view = $self->me->view("home");
		# get view home.html in specific arabic
		my $view = $app->view("home", "arabic");
		
		# set view variables
		$view->var(
				fname			=>	'Ahmed',
				lname			=>	'Elsheshtawy',
				email			=>	'sales@mewsoft.com',
				website		=>	'http://www.mewsoft.com',
				singleline		=>	'Single line variable <b>Good</b>',
				multiline		=>	'Multi line variable <b>Nice</b>',
			);
		
		# set variable
		$view->set('email', 'sales@mewsoft.com');

		# get variable
		$email = $view->get('email');

		# automatic getter/setter for variables
		$view->email('sales@mewsoft.com');
		$view->website('http://www.mewsoft.com');
		$email = $view->email;
		$website = $view->website;

		# replace marked blocks or iterators
		$view->block("first", "1st Block New Content ");
		$view->block("six", "6th Block New Content ");
		
		# process variables and blocks and text language variables
		$view->process;

		# send the output to the browser
		$view->render;

=head1 DESCRIPTION

Nile::View - The template processing system.

=cut

use Nile::Base;
use Capture::Tiny ();
use Time::HiRes qw(gettimeofday);
use IO::Compress::Gzip qw(gzip $GzipError);
#=========================================================#
sub AUTOLOAD {
	my ($self) = shift or return undef; # ignore functions call like Nile::View::xxx();
	my ($class, $method) = our $AUTOLOAD =~ /^(.*)::(\w+)$/;
	
    if ($self->can($method)) {
		return $self->$method(@_);
    }

	if (@_) {
		$self->{var}->{$method} = $_[0];
	}
	else {
		return $self->{var}->{$method};
	}
}
#=========================================================#
sub main { # called automatically after the constructor new
	my ($self, $view, $theme) = @_;	
	$self->{theme} = $theme if ($theme);
	$self->view($view) if ($view);
}
#=========================================================#
=head2 view()

	my $view =  $self->me->view([$view, $theme]);

Creates new view object or returns the current view name. The first option is the view name with or without file extension $view, the default 
view extension is B<html>. The second optional argument is the theme name, if not supplied the current default theme will be used.

=cut

sub view {
	my ($self, $view, $theme) = @_;	

	if ($view) {
		$view .= ".html" unless ($view =~ /\.html$/i);
		$theme ||= $self->{theme} ||= $self->me->var->get("theme");
		my $file = $self->me->file->catfile($self->me->var->get("themes_dir"), $theme, "view", $view);
		$self->{content} = $self->me->file->get($file);
		$self->{file} = $file;
		$self->{view} = $view;
		$self->{lang} ||= $self->me->var->get("lang");
		$self->{theme} = $theme;
		$self->parse;
		return $self;
	}

	$self->{view};
}
#=========================================================#
=head2 lang()
	
	$view->lang('en-US');
	my $lang = $view->lang();

Sets or returns the language for processing the template text. Language must be already installed in the lang folder.

=cut

sub lang {
	my ($self, $lang) = @_;
	if ($lang) {
		$self->{lang} = $lang;
		return $self;
	}
	$self->{lang};
}
#=========================================================#
=head2 theme()
	
	$view->theme('arabic');
	my $theme = $view->theme();

Sets or returns the theme for loading template file. Theme must be already installed in the theme folder.

=cut

sub theme {
	my ($self, $theme) = @_;
	if ($theme) {
		$self->{theme} = $theme;
		return $self;
	}
	$self->{theme};
}
#=========================================================#
=head2 var() and set()
	
	$view->var(email=>'nile@cpan.org');
	$view->var(%vars);

	$view->var(
			fname			=>	'Ahmed',
			lname			=>	'Elsheshtawy',
			email			=>	'sales@domain.com',
			website		=>	'http://www.mewsoft.com',
			htmlnode		=>	'html code variable <b>Nile</b>',
		);

Sets one of more template variables. This method can be chained.

=cut

sub var {
	my ($self, %vars) = @_;
	map {$self->{vars}->{$_} = $vars{$_}} keys %vars;
	$self;
}
#=========================================================#
=head2 set()

	$view->set(email=>'nile@cpan.org');
	$view->set(%vars);

Same as method var() above.

=cut

sub set {
	my ($self, %vars) = @_;
	map {$self->{vars}->{$_} = $vars{$_}} keys %vars;
	$self;
}
#=========================================================#
=head2 get()

	$email = $view->get("email");
	@user = $view->get(qw(fname lname email website));

Returns one or more template variables values.

=cut

sub get {
my ($self, @name) = @_;
	#@{ $h{'a'} }{ @keys }
	@{ $self->{vars} }{@name};
}
#=========================================================#
=head2 content()
	
	# get current template content
	$content = $view->content;

	# set current template content direct
	$view->content($content);

Get or set current template content.

=cut

sub content {
my ($self) = shift;
	if (@_) {
		$self->{content} = $_[0];
		return $self;
	}
	$self->{content};
}
#=========================================================#
sub parse_vars {
	
	my ($self) = @_;
	
	my ($match, $attrs, $content, $cdata, $cdata_content, $closing, %attr, $type, $k, $v);
	my $tag = "vars";
	
	$self->{tag} = {};
	my $counter = 0;

	#(<$tag(\s+[^\!\?\s<>](?:"[^"]*"|'[^']*'|[^"'<>])*)/>([^<]*)(<\!\[CDATA\[(.*?)\]\]>)?(</$tag>)?)
    while ( $self->{content} =~ m{
		(<$tag(\s+[^\!\?\s<>](?:"[^"]*"|'[^']*'|[^"'<>])*)/>)|(<$tag(\s+[^\!\?\s<>](?:"[^"]*"|'[^']*'|[^"'<>\/])*)>(.*?)<\/$tag>)
    }sxgi ) {
		
		if ($1) {
			($match, $attrs, $content) = ($1, $2, undef);
		}
		else {
			($match, $attrs, $content) = ( $3, $4, $5);
			if ($content =~ /<\!\[CDATA\[(.*?)\]\]>/is) {
				$content = $1;
			}
		}
		#print "match:\n$match \nattrs: $attrs\nvalue: $value\n";
	
		# parse attributes to key and value pairs
		%attr = ();
		 
		#while ( $attrs =~ /\G(?:\s+([^=]+)=(?:"([^"]*)"|'([^']*)'|(\S+))|(.+))/sg ) {
		 while ( $attrs =~ m{([^\s\=\"\']+)\s*=\s*(?:(")(.*?)"|'(.*?)')}sxg ) {
			$attr{$1} = ( $2 ? $3 : $4 );
		}

		if ($attr{name}) {
			$type = (exists $attr{type} and $attr{type} ne "")? $attr{type} : "var";
			$self->{tag}->{$type}->{$attr{name}} = {attr=>{%attr}, match=>$match, content=>$content};
		}
		elsif (exists $attr{type} and $attr{type} ne "") {
			# handle <vars type="perl">print "Hello world";</vars>
			#print "\nno name: $attr{type}\n";
			$counter++;
			$attr{name} = $tag."_".$counter;
			$type = $attr{type};
			$self->{tag}->{$type}->{$attr{name}} = {attr=>{%attr}, match=>$match, content=>$content};
		}

		#print "\n";
	}
	
	#$self->me->dump($self->{tag});

	$self;
}
#=========================================================#
sub parse_blocks {
	my ($self) = @_;
	$self->{block} = {};
	$self->parse_nest_blocks($self->{block}, $self->{content});
	return $self; 
}
#=========================================================#
sub parse_nest_blocks {

	my ($self, $aref, $core) = @_;

	my ($k, $v);
	
    #while ($core =~ /(<!--block:(.*?)-->((?:(?:(?!<!--block:(?:.*?)-->).)|(?R))*?)<!--endblock-->|((?:(?!<!--.*?-->).)+))/igsx )
	#while ( $core =~ /(?is)(<!--block:(.*?)-->((?:(?:(?!<!--block:(?:.*?)-->).)|(?R))*?)<!--endblock-->|((?:(?!<!--block:.*?-->).)+))/g )
	while ( $core =~ /(?is)(?:((?&content))|(?><!--block:(.*?)-->)((?&core)|)<!--endblock-->|(<!--(?:block:.*?|endblock)-->))(?(DEFINE)(?<core>(?>(?&content)|(?><!--block:.*?-->)(?:(?&core)|)<!--endblock-->)+)(?<content>(?>(?!<!--(?:block:.*?|endblock)-->).)+))/g )
    {
        if (defined $2) {
			# CORE
		   $k = $2; $v = $3;
		   $aref->{$k} = {};
		   $aref->{$k}->{content} = $v;
		   $aref->{$k}->{match} = $&;
		  # print "1:{{$1}}\n2:[[$2]]\n";
		   my $curraref = $aref->{$k};
           my $ret = $self->parse_nest_blocks($aref->{$k}, $v);
		   if (defined $ret) {
			   $curraref->{'#next'} = $ret;
		   }
        }
		elsif (defined $1) {
			# CONTENT
			#$aref->{$k}->{content} .= $1;
			#say "CONTENT: $1";
		}
		else {
			# ERRORS
			#say "Error in View->parse_nest_blocks. Unbalanced '$4' at position = ", $-[0];
			#$IsError = 1;
			# Decide to continue here ..
			# If BailOnError is set, just unwind recursion. 
			#if ($BailOnError) {last;}
       }
    }
	return $k;
}
#=========================================================#
=head2 block()
	
	# get all blocks as a hashref
	$blocks = $view->block;

	# get one block as a hashref
	$block = $view->block("first");
	
	# set a block new content
	$view->block("first", "1st Block New Content ");

Get and set blocks. Blocks or iterators are a block of the template code marked or processing and replacing with
dynamic content. For example you can use blocks to  show or hide a part of the template based on conditions. Another
example is using nested blocks as iterators for displaying lists or tables of repeated rows.

=cut

sub block {
	my ($self) = shift;
	if (@_ == 1) {
		# return one block by its complete path like first/second/third/fourth
		my $path = shift;
		#---------------------------------------
		if ($path !~ /\//) {
			return $self->{block}->{$path};
		}
		#---------------------------------------
		$path =~ s/^\/+|\/+$//g;
		my @path = split /\//, $path;
		my $v = $self->{block};
		
		while (my $k = shift @path) {
			if (!exists $v->{$k}) {
				return;
			}
			 $v = $v->{$k};
		}

		return $v;
	}
	elsif (@_ > 1) {
		#set blocks
		my %blocks = @_;
		while (my($k, $v) = each %blocks) {
			#say "[($k, $v)] " .$self->block($k);
			$self->block($k)->{content} = $v;
		}
		#return all blocks hash object
		$self->{block};
	}
	else {
		#return all blocks hash object
		$self->{block};
	}
}
#=========================================================#
sub process_blocks {
	my ($self) = $_[0];
	my ($name, $var, $match);
	#say "Pass...";
	# process root blocks
	while (($name, $var) = each %{$self->{block}}) {
		#say "block: $name";
		#$self->{block}->{first} = {match=>, content=>, #next=>};
		$match = $var->{match};
		$self->{content} =~ s/\Q$match\E/$var->{content}/gex;
	}
}
#=========================================================#
=head2 replace()
	
	$view->replace('find text' => 'replaced text');
	$view->replace(%vars);

Replace some template text or code with another one. This method will replace all instances of the found text. This method can be chained.

=cut
sub replace {
	my ($self, %vars) = @_;
	while (my ($k, $v) = each %vars) {
		$self->{content} =~ s/\Q$k\E/$v/g;
	}
	$self;
}
#=========================================================#
=head2 replace()
	
	$view->replace('find text' => 'replaced text');
	$view->replace(%vars);

Replace some template text or code with another one. This method will replace only one instance of the found text. This method can be chained.

=cut

sub replace_once {
	my ($self, %vars) = @_;
	while (my ($k, $v) = each %vars) {
		$self->{content} =~ s/\Q$k\E/$v/;
	}
	$self;
}
#=========================================================#
=head2 translate()
	
	# scan and replace the template language variables for the default 2 times
	$view->translate;

	# scan and replace the template language variables for 3 times
	$view->translate(3);

This method normally used internally when processing the template. It scans the tempalte for the langauge variables
surrounded by the curly braces B<{var_name}> and replaces them with their values from the loaded language files. 
This method can be chained.

=cut

sub translate {
	my ($self, $passes) = @_;
	
	$passes += 0;
	$passes ||= 2;
	
	my $vars = $self->me->lang->vars($self->{lang});

	while ($passes--) {
		$self->{content} =~ s/\{(.+?)\}/exists $vars->{$1} ? $vars->{$1} : "\{$1\}"/gex;
	}

	$self;
}
#=========================================================#
=head2 process_vars()
	
	$view->process_vars;

This method normally used internally when processing the template. This method can be chained.

=cut

sub process_vars {
	my ($self) = $_[0];
	my ($name, $var, $match);
	
	while (($name, $var) = each %{$self->{tag}->{var}}) {
		#$self->{tag}->{$type}->{$attr{name}} = {attr=>{%attr}, match=>$match, content=>$content};
		if (exists $self->{vars}->{$name}) {
			$match = $var->{match};
			#say "$self->{vars}->{$name} => $match";
			$self->{content} =~ s/\Q$match\E/$self->{vars}->{$name}/gex;
		}
	}
	$self;
}
#=========================================================#
=head2 process_perl()
	
	$view->process_perl;

This method normally used internally when processing the template. This method can be chained.

=cut

sub process_perl {
	my ($self) = $_[0];
	my ($name, $var, $match);
	
	while (($name, $var) = each %{$self->{tag}->{perl}}) {
		#$self->{tag}->{$type}->{$attr{name}} = {attr=>{%attr}, match=>$match, content=>$content};
		$match = $var->{match};
		$self->{content} =~ s/\Q$match\E/$self->capture($var->{content})/gex;
	}
	$self;
}
#=========================================================#
=head2 capture()
	
	$view->capture($perl_code);

This method normally used internally when processing the template.

=cut

sub capture {
	my ($self, $code) = @_;
	
	my ($merged, @result) = Capture::Tiny::capture_merged {eval $code};
	#$merged .= join "", @result;
	if ($@) {
		$merged  = "Embeded Perl code error: $@\n $code\n $merged\n";
	}
	return $merged;
}
#=========================================================#
=head2 get_widget()
	
	$view->get_widget($widget, $theme);

This method normally used internally when processing the template. Returns the widget file content.

=cut

sub get_widget {
	
	my ($self, $view, $theme) = @_;
		
	$view .= ".html" unless ($view =~ /\.html$/i);
	$theme ||= $self->{theme} ||= $self->me->var->get("theme");
	my $file = $self->me->file->catfile($self->me->var->get("themes_dir"), $theme, "widget", $view);

	if (exists $self->{cash}->{$file}) {
		return $self->{cash}->{$file};
	}

	my $content = $self->me->file->get($file);
	$self->{cash}->{$file} = $content;
	return $content;
}
#=========================================================#
=head2 process_widgets()
	
	$view->process_widgets;

This method normally used internally when processing the template. This method can be chained.

=cut

sub process_widgets {

	my ($self) = $_[0];
	my ($name, $var, $match, $content, $k, $v);
	
	while (($name, $var) = each %{$self->{tag}->{widget}}) {
		#$self->{tag}->{$type}->{$attr{name}} = {attr=>{%attr}, match=>$match, content=>$content};
		$match = $var->{match};
		$content = $self->get_widget($name);
		# replace widget args named as [:name:]
		while (($k, $v) = each %{$var->{attr}}) {
			$content =~ s/\[:$k:\]/$v/g;
		}
		$self->{content} =~ s/\Q$match\E/$content/gex;
	}
	$self;
}
#=========================================================#
=head2 process_plugins()
	
	$view->process_plugins ;

This method normally used internally when processing the template. This method can be chained.

=cut

sub process_plugins {

	my ($self) = $_[0];
	my ($me, $name, $var, $match, $content, $k, $v, $class, $plugin);
	my (%attr, $op, $sub, $obj, $meta);

	$me = $self->me;

	while (($name, $var) = each %{$self->{tag}->{plugin}}) {
		#$self->{tag}->{$type}->{$attr{name}} = {attr=>{%attr}, match=>$match, content=>$content};
		$content = "";
		$match = $var->{match};
		
		#supports: name="Plugin::Controller->Action", name="Plugin->Action", name="plugin" >=> Plugin/Plugin/index
		#($plugin, $op, $sub) = $name =~ /^(.*)(::|->)(\w+)?$/;
		($plugin, $op, $sub) = $name =~ /^(.*)(->)(\w+)?$/;
		$plugin ||= $name;
		my $action = $sub || lc($plugin);
		
		$plugin = ucfirst($plugin);
		if ($plugin && $plugin !~ /::/) {
			$plugin = "$plugin:\:$plugin";
		}

		$op ||= "->";
		$sub ||= "index";
		
		$class = "Nile::Plugin:\:$plugin";

		eval "use $class;";
		if ($@) {
			$content = " Error: plugin $plugin$op$sub does not exist. ";
			$self->{content} =~ s/\Q$match\E/$content/gex;
			next;
		}

		%attr = %{$var->{attr}};

		# delete the attr keys used by the vars tag itself
		delete $attr{$_} for (qw(type name));
		
		$obj = $class->new(%attr);
		$meta = $obj->meta;

		#$meta->add_method( 'hello' => sub { return "Hello inside hello method. @_" } );
		
		# add method "me" to module, if module has method "me" then add "mew" instead.
		if (!$obj->can("me")) {
			$meta->add_attribute( 'me' => ( is => 'rw', default => sub{$me}) );
			$obj->me($me);
		}
		else {
			$meta->add_attribute( 'nile' => ( is => 'rw', default => sub{$me}) );
			$obj->nile($me);
		}
		
		my $found = 0;
		foreach my $method ($sub,"index", $action) {
			if ($obj->can($method)) {
				my ($merged, @result) = Capture::Tiny::capture_merged {eval $obj->$method(%attr)};
				#$merged .= join "", @result;
				if ($@) {
					$content  = "Plugin error: $@\n $class->$method. $merged\n";
				}
				else {
					$content = $merged; 
				}
				$found = 1;
				last;
			}
		}

		if (!$found) {
			$content = " Plugin error: plugin \'$class' does not have subroutine \'$sub\'. ";
		}

		$self->{content} =~ s/\Q$match\E/$content/gex;
	}
	$self;
}
#=========================================================#
=head2 parse()
	
	$view->parse;

This method normally used internally when processing the template. This method can be chained.

=cut

sub parse {
	my ($self) = @_;
	$self->parse_vars;
	$self->parse_blocks;
	$self;
}
#=========================================================#
=head2 process_pass()
	
	$view->process_pass;

This method normally used internally when processing the template. This method can be chained.

=cut

sub process_pass {
	my ($self) = @_;
	$self->process(1);
	$self->parse;
	$self;
}
#=========================================================#
=head2 process()
	
	$view->process;
	$view->process($passes);

Process the template. This method can be chained.

=cut

sub process {
	
	my ($self, $passes) = @_;
	
	$passes += 0;
	$passes ||= 3;
	
	for my $pass(1..$passes) {
		$self->translate;
		$self->process_widgets;
		$self->process_blocks;
		$self->process_plugins;
		$self->process_perl;
		$self->process_vars;
		if ($pass < $passes) {
			#say "parsing...";
			$self->parse;
		}
	}
	#------------------------------------------------------
	#$ProgramEndTime = Time::HiRes::gettimeofday();
	#$Benchmark = sprintf("%.3f", Time::HiRes::gettimeofday() - $ProgramStartTime);
	#------------------------------------------------------
	#for (1..1) {$self->process_vars();}
	#------------------------------------------------------
	$self;
}
#=========================================================#
=head2 render()
	
	$view->render;

Send the template content to the browser. This method can be chained.

=cut

sub render {

	my ($self) = $_[0];
	my ($gziped);	
	
	unless (exists	$ENV{HTTP_ACCEPT_ENCODING} &&
							$ENV{HTTP_ACCEPT_ENCODING} =~ /\bgzip\b/ &&
							$self->me->var->{gzip_output}) {
		$self->header();
		print $self->{content};
		return;
	}

	print "Content-Type: text/html\n";
	print "Content-Encoding: gzip\n\n";
	gzip $self->{content}, \$gziped or die "gzip failed: $GzipError\n";
	print $gziped;
	$self;
}
#=========================================================#
=head2 out()
	
	$view->out;

Process the template and return the content.

=cut

sub out {
	my ($self) = $_[0];
	$self->process();
	return $self->{content};
}
#=========================================================#
=head2 show()
	
	$view->show;
	
	# is the same as doing
	$view->process();
	$view->render();

Process the template and send the content to the browser.

=cut

sub show {
	my ($self) = $_[0];
	$self->process();
	$self->render();
	$self;
}
#=========================================================#
=head2 header()
	
	$view->header;

Prints the header tot he browser.

=cut

sub header {
	my ($self, $type) = @_;
	$type ||= "text/html;charset=utf-8";
	print "Content-type: $type\n\n";
	$self;
}
#=========================================================#
sub DESTROY {
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
