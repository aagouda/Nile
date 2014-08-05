#	Copyright Infomation
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#	Author		:	Dr. Ahmed Amin Elsheshtawy, Ph.D.
#	Website	:	https://github.com/mewsoft/Nile, http://www.mewsoft.com
#	Email		:	mewsoft@cpan.org, support@mewsoft.com
#	Copyrights (c) 2014-2015 Mewsoft Corp. All rights reserved.
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
package Nile::Helper;

our $VERSION = '0.34';

=pod

=encoding utf8

=head1 NAME

Nile::Helper - Helpers base class for the Nile framework.

=head1 SYNOPSIS
		
=head1 DESCRIPTION

Nile::Helper - Helpers base class for the Nile framework.

=cut

use Nile::Base;
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
use Moose;

use Import::Into;
use Module::Runtime qw(use_module);

our @EXPORT_MODULES = (
		Moose => [],
	);
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
sub import {

	my ($class, @args) = @_;

	my ($caller, $script) = caller;

	my $package = __PACKAGE__;
	
	# ignore calling from child import
	return if ($class ne $package);

	my @modules = @EXPORT_MODULES;

	while (@modules) {
		my $module = shift @modules;
		my $imports = ref($modules[0]) eq 'ARRAY' ? shift @modules : [];
		use_module($module)->import::into($caller, @{$imports});
	}

	{
		no strict 'refs';
		@{"${caller}::ISA"} = ($package, @{"${caller}::ISA"});
	}

}
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
=head2 setting()
	
	# inside helper classes, return current helper class config settings
	my $setting = $self->setting();
	my %setting = $self->setting();

	# 
	# inside helper classes, return specific helper class config settings
	my $setting = $self->setting("email");
	my %setting = $self->setting("email");

Returns helper class settings from configuration files loaded.

Helper class settings in config files must be in inside the helper tag. The helper class name must be lower case tag, so class C<Email> should be C<email>.

Exampler settings for C<email> helper class below:

	<helper>
		<email>
			<smtp>localhost</smtp>
			<user>webmaster</user>
			<pass>1234</pass>
		</email>
	</helper>

=cut

sub setting {
	my ($self, $helper) = @_;

	$helper ||= caller();
	$helper =~ s/^(.*):://;
	$helper = lc($helper);

	return wantarray ? %{ $self->me->config->var->{helper}->{$helper} } : $self->me->config->var->{helper}->{$helper};
}
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

=pod

=head1 Bugs

This project is available on github at L<https://github.com/mewsoft/Nile>.

=head1 HOMEPAGE

Please visit the project's homepage at L<https://metacpan.org/release/Nile>.

=head1 SOURCE

Source repository is at L<https://github.com/mewsoft/Nile>.

=head1 SEE ALSO

See L<Nile> for details about the complete framework.

=head1 AUTHOR

Ahmed Amin Elsheshtawy,  احمد امين الششتاوى <mewsoft@cpan.org>
Website: http://www.mewsoft.com

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2014-2015 by Dr. Ahmed Amin Elsheshtawy احمد امين الششتاوى mewsoft@cpan.org, support@mewsoft.com,
L<https://github.com/mewsoft/Nile>, L<http://www.mewsoft.com>

This library is free software; you can redistribute it and/or modify it under the same terms as Perl itself.

=cut

1;
