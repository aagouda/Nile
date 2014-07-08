#	Copyright Infomation
#=========================================================#
#	Module	:	Nile::Say
#	Author		:	Dr. Ahmed Amin Elsheshtawy, Ph.D.
#	Website	:	https://github.com/mewsoft/Nile, http://www.mewsoft.com
#	Email		:	mewsoft@cpan.org, support@mewsoft.com
#	Copyrights (c) 2014-2015 Mewsoft Corp. All rights reserved.
#=========================================================#
package Nile::Say;

use strict;
use warnings;
use IO::Handle;
use Scalar::Util 'openhandle';
use Carp;

our $VERSION = '1.0';

# modified code from Say::Compat
sub import {
    my $class = shift;
    my $caller = caller;

    if( $] < 5.010 ) {
        no strict 'refs';
		*{caller() . '::say'} = \&say; 
		use strict 'refs';
    }
    else {
        require feature;
        feature->import("say");
    }
}

# code from Perl6::Say
sub say {
    my $currfh = select();
    my $handle;
    {
        no strict 'refs';
        $handle = openhandle($_[0]) ? shift : \*$currfh;
        use strict 'refs';
    }
    @_ = $_ unless @_;
    my $warning;
    local $SIG{__WARN__} = sub { $warning = join q{}, @_ };
    my $res = print {$handle} @_, "\n";
    return $res if $res;
    $warning =~ s/[ ]at[ ].*//xms;
    croak $warning;
}

# Handle OO calls:
*IO::Handle::say = \&say if ! defined &IO::Handle::say;

1;
