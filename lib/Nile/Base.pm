#	Copyright Infomation
#=========================================================#
#	Module	:	Nile::Base
#	Author		:	Dr. Ahmed Amin Elsheshtawy, Ph.D.
#	Website	:	https://github.com/mewsoft/Nile, http://www.mewsoft.com
#	Email		:	mewsoft@cpan.org, support@mewsoft.com
#	Copyrights (c) 2014-2015 Mewsoft Corp. All rights reserved.
#=========================================================#
package Nile::Base;

use Moose;
#use MooseX::Declare;
use MooseX::MethodAttributes;
use utf8;
use Import::Into;
use Module::Runtime qw(use_module);

use Nile::Say;
use Nile::Declare ('method' => 'method', 'function' => 'function', 'invocant'=>'$this', 'inject'=>'my ($me) = $this->me;');

our @EXPORT_MODULES = (
		#strict => [],
		#warnings => [],
		Moose => [],
		utf8 => [],
		'Nile::Say' => [],
		'Nile::Declare' => ['method' => 'method', 'function' => 'function', 'invocant'=>'$self', 'inject'=>'my ($me) = $self->me;'],
		#'MooseX::Declare' => [],
		'MooseX::MethodAttributes' => [],
	);

sub import {
my ($class, %args) = @_;
	my $caller = caller;
	my @modules = @EXPORT_MODULES;
    while (@modules) {
        my $module = shift @modules;
        my $imports = ref $modules[0] eq 'ARRAY' ? shift @modules : [];
        use_module($module)->import::into($caller, @{$imports});
    }
}

1;