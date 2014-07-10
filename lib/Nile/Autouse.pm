#	Copyright Infomation
#=========================================================#
#	Module	:	Nile::Autouse
#	Author		:	Dr. Ahmed Amin Elsheshtawy, Ph.D.
#	Website	:	https://github.com/mewsoft/Nile, http://www.mewsoft.com
#	Email		:	mewsoft@cpan.org, support@mewsoft.com
#	Copyrights (c) 2014-2015 Mewsoft Corp. All rights reserved.
#=========================================================#
package Nile::Autouse;

our $VERSION = '0.11';

=head1 NAME

Nile::Autouse - Load classes automatically

=head1 SYNOPSIS

    use Nile::Autouse;
    
    my $obj = My::Class->new; # loads My/Class.pm

=head1 DESCRIPTION

Nile::Autouse Run-time load a class the first time you call a method in it.

=cut
#=========================================================#
use strict;
use warnings;
use Carp qw(confess);
use utf8;

our $VERSION = 1.00;

unshift @UNIVERSAL::ISA, 'Nile::Autouse';

sub AUTOLOAD {
my ($self) = shift;
	
    my ($class, $sub) = our $AUTOLOAD =~ /^(.*)::(\w+)$/;
    return if $sub !~ /[^A-Z]/;
	
	#print "Autouse loading class: $class \n";

    eval "use $class";
    
	if ($@) {
		#my ($callpackage, $callfile, $callline) = caller;
		confess($@);
    }

    unless ($self->can($sub)) {
		confess("Method \'$class\-\>$sub\' does not exist. ");
    }
    return $self->$sub(@_);
	#goto &$sub;
}

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
