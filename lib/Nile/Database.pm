#	Copyright Infomation
#=========================================================#
#	Module	:	Nile::Database
#	Author		:	Dr. Ahmed Amin Elsheshtawy, Ph.D.
#	Website	:	https://github.com/mewsoft/Nile, http://www.mewsoft.com
#	Email		:	mewsoft@cpan.org, support@mewsoft.com
#	Copyrights (c) 2014-2015 Mewsoft Corp. All rights reserved.
#=========================================================#
package Nile::Database;

use Nile::Base;
use Hash::AsObject;
#my $hash = Hash::AsObject->new(\%hash); $hash->foo(27); print $hash->foo; print $hash->baz->quux;

use DBI;

our $VERSION = '0.10';
#=========================================================#
has 'dbh' => (
      is      => 'rw',
  );
#=========================================================#
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
	$args{attr} ||= {};

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
sub disconnect {
	my ($self) = @_;
	$self->dbh->disconnect if ($self->dbh);
}
#=========================================================#
sub run {
	my ($self, $qry) = @_;
	$self->dbh->do($qry) or $self->db_error($qry);
}
#=========================================================#
sub do {
	my ($self, $qry) = @_;
	$self->dbh->do($qry);
}
#=========================================================#
sub exec {
	my ($self, $qry) = @_;
	my $sth = $self->dbh->prepare($qry) or $self->db_error($qry);
	$sth->execute() or $self->db_error($qry);
	return $sth;
}
#=========================================================#
sub begin_work {
	my ($self) = @_;
	return $self->dbh->begin_work or $self->db_error();
}
#=========================================================#
sub commit {
	my ($self) = @_;
	$self->dbh->commit or $self->db_error();
}
#=========================================================#
sub rollback {
	my ($self) = @_;
	$self->dbh->rollback or $self->db_error();
}
#=========================================================#
sub quote {
	my ($self, @args) = @_;
	return $self->dbh->quote(@args);
}
#=========================================================#
sub escape {
	my ($self, @args) = @_;
	return $self->dbh->quote(@args);
}
#=========================================================#
sub col {
	my ($self, $qry) = @_;
	#	select id from users. return one column array from all rows
	my $ret = $self->dbh->selectcol_arrayref($qry);
	if (!defined($ret) && $self->dbh->err()) {$self->db_error($qry);}
	return wantarray? @{$ret} : $ret;
}
#=========================================================#
sub row {
	my ($self, $qry) = @_;
	#	select id, email, fname, lname from users
	my @ret = $self->dbh->selectrow_array($qry);
	if (!@ret && $self->dbh->err()) {$self->db_error($qry);}
	return @ret;
}
#=========================================================#
sub rows {
	my ($self, $qry) = @_;
	#select id, fname, lname, email from users
	my $ret = $self->dbh->selectall_arrayref($qry);
	if (!defined($ret) && $self->dbh->err()) {$self->db_error($qry);}
	return wantarray? @$ret : $ret;
}
#=========================================================#
sub hash {
	my ($self, $qry) = @_;
	#select * from users where id=$id limit 1
	my $ret = $self->dbh->selectrow_hashref($qry);
	if (!defined($ret) && $self->dbh->err()) {$self->db_error($qry);}
	return wantarray? %{$ret} : $ret;
}
#=========================================================#
sub row_object {
	my ($self, $qry) = @_;
	#select * from users where id=$id limit 1
	my $ret = $self->dbh->selectrow_hashref($qry);
	if (!defined($ret) && $self->dbh->err()) {$self->db_error($qry);}
	return Hash::AsObject->new($ret);
}
#=========================================================#
sub hashes {
	my ($self, $qry, $col) = @_;
	my $ret = $self->dbh->selectall_hashref($qry, $col);
	if (!defined($ret) && $self->dbh->err()) {$self->db_error($qry);}
	return wantarray? %{$ret} : $ret;
}
#=========================================================#
sub colhash {
	my ($self, $qry) = @_;
	#select id, user from users
	my %list = map {$_->[0], $_->[1]} @{$self->dbh->selectall_arrayref($qry)};
	return %list;
}
#=========================================================#
sub value {
	my ($self, $qry) = @_;
	# select email from users where id=123. return one column value
	my $ret = $self->dbh->selectcol_arrayref($qry);
	if (!defined($ret) && $self->dbh->err()) {$self->db_error($qry);}
	($ret) = @{$ret};
	return $ret;
}
#=========================================================#
sub insertid {
	my ($self) = @_;
	return $self->dbh->{mysql_insertid};
}
#=========================================================#
sub db_error {
	my $self = shift;
	$self->me->abort("Database Error: $DBI::errstr<br>@_");
}
#=========================================================#

1;