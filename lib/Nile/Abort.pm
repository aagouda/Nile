#	Copyright Infomation
#=========================================================#
#	Module	:	Nile::Abort
#	Author		:	Dr. Ahmed Amin Elsheshtawy, Ph.D.
#	Website	:	https://github.com/mewsoft/Nile, http://www.mewsoft.com
#	Email		:	mewsoft@cpan.org, support@mewsoft.com
#	Copyrights (c) 2014-2015 Mewsoft Corp. All rights reserved.
#=========================================================#
package Nile::Abort;
#=========================================================#
use Carp;# qw(croak shortmess longmess);
use utf8;

our $VERSION = '0.10';
#=========================================================#
sub abort {
	my ($self) = shift;
	my ($title, $msg, $trace, @trace);

	if (@_ == 2) {
		($title, $msg) = @_;
	}
	else {
		($msg) = @_;
		$title = "Application Error";
	}
	
	@trace = reverse split(/\n/, Carp::longmess());
	$trace = join ("<br>\n", @trace);
	#$msg =~ s/\n/\<br\>\n/g;

my $out = <<HTML;
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>Application Error</title>
</head>
<body style="background: #ffffff;" >

<div align="center" style="margin-top: 100px;">
	<table cellpadding="0" cellspacing="0" style="width: 650px; border: 2px #e5e5e5 solid; border-collapse: collapse;">
	  <tr><td>
			<table border="0" cellpadding="8" cellspacing="0" style="border-collapse: collapse" width="100%">
			  <tr><td style="text-align: center; background: #e5e5e5;"><b>$title</b></td></tr>
			  <tr><td style="background: #f3f3f3;">$msg</td></tr>
			  <tr><td style="background: #f9f9f9;">$trace</td></tr>
			</table>
		</td>
	  </tr>
	</table>
</div>
</body>
</html>
HTML

	#header();
	print "$out";
	#if ($self->me->db->connected) {$self->me->db->disconnect();}
	exit 0;	
}
#=========================================================#
1;