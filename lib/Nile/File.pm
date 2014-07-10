#	Copyright Infomation
#=========================================================#
#	Module	:	Nile::File
#	Author		:	Dr. Ahmed Amin Elsheshtawy, Ph.D.
#	Website	:	https://github.com/mewsoft/Nile, http://www.mewsoft.com
#	Email		:	mewsoft@cpan.org, support@mewsoft.com
#	Copyrights (c) 2014-2015 Mewsoft Corp. All rights reserved.
#=========================================================#
package Nile::File;

our $VERSION = '0.11';

=pod

=encoding utf8

=head1 NAME

Nile::File - Files and folders manager.

=head1 SYNOPSIS
	
	# get the file content as a single string.
	$content = $self->me->file->get($file);

	# get the file content as an array of lines.
	@lines = $self->me->file->get($file);
	
	# get list of specific files in a folder
	@files = $self->me->file->files("c:/apache/htdocs/nile/", "*.pm, *.cgi");
		
	# get list of specific files in a folder recursively
	# files_tree($dir, $match, $relative, $depth)
	@files = $self->me->file->files_tree("c:/apache/htdocs/nile/", "*.pm, *.cgi");

	# get list of sub folders in a folder
	#folders($dir, $match, $relative)
	@folders = $self->file->folders("c:/apache/htdocs/nile/", "", 1);
	
	# get list of sub folders in a folder recursively
	#folders_tree($dir, $match, $relative, $depth)
	@folders = $self->file->folders_tree("c:/apache/htdocs/nile/", "", 1);

=head1 DESCRIPTION

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
	@folders = $self->file->#folders_tree("c:/apache/htdocs/nile/", "", 1);

Nile::File - Files and folders manager.

=cut

use Nile::Base;
use File::Slurp;
use File::Find::Rule;
use File::Basename ();

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

=head2 get()
	
	# file($file, $options)
	$content = $self->me->file->get("/path/file.txt");
	@lines = $self->me->file->get("/path/file.txt");

	$bin = $self->me->file->get("/path/file.bin", binmode => ':raw');
	$utf = $self->me->file->get("/path/file.txt", binmode => ':utf8');

Reads file contents into a single variable or an array. This method is a wrapper around L<File::Slurp> read_file method.

=cut

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
=head2 put()
	
	# put($file, $options)
	$self->me->file->put($file, @data);
	$self->me->file->put($file, {binmode => ':raw'}, $buffer);

	$self->me->file->put($file, \$buffer);
	# the same as
	$self->me->file->put($file, $buffer);

	$self->me->file->put($file, \@lines) ;
	# the same as
	$self->me->file->put($file, @lines) ;

Writes contents into a file. This method is a wrapper around L<File::Slurp> write_file method. 
The first argument is the filename. The second argument is an optional hash reference and it 
contains key/values that can modify the behavior of write_file. The rest of the argument list is the data to be written to the file.

=cut

sub put {
	my $self = shift;
	#shift if ref ($_[0]) || $_[0] eq __PACKAGE__;
	#write_file( $bin_file, {binmode => ':raw'}, @data );
	#write_file( $bin_file, {binmode => ':utf8', append => 1}, $utf_text );
	return write_file(@_);
}
#=========================================================#
=head2 File::Spec supported methods
	
	$self->me->file->canonpath;
	$self->me->file->catdir
	$self->me->file->catfile
	$self->me->file->curdir
	$self->me->file->rootdir
	$self->me->file->updir
	$self->me->file->no_upwards
	$self->me->file->file_name_is_absolute
	$self->me->file->path
	$self->me->file->devnull
	$self->me->file->tmpdir
	$self->me->file->splitpath
	$self->me->file->splitdir
	$self->me->file->catpath
	$self->me->file->abs2rel
	$self->me->file->rel2abs
	$self->me->file->case_tolerant

Wrapper methods around L<File::Spec> functions.

