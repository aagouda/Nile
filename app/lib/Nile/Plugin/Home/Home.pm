#	Copyright Infomation
#=========================================================#
#	Module	:	Nile::Plugin::Home::Home
#	Author		:	Dr. Ahmed Amin Elsheshtawy, Ph.D.
#	Website	:	https://github.com/mewsoft/Nile, http://www.mewsoft.com
#	Email		:	mewsoft@cpan.org, support@mewsoft.com
#	Copyrights (c) 2014-2015 Mewsoft Corp. All rights reserved.
#=========================================================#
package Nile::Plugin::Home::Home;

use Nile::Base;
#=========================================================#
sub home  : GET Action {
	
	my ($self) = @_;

	my $view = $self->me->view("home");
	
	$view->var(
			fname			=>	'Ahmed',
			lname			=>	'Elsheshtawy',
			email			=>	'sales@mewsoft.com',
			website		=>	'http://www.mewsoft.com',
			singleline		=>	'Single line variable <b>Good</b>',
			multiline		=>	'Multi line variable <b>Nice</b>',
		);

	$view->process;
	$view->render;
}
#=========================================================#

1;