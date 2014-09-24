#   Copyright Infomation
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Author : Dr. Ahmed Amin Elsheshtawy, Ph.D.
# Website: https://github.com/mewsoft/Nile, http://www.mewsoft.com
# Email  : mewsoft@cpan.org, support@mewsoft.com
# Copyrights (c) 2014-2015 Mewsoft Corp. All rights reserved.
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
package Nile::DBI::Table;

our $VERSION = '0.52';
our $AUTHORITY = 'cpan:MEWSOFT';

=pod

=encoding utf8

=head1 NAME

Nile::DBI::Table - DBI table class for the Nile framework.

=head1 SYNOPSIS
    
    # get table object
    my $table = $app->db->table("users");

    # or
    
    my $table = $app->db->table;
    
    # set table name
    $table->name("users");
    
    # get table name
    my $name = $table->name;

    $table->delete;
    $table->optimize;
    $table->empty;
    $table->truncate;
    my @columns_info = $table->describe;

=head1 DESCRIPTION
    
Nile::DBI::Table - DBI table class for the Nile framework.

This class provides functions for easy managing database tables.

=cut

use Nile::Base;
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
=head2 name()
    
    # set table name with constructor
    my $table = $app->db->table("users");

    # or
    
    # get table object
    my $table = $app->db->table;
    
    # then set table name
    $table->name("users");
    
    # get table name
    my $name = $table->name;
    
Get and set the table name.

=cut

has 'name' => (
      is => 'rw',
  );
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
sub BUILD {
    my ($self, $arg) = @_;
    $self->name($arg->{name});
}
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
=head2 delete() or drop()
    
    my $table = $app->db->table("users");

    $table->delete;
    
    # or

    $app->db->table("users")->delete;

Drops database table. Method drop() is a shortcut for delete();

=cut

sub delete {
    my ($self) = @_;
    $self->app->db->do("drop table ".$self->name);
    $self;
}
*drop =\&delete;
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
=head2 rename()
    
    $table->rename("newname");

Rename database table.

=cut

sub rename {
    my ($self, $name) = @_;
    $self->app->db->do("rename table ".$self->name . " TO ". $name);
    $self->name($name);
    $self;
}
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
=head2 optimize()
    
    $table->optimize;

Optimizes database table.

=cut

sub optimize {
    my ($self) = @_;
    $self->app->db->do("optimize table ".$self->name);
    $self;
}
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
=head2 empty()
    
    $table->empty;

Empties a table completely row by row. This method is slow, see truncate() method.

=cut

sub empty {
    my ($self) = @_;
    $self->app->db->do("delete from ".$self->name);
    $self;
}
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
=head2 truncate()
    
    $table->truncate;

Empties a table completely and takes care of FOREIGN KEY constraints.

=cut

sub truncate {
    my ($self) = @_;
    $self->app->db->do("truncate ".$self->name);
    $self;
}
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
=head2 describe()
    
    my @table = $table->describe;
    $app->dump(@table);

Provides information about the columns in a table. It is a shortcut for SHOW COLUMNS FROM.

=cut

sub describe {
    my ($self) = @_;
    #$self->app->db->hashes("describe ".$self->name, 'Field');
    $self->app->db->rows("describe ".$self->name);
}
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
=head2 struct()
    
    my $struct = $table->struct;
    
    say "Table name: " . $struct->{"Table"};
    say "Table struct: " . $struct->{"Create Table"};

Shows the CREATE TABLE statement that creates the named table. To use this statement, you must have some privilege for the table.

=cut

sub struct {
    my ($self) = @_;
    $self->app->db->hash("show create table ".$self->name);
}
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
sub create {
    my ($self, $columns, $extra) = @_;
    $self->app->db->rows("create table ".$self->name . "($columns)$extra");
    $self;
}
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
=head2 tables()
    
    my @table = $table->tables;

Retuns all the tables in the default database.

=cut

