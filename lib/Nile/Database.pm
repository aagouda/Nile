#	Copyright Infomation
#=========================================================#
#	Module	:	Nile::Database
#	Author		:	Dr. Ahmed Amin Elsheshtawy, Ph.D.
#	Website	:	https://github.com/mewsoft/Nile, http://www.mewsoft.com
#	Email		:	mewsoft@cpan.org, support@mewsoft.com
#	Copyrights (c) 2014-2015 Mewsoft Corp. All rights reserved.
#=========================================================#
package Nile::Database;

our $VERSION = '0.15';

=pod

=encoding utf8

=head1 NAME

Nile::Database - SQL database manager.

=head1 SYNOPSIS
	
	# set database connection params to connect
	# $args{driver}, $args{host}, $args{dsn}, $args{port}, $args{attr}
	# $args{name}, $args{user}, $args{pass}
	# if called without params, it will try to load from the default config vars.

	$dbh = $self->me->db->connect(%args);
	
=head1 DESCRIPTION

Nile::Database - SQL database manager.

=cut

use Nile::Base;
use DBI;
use Hash::AsObject;
#my $hash = Hash::AsObject->new(\%hash); $hash->foo(27); print $hash->foo; print $hash->baz->quux;

#=========================================================#
=head2 dbh()
	
	$self->me->db->dbh;

Current database connection handle.

=cut

has 'dbh' => (
      is      => 'rw',
  );
#=========================================================#
=head2 connect()
	
	$self->me->db->connect(%args);

Connect to the database. If %args empty, it will try to get args from the config object.
Returns the database connection handle is success.

=cut

sub connect {

	my ($self, %args) = @_;
	my ($dbh, $dsn);
	
	if (!%args) {
		$args{driver} = $self->me->config->var->{database}->{driver};
		$args{host} = $self->me->config->var->{database}->{host};
		$args{dsn} = $self->me->config->var->{database}->{dsn};
		$args{port} = $self->me->config->var->{database}->{port};
		$args{attr} = $self->me->config->var->{database}->{attribute}; #PrintError, RaiseError, AutoCommit etc
		$args{name} = $self->me->config->var->{database}->{name};
		$args{user} = $self->me->config->var->{database}->{user};
		$args{pass} = $self->me->config->var->{database}->{pass};
	}
	
	$args{driver} ||= "mysql";
	$args{dsn} ||= "";
	$args{host} ||= "localhost";
	$args{port} ||= 3306;
	$args{attr} ||= +{};

	if (!$args{name}) {
		$self->me->abort("Database error: Empty database name.");
	}

	#$self->dbh->disconnect if ($self->dbh);

	if ($args{driver} =~ m/ODBC/i) {
		$dbh = DBI->connect("DBI:ODBC:$args{dsn}", $args{user}, $args{pass}, $args{attr})
				or $self->db_error("$DBI::errstr, DSN: $args{dsn}");
	}
	else {
		$args{dsn} = "DBI:$args{driver}:database=$args{name};host=$args{host};port=$args{port}";
		$dbh = DBI->connect($args{dsn}, $args{user}, $args{pass}, $args{attr}) 
				or $self->db_error("$DBI::errstr, DSN: $args{dsn}");
	}

	$self->dbh($dbh);
	return $dbh;

	#$dbh->{'mysql_enable_utf8'} = 1;
	#$dbh->do('SET NAMES utf8');
}
#=========================================================#
=head2 disconnect()
	
	$self->me->db->disconnect;

Disconnect from this connection handle.

=cut

sub disconnect {
	my ($self) = @_;
	$self->dbh->disconnect if ($self->dbh);
}
#=========================================================#
=head2 run()
	
	$self->me->db->run($qry);

Run query using the DBI do command or abort if error.

=cut

sub run {
	my ($self, $qry) = @_;
	$self->dbh->do($qry) or $self->db_error($qry);
}
#=========================================================#
=head2 do()
	
	$self->me->db->do($qry);

Run query using the DBI do command and ignore errors.

=cut

sub do {
	my ($self, $qry) = @_;
	$self->dbh->do($qry);
}
#=========================================================#
=head2 exec()
	
	$sth = $self->me->db->exec($qry);

Prepare and execute the query and return the statment handle.

=cut

sub exec {
	my ($self, $qry) = @_;
	my $sth = $self->dbh->prepare($qry) or $self->db_error($qry);
	$sth->execute() or $self->db_error($qry);
	return $sth;
}
#=========================================================#
=head2 begin_work()
	
	$self->me->db->begin_work;

Enable transactions (by turning AutoCommit off) until the next call to commit or rollback. After the next commit or rollback, AutoCommit will automatically be turned on again.

=cut

sub begin_work {
	my ($self) = @_;
	return $self->dbh->begin_work or $self->db_error();
}
#=========================================================#
=head2 commit()
	
	$self->me->db->commit;

Commit (make permanent) the most recent series of database changes if the database supports transactions and AutoCommit is off.

=cut

sub commit {
	my ($self) = @_;
	$self->dbh->commit or $self->db_error();
}
#=========================================================#
=head2 rollback()
	
	$self->me->db->rollback;