=cut

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
=head2 files()
	
	# files($dir, $match, $relative)
	@files = $self->me->file->files("c:/apache/htdocs/nile/", "*.pm, *.cgi");

Returns a list of files in a specific folder. The first argument is the path, the second argument is the filename match
if not set will match all files, the third argument is the relative flag, if set will include the relative path of the files.

=cut

sub files {
	my ($self, $dir, $match, $relative) = @_;
	$relative += 0;
	#($dir, $match, $depth, $folders, $relative)
	return $self->scan_dir($dir, $match, 1, 0, $relative);
}
#=========================================================#

=head2 files_tree()
	
	# files_tree($dir, $match, $relative, $depth)
	@files = $self->me->file->files_tree("c:/apache/htdocs/nile/", "*.pm, *.cgi");

Returns a list of files in a specific folder. The first argument is the path, the second argument is the filename match
if not set will match all files, the third argument is the relative flag, if set will include the relative path of the files.

=cut

sub files_tree {
	my ($self, $dir, $match, $relative, $depth) = @_;
	#($dir, $match, $depth, $folders, $relative)
	return $self->scan_dir($dir, $match, $depth, 0, $relative);
}
#=========================================================#

=head2 folders()
	
	# get list of sub folders in a folder
	# folders($dir, $match, $relative)
	@folders = $self->file->folders("c:/apache/htdocs/nile/", "", 1);
	
	# get list of sub folders in a folder recursively
	#folders_tree($dir, $match, $relative, $depth)
	@folders = $self->file->$folders_tree("c:/apache/htdocs/nile/", "", 1);

Returns a list of sub folders in a folder.

=cut

sub folders {
	my ($self, $dir, $match, $relative) = @_;
	return $self->scan_dir($dir, $match, 1, 1, $relative);
}
#=========================================================#

=head2 folders_tree()
	
	# get list of sub folders in a folder recursively
	#folders_tree($dir, $match, $relative, $depth)
	@folders = $self->file->folders_tree("c:/apache/htdocs/nile/", "", 1);

Returns list of sub folders in a folder recursively.

=cut

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
=head2 os()
	
	my $os = $self->me->file->os;

Returns the name of the operating system.

=cut

sub os {$OS}

#=========================================================#

=head2 ds()
	
	my $ds = $self->me->file->ds;

Returns the directory separator of the operating system.

=cut

sub ds {$DS}
#=========================================================#

=head2 fileparse()
	
	my ($filename, $dirs, $suffix) = $self->me->file->fileparse($path);
	my ($filename, $dirs, $suffix) = $self->me->file->fileparse($path, @suffixes);
	my $filename = $self->me->file->fileparse($path, @suffixes);

Splits a file path into its $dirs, $filename and (optionally) the filename $suffix. See L<File::Basename>

=cut

sub fileparse {
	my ($self) = shift;
	return File::Basename::fileparse(@_);
}
#=========================================================#

=head2 basename()
	
	my $filename  = $self->me->file->basename($path);
	my $filename  = $self->me->file->basename($path, @suffixes);

Returns the last level of a filepath even if the last level is clearly directory. In effect, it is acting like pop() for paths. See L<File::Basename>

=cut

sub basename {
	my ($self) = shift;
	return File::Basename::basename(@_);
}
#=========================================================#

=head2 dirname()
	
	my $ds = $self->me->file->dirname();

Returns the directory separator of the operating system. See L<File::Basename>

=cut

sub dirname {
	my ($self) = shift;
	return File::Basename::dirname(@_);
}
#=========================================================#
=head2 path_info()
	
	my ($name, $dir, $ext, $name_$ext) = $self->me->file->path_info($path);

Splits a file path into its $dir, $name, filename $suffix, and name with suffix.

=cut

sub path_info {
	my ($self, $path) = @_;
	my ($name, $dir, $ext) = File::Basename::fileparse($path,  qr/\.[^.]*/); # qr/\.[^.]*/ matched against the end of the $filename.
	return ($name, $dir, $ext, $name.$ext);
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