sub tables {
    my ($self) = @_;
    $self->app->db->col("SHOW TABLES");
}
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
=head2 backup()
    
    my $file = $app->file->catfile($app->var->get("data_dir"), "table.txt");

    # backup data_dir/table.txt
    $table->backup($file);

    # backup and gzip it to table.gzip
    $table->backup($file, compress => "gzip");
    
    # backup to comma-separated values (CSV) format and zip it to table.zip
    $table->backup($file, format => "csv", compress => "zip");
    
Writes tables rows to file. Requires grant file permission.

=cut

sub backup {
    my ($self, $file, %options) = @_;

    unlink ($file);

    # The NULL value means “no data.” NULL can be written in any lettercase. A synonym is \N (case sensitive). 
    # For text file import or export operations performed with LOAD DATA INFILE or SELECT ... INTO OUTFILE, NULL is represented by the \N sequence.
    # defaults: FIELDS TERMINATED BY '\t' ENCLOSED BY '' ESCAPED BY '\\' LINES TERMINATED BY '\n' STARTING BY ''

    $options{format} = lc($options{format});
    $options{compress} = lc($options{compress});
    
    my $format = "";
    
    if ($options{format} eq "csv") {
        $format = qq{ FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY '\n' };
    }

    $self->app->db->run("select * into outfile ".$self->app->db->quote($file).$format." from ".$self->name);

    if ($options{compress} eq "zip") {
        $self->app->file->zip($file);
    }
    elsif ($options{compress} eq "gzip") {
        $self->app->file->gzip($file);
    }

    $self;
}
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
=head2 restore()
    
    my $file = $app->file->catfile($app->var->get("data_dir"), "users.txt");

    # restore table 'users' from backup file data_dir/users.txt
    $table->restore("users", $file);

    # unzip backup file "zip" or "gzip" and restore table from unziped file
    my $zipfile = $app->file->catfile($app->var->get("data_dir"), "users.zip");
    my $table_file_name = "users.txt";
    $table->backup("users", $zipfile, $table_file_name, format =>"csv");
    
Empties table contents and load data from backup file.

=cut

sub restore {
    my ($self, $table, $file, $zipname, $format) = @_;

    return unless ($table and $file);

     my ($name, $dir, $ext, $filename) = $self->path_info($file);

    if ($file =~ /\.zip$/i) {
        $self->app->file->unzip($file);
        $file = $self->file->catfile($dir, $zipname);
    }
    elsif ($file =~ /\.gzip$/i) {
        $self->app->file->gunzip($file);
        $file = $self->file->catfile($dir, $zipname);
    }
    
    if ($format eq "csv") {
        $format = qq{ FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY '\n' };
    }

    $self->app->db->run("load data infile ".$self->app->db->quote($file)." into table ".$self->name.$format);

    $self;
}
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
sub copy {
    my ($self, $new) = @_;
    $new || return;
    #create table newtable like oldtable; 
    #insert newtable select * from oldtable
    $self->app->db->run("create table ".$new." like ".$self->name);
    $self->app->db->run("insert ".$new." select * from ".$self->name);
}
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

=pod

=head1 Bugs

This project is available on github at L<https://github.com/mewsoft/Nile>.

=head1 HOMEPAGE

Please visit the project's homepage at L<https://metacpan.org/release/Nile>.

=head1 SOURCE

Source repository is at L<https://github.com/mewsoft/Nile>.

=head1 SEE ALSO

See L<Nile> for details about the complete framework.

=head1 AUTHOR

Ahmed Amin Elsheshtawy,  احمد امين الششتاوى <mewsoft@cpan.org>
Website: http://www.mewsoft.com

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2014-2015 by Dr. Ahmed Amin Elsheshtawy احمد امين الششتاوى mewsoft@cpan.org, support@mewsoft.com,
L<https://github.com/mewsoft/Nile>, L<http://www.mewsoft.com>

This library is free software; you can redistribute it and/or modify it under the same terms as Perl itself.

=cut

1;
