#	Copyright Infomation
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#	Author		:	Dr. Ahmed Amin Elsheshtawy, Ph.D.
#	Website	:	https://github.com/mewsoft/Nile, http://www.mewsoft.com
#	Email		:	mewsoft@cpan.org, support@mewsoft.com
#	Copyrights (c) 2014-2015 Mewsoft Corp. All rights reserved.
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
package Nile::Plugin::Cache;

our $VERSION = '0.40';

=pod

=encoding utf8

=head1 NAME

Nile::Plugin::Cache - Cache plugin for the Nile framework.

=head1 SYNOPSIS
	
	# TODO
		
=head1 DESCRIPTION
	
Nile::Plugin::Cache - Cache plugin for the Nile framework.


Plugin settings in th config file under C<plugin> section. The C<autoload> variable is set to true value for the plugin to be loaded
on application startup to setup hooks to work before actions dispatch:

	<plugin>

		<cache>
			<autoload>1</autoload>
		</cache>

	</plugin>


=cut

use Nile::Plugin; # also extends Nile::Plugin
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
sub main { # our sub new {}

	my ($self, $arg) = @_;
	
	my $setting = $self->setting();
	
	my $me = $self->me;
	
	# add the hooks you want here

	$me->hook->before_start(sub {
		my ($me, @args) = @_;
	});

	$me->hook->after_start(sub {
		my ($me, @args) = @_;
	});

	$me->hook->before_request(sub {
		my ($me, @args) = @_;
	});
	
	#say "loaded Cache plugin";

}
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

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
