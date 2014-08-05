#	Copyright Infomation
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#	Author		:	Dr. Ahmed Amin Elsheshtawy, Ph.D.
#	Website	:	https://github.com/mewsoft/Nile, http://www.mewsoft.com
#	Email		:	mewsoft@cpan.org, support@mewsoft.com
#	Copyrights (c) 2014-2015 Mewsoft Corp. All rights reserved.
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
package Nile::Plugin;

our $VERSION = '0.34';

=pod

=encoding utf8

=head1 NAME

Nile::Plugin - Plugins base class for the Nile framework.

=head1 SYNOPSIS

	package Nile::Plugin::Home::Home;

	use Nile::Plugin; # automatically extends Nile::Plugin
	
=head1 DESCRIPTION

Nile::Plugin - Plugins base class for the Nile framework.

=cut

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
use utf8;
use Moose;
use Nile::Say;

use Import::Into;
use Module::Runtime qw(use_module);
use MooseX::MethodAttributes;

our @EXPORT_MODULES = (
		Moose => [],
		utf8 => [],
		'Nile::Say' => [],
		'MooseX::MethodAttributes' => [],
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
	
	# inside plugins, return current plugin config settings
	my $setting = $self->setting();
	my %setting = $self->setting();

	# inside plugins, return specific plugin config settings
	my $setting = $self->setting("payment");
	my %setting = $self->setting("payment");

Returns plugin class settings from configuration files loaded.
Plugin class settings in config files must be in inside the plugin tag. The plugin class name must be lower case tag, so class C<Payment> should be C<payment>.

Exampler settings for C<payment> plugin class below:

	<plugin>
		<payment>
			<url>localhost</url>
			<user>merchant</user>
			<pass>1234</pass>
		</payment>
	</plugin>

=cut

sub setting {
	my ($self, $plugin) = @_;

	$plugin ||= caller();
	$plugin =~ s/^(.*):://;
	$plugin = lc($plugin);

	return wantarray ? %{ $self->me->config->var->{plugin}->{$plugin} } : $self->me->config->var->{plugin}->{$plugin};
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
