#	Copyright Infomation
#=========================================================#
#	Module	:	Nile::Request
#	Author		:	Dr. Ahmed Amin Elsheshtawy, Ph.D.
#	Website	:	https://github.com/mewsoft/Nile, http://www.mewsoft.com
#	Email		:	mewsoft@cpan.org, support@mewsoft.com
#	Copyrights (c) 2014-2015 Mewsoft Corp. All rights reserved.
#=========================================================#
package Nile::Request;

use Moose;
use MooseX::NonMoose;
extends 'CGI::Simple';

our $VERSION = '0.10';

#Methods: HEAD, POST, GET, PUT, DELETE, PATCH
#=========================================================#
sub is_ajax {
	(exists $ENV{HTTP_X_REQUESTED_WITH} && lc($ENV{HTTP_X_REQUESTED_WITH}) eq 'xmlhttprequest')? 1 : 0;
}
#=========================================================#
sub is_post {lc(shift->request_method) eq "post";}
sub is_get {lc(shift->request_method) eq "get";}
sub is_head {lc(shift->request_method) eq "head";}
sub is_put {lc(shift->request_method) eq "put";}
sub is_delete {lc(shift->request_method) eq "delete";}
sub is_patch {lc(shift->request_method) eq "patch";}
#=========================================================#

1;
