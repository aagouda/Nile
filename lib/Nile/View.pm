#	Copyright Infomation
#=========================================================#
#	Module	:	Nile::View
#	Author		:	Dr. Ahmed Amin Elsheshtawy, Ph.D.
#	Website	:	https://github.com/mewsoft/Nile, http://www.mewsoft.com
#	Email		:	mewsoft@cpan.org, support@mewsoft.com
#	Copyrights (c) 2014-2015 Mewsoft Corp. All rights reserved.
#=========================================================#
package Nile::View;

use Nile::Base;
use Capture::Tiny ();
use Time::HiRes qw(gettimeofday);
use IO::Compress::Gzip qw(gzip $GzipError);

our $VERSION = '0.10';
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
		return $self;
	}
	
	$self->parse;

	$self->{view};
}
#=========================================================#
sub lang {
	my ($self, $lang) = @_;
	if ($lang) {
		$self->{lang} = $lang;
		return $self;
	}
	$self->{lang};
}
#=========================================================#
sub theme {
	my ($self, $theme) = @_;
	if ($theme) {
		$self->{theme} = $theme;
		return $self;
	}
	$self->{theme};
}
#=========================================================#
sub var {
	my ($self, %vars) = @_;
	map {$self->{vars}->{$_} = $vars{$_}} keys %vars;
	$self;
}
#=========================================================#
sub set {
	my ($self, %vars) = @_;
	map {$self->{vars}->{$_} = $vars{$_}} keys %vars;
	$self;
}
#=========================================================#
sub get {
my ($self, @name) = @_;
	#@{ $h{'a'} }{ @keys }
	@{ $self->{vars} }{@name};
}
#=========================================================#
sub content {
my ($self) = shift;
	if (@_) {
		$self->{content} = $_[0];
		return $self;
	}
	$self->{content};
}
#=========================================================#
sub parse {
	my ($self) = @_;
	$self->parse_vars;
	$self->parse_blocks;
	$self;
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
sub block {
	my ($self) = shift;
	$self->{block};
}
#=========================================================#
sub replace {
	my ($self, %vars) = @_;
	while (my ($k, $v) = each %vars) {
		$self->{content} =~ s/\Q$k\E/$v/g;
	}
	$self;
}
#=========================================================#
sub replace_once {
	my ($self, %vars) = @_;
	while (my ($k, $v) = each %vars) {
		$self->{content} =~ s/\Q$k\E/$v/;
	}
	$self;
}
#=========================================================#
sub translate {
	my ($self, $passes) = @_;
	
	$passes += 0;
	$passes = 2;
	
	my $vars = $self->me->lang->vars($self->{lang});

	while ($passes--) {
		$self->{content} =~ s/\{(.+?)\}/exists $vars->{$1} ? $vars->{$1} : "\{$1\}"/gex;
	}

	$self;
}
#=========================================================#
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
}
#=========================================================#
sub process_perl {
	my ($self) = $_[0];
	my ($name, $var, $match);
	
	while (($name, $var) = each %{$self->{tag}->{perl}}) {
		#$self->{tag}->{$type}->{$attr{name}} = {attr=>{%attr}, match=>$match, content=>$content};
		$match = $var->{match};
		$self->{content} =~ s/\Q$match\E/$self->capture($var->{content})/gex;
	}
}
#=========================================================#
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

}
#=========================================================#
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

}
#=========================================================#
sub process_once {
	my ($self) = @_;
	$self->process(1);
}
#=========================================================#
sub process {
	
	my ($self, $passes) = @_;
	
	$passes += 0;
	$passes ||= 3;
	
	for (1..$passes) {
		$self->translate();
		
		$self->parse;

		$self->process_widgets();
		$self->process_plugins();
		$self->process_perl;
		$self->process_vars;
	}
	#------------------------------------------------------
	#$ProgramEndTime = Time::HiRes::gettimeofday();
	#$Benchmark = sprintf("%.3f", Time::HiRes::gettimeofday() - $ProgramStartTime);
	#------------------------------------------------------
	#for (1..1) {$self->process_vars();}
	#------------------------------------------------------
}
#=========================================================#
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
}
#=========================================================#
sub out {
	my ($self) = $_[0];
	$self->process();
	return $self->{content};
}
#=========================================================#
sub show {
	my ($self) = $_[0];
	$self->process();
	$self->render();
}
#=========================================================#
sub header {
	my ($self, $type) = @_;
	$type ||= "text/html;charset=utf-8";
	print "Content-type: $type\n\n";
}
#=========================================================#
sub DESTROY {
}
#=========================================================#

1;