Rollback (undo) the most recent series of uncommitted database changes if the database supports transactions and AutoCommit is off.

=cut

sub rollback {
	my ($self) = @_;
	$self->dbh->rollback or $self->db_error();
}
#=========================================================#
=head2 quote()
	
	$self->me->db->quote($value);
	$self->me->db->quote($value, $data_type);

Quote a string literal for use as a literal value in an SQL statement, by escaping any special characters (such as quotation marks)
contained within the string and adding the required type of outer quotation marks.
=cut

sub quote {
	my ($self, @args) = @_;
	return $self->dbh->quote(@args);
}
#=========================================================#
=head2 col()
	
	# select id from users. return one column array from all rows
	@cols = $self->me->db->col($qry);
	$cols_ref = $self->me->db->col($qry);

Return one column array from all rows

=cut

sub col {
	my ($self, $qry) = @_;
	#	select id from users. return one column array from all rows
	my $ret = $self->dbh->selectcol_arrayref($qry);
	if (!defined($ret) && $self->dbh->err()) {$self->db_error($qry);}
	return wantarray? @{$ret} : $ret;
}
#=========================================================#
=head2 row()
	
	# select id, email, fname, lname from users
	@row = $self->me->db->row($qry);

Returns one row as array.

=cut

sub row {
	my ($self, $qry) = @_;
	# select id, email, fname, lname from users
	my @ret = $self->dbh->selectrow_array($qry);
	if (!@ret && $self->dbh->err()) {$self->db_error($qry);}
	return @ret;
}
#=========================================================#
=head2 rows()
	
	# select id, fname, lname, email from users
	@rows = $self->me->db->rows($qry);
	$rows_ref = $self->me->db->rows($qry);

Returns all matched rows as array or array ref.

=cut

sub rows {
	my ($self, $qry) = @_;
	# select id, fname, lname, email from users
	my $ret = $self->dbh->selectall_arrayref($qry);
	if (!defined($ret) && $self->dbh->err()) {$self->db_error($qry);}
	return wantarray? @$ret : $ret;
}
#=========================================================#
=head2 hash()
	
	# select * from users where id=$id limit 1
	%user = $self->me->db->hash($qry);
	$user_ref = $self->me->db->hash($qry);

Returns one row as a hash or hash ref

=cut

sub hash {
	my ($self, $qry) = @_;
	# select * from users where id=$id limit 1
	my $ret = $self->dbh->selectrow_hashref($qry);
	if (!defined($ret) && $self->dbh->err()) {$self->db_error($qry);}
	return wantarray? %{$ret} : $ret;
}
#=========================================================#
=head2 row_object()
	
	# select * from users where id=$id limit 1
	$row_obj = $self->me->db->row_object($qry);
	print $row_obj->email;
	print $row_obj->fname;
	print $row_obj->lname;

Returns one row as object with columns names as object properties.

=cut

sub row_object {
	my ($self, $qry) = @_;
	# select * from users where id=$id limit 1
	my $ret = $self->dbh->selectrow_hashref($qry);
	if (!defined($ret) && $self->dbh->err()) {$self->db_error($qry);}
	return Hash::AsObject->new($ret);
}
#=========================================================#
=head2 hashes()
	
	%hashes = $self->me->db->hashes($qry, $col);
	$hashes_ref = $self->me->db->hashes($qry, $col);

Returns list or hashes of all rows. Each hash element is a hash of one row	
=cut

sub hashes {
	my ($self, $qry, $col) = @_;
	my $ret = $self->dbh->selectall_hashref($qry, $col);
	if (!defined($ret) && $self->dbh->err()) {$self->db_error($qry);}
	return wantarray? %{$ret} : $ret;
}
#=========================================================#
=head2 colhash()
	
	# select id, user from users
	%hash = $self->me->db->colhash($qry);

Returns all rows as a hash of the first column as the keys and the second column as the values.

=cut

sub colhash {
	my ($self, $qry) = @_;
	# select id, user from users
	my %list = map {$_->[0], $_->[1]} @{$self->dbh->selectall_arrayref($qry)};
	return %list;
}
#=========================================================#
=head2 value()
	
	# select email from users where id=123. return one column value
	$value = $self->me->db->value($qry);

Returns one column value from one row.

=cut

sub value {
	my ($self, $qry) = @_;
	# select email from users where id=123. return one column value
	my $ret = $self->dbh->selectcol_arrayref($qry);
	if (!defined($ret) && $self->dbh->err()) {$self->db_error($qry);}
	($ret) = @{$ret};
	return $ret;
}
#=========================================================#
=head2 insertid()
	
	$id = $self->me->db->insertid;

Returns the last insert id from auto increment.

=cut

sub insertid {
	my ($self) = @_;
	return $self->dbh->{mysql_insertid};
}
#=========================================================#
=head2 db_error()
	
	$self->me->db->db_error;

Aborts the application and display the last database error message.

=cut

sub db_error {
	my $self = shift;
	$self->me->abort("Database Error: $DBI::errstr<br>@_");
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
