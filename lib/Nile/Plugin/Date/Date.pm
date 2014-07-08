#	Copyright Infomation
#=========================================================#
#	Module	:	Nile::Plugin::Date::Date
#	Author		:	Dr. Ahmed Amin Elsheshtawy, Ph.D.
#	Website	:	https://github.com/mewsoft/Nile, http://www.mewsoft.com
#	Email		:	mewsoft@cpan.org, support@mewsoft.com
#	Copyrights (c) 2014-2015 Mewsoft Corp. All rights reserved.
#=========================================================#
package Nile::Plugin::Date::Date;

use Nile::Base;
use DateTime qw();

#=========================================================#
sub indexx {
my ($self, %args) = @_;
	my $dt = DateTime->now;
	print $dt->strftime($args{format});
}
#=========================================================#
sub date {
	my ($self, %args) = @_;
	my $dt = DateTime->now;
	print $dt->strftime($args{format});
}
#=========================================================#
sub now {
	my ($self, %args) = @_;
	my $dt = DateTime->now;
	print $dt->strftime($args{format});
}
#=========================================================#

1;