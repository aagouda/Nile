#	Copyright Infomation
#=========================================================#
#	Module	:	Nile::Declare
#	Author		:	Dr. Ahmed Amin Elsheshtawy, Ph.D.
#	Website	:	https://github.com/mewsoft/Nile, http://www.mewsoft.com
#	Email		:	mewsoft@cpan.org, support@mewsoft.com
#	Copyrights (c) 2014-2015 Mewsoft Corp. All rights reserved.
#=========================================================#
package Nile::Declare;

our $VERSION = '0.19';

use Moose;
extends 'MooseX::Declare';
	
	no warnings 'redefine';
	no strict 'refs';
	# disable the auto immutable feature of Moosex::Declare, or use class Nile::Home is mutable {...}
	*{"MooseX::Declare::Syntax::Keyword::Class" . '::' . "auto_make_immutable"} = sub { 0 };
	#around auto_make_immutable => sub { 0 };

1;
