#	Copyright Infomation
#=========================================================#
#	Module	:	Nile::File
#	Author		:	Dr. Ahmed Amin Elsheshtawy, Ph.D.
#	Website	:	https://github.com/mewsoft/Nile, http://www.mewsoft.com
#	Email		:	mewsoft@cpan.org, support@mewsoft.com
#	Copyrights (c) 2014-2015 Mewsoft Corp. All rights reserved.
#=========================================================#
package Nile::File;

use Nile::Base;
use File::Slurp;
use File::Find::Rule;
use File::Basename ();

our $VERSION = '0.10';

our ($OS, %DS, $DS);

BEGIN {  
	unless ($OS = $^O) { require Config; eval(q[$OS=$Config::Config{osname}]) }
	if ($OS =~ /^darwin/i) { $OS = 'UNIX';}
	elsif ($OS =~ /^cygwin/i) { $OS = 'CYGWIN';}
	elsif ($OS =~ /^MSWin/i)  { $OS = 'WINDOWS';}
	elsif ($OS =~ /^vms/i)    { $OS = 'VMS';}
	elsif ($OS =~ /^bsdos/i)  { $OS = 'UNIX';}
	elsif ($OS =~ /^dos/i)    { $OS = 'DOS';}
	elsif ($OS =~ /^MacOS/i)  { $OS = 'MACINTOSH';}
	elsif ($OS =~ /^epoc/)    { $OS = 'EPOC';}
	elsif ($OS =~ /^os2/i)    { $OS = 'OS2';}
	else { $OS = 'UNIX';}

	%DS = ('DOS' => '\\', 'EPOC' => '/', 'MACINTOSH' => ':',
			'OS2' => '\\', 'UNIX' => '/', 'WINDOWS'   => chr(92),
			'VMS' => '/',  'CYGWIN' => '/');
	$DS = $DS{$OS} || '/';
}

#=========================================================#
sub get {
	#shift if ref ($_[0]) || $_[0] eq __PACKAGE__;
	my $self = shift;
	my $file = shift ;
	my $opts = (ref $_[0] eq 'HASH' ) ? shift : {@_};
	
	# if wantarray, default to chomp lines
	#if (defined wantarray && ! exists $opts->{chomp}) {
	#	$opts->{chomp} = 1;
	#}

	#my $bin_data = read_file( $bin_file, binmode => ':raw' );
	#my $utf_text = read_file( $bin_file, binmode => ':utf8' ); chomp=>1
	return read_file($file, $opts);
}
#=========================================================#
sub put {
	my $self = shift;
	#shift if ref ($_[0]) || $_[0] eq __PACKAGE__;
	#write_file( $bin_file, {binmode => ':raw'}, @data );
	#write_file( $bin_file, {binmode => ':utf8', append => 1}, $utf_text );
	return write_file(@_);
}
#=========================================================#
sub canonpath {shift; File::Spec->canonpath(@_);}
sub catdir {shift; File::Spec->catdir(@_);}
sub catfile {shift; File::Spec->catfile(@_);}
sub curdir {shift; File::Spec->curdir(@_);}
sub rootdir {shift; File::Spec->rootdir(@_);}
sub updir {shift; File::Spec->updir(@_);}
sub no_upwards {shift; File::Spec->no_upwards(@_);}
sub file_name_is_absolute {shift; File::Spec->file_name_is_absolute(@_);}
sub path {shift; File::Spec->path(@_);}
sub devnull {shift; File::Spec->devnull(@_);}
sub tmpdir {shift; File::Spec->tmpdir(@_);}
sub splitpath {shift; File::Spec->splitpath(@_);}
sub splitdir {shift; File::Spec->splitdir(@_);}
sub catpath {shift; File::Spec->catpath(@_);}
sub abs2rel {shift; File::Spec->abs2rel(@_);}
sub rel2abs {shift; File::Spec->rel2abs(@_);}
sub case_tolerant {shift; File::Spec->case_tolerant(@_);}
#=========================================================#
#@files = files("c:/apache/htdocs/auction/", "*.pm, *.cgi");
sub files {
	my ($self, $dir, $match, $relative) = @_;
	$relative += 0;
	#($dir, $match, $depth, $folders, $relative)
	return $self->scan_dir($dir, $match, 1, 0, $relative);
}
#=========================================================#
sub files_tree {
	my ($self, $dir, $match, $relative, $depth) = @_;
	#($dir, $match, $depth, $folders, $relative)
	return $self->scan_dir($dir, $match, $depth, 0, $relative);
}
#=========================================================#
sub folders {
	my ($self, $dir, $match, $relative) = @_;
	return $self->scan_dir($dir, $match, 1, 1, $relative);
}
#=========================================================#
sub folders_tree {
	my ($self, $dir, $match, $relative, $depth) = @_;
	return $self->scan_dir($dir, $match, $depth, 1, $relative);
}
#=========================================================#
sub scan_dir {
	my ($self, $dir, $match, $depth, $folders, $relative) = @_;
	my ($rule, @match);
	
	$dir ||= "";
	$match ||= "";
	$depth += 0;
	
	#$relative != $relative;
	#$relative = ($relative)? 0 : 1;
	
	#my @files = File::Find::Rule->file->name( "*.pm" )->maxdepth( $depth )->in( $dir );
	#my @subdirs = File::Find::Rule->directory->maxdepth( 1 )->relative->in( "." );

	$rule =  File::Find::Rule->new();

	if ($folders) {
			$rule->directory();
	}
	else {
		$rule->file();
	}

	if ($relative) {$rule->relative();}

	if ($match) {
		@match = split(/\s*\,\s*/, $match); # *.cgi, *.pm, *.ini, File::Find::Rule->name( '*.avi', '*.mov' ),
		$rule->name(@match);
	}
	
	# depth=0 for unlimited depth recurse
	if ($depth) {$rule->maxdepth($depth);}
	
	if (ref($dir) eq 'ARRAY' ) {
		@$dir = map {$self->catdir($_)} @$dir;
		return ($rule->in(@$dir));
	}
	else {
		return ($rule->in($self->catdir($dir)));
	}
}
#=========================================================#
# OS type
sub os {$OS}

# directory separator
sub ds {$DS}
#=========================================================#
sub path_info {
	my ($self, $path) = @_;
	my ($name, $dir, $ext) = File::Basename::fileparse($path,  qr/\.[^.]*/); # qr/\.[^.]*/ matched against the end of the $filename.
	return ($name, $dir, $ext, $name.$ext);
}
#=========================================================#
sub fileparse {
	my ($self) = shift;
	return File::Basename::fileparse(@_);
}
#=========================================================#
sub basename {
	my ($self) = shift;
	return File::Basename::basename(@_);
}
#=========================================================#
sub dirname {
	my ($self) = shift;
	return File::Basename::dirname(@_);
}
#=========================================================#
1;