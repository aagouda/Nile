#	Copyright Infomation
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#	Author		:	Dr. Ahmed Amin Elsheshtawy, Ph.D.
#	Website	:	https://github.com/mewsoft/Nile, http://www.mewsoft.com
#	Email		:	mewsoft@cpan.org, support@mewsoft.com
#	Copyrights (c) 2014-2015 Mewsoft Corp. All rights reserved.
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
package Nile::Handler::PSGI;

our $VERSION = '0.33';

=pod

=encoding utf8

=head1 NAME

Nile::Handler::PSGI - PSGI Handler.

=head1 SYNOPSIS

	# run the app in PSGI mode and return the PSGI closure subroutine
	my $psgi = $app->object("Nile::Handler::PSGI")->run();
		
=head1 DESCRIPTION

Nile::Handler::PSGI - PSGI Handler.

=cut

use Nile::Base;
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
sub run {
	
	my ($self) = shift;

	my $me = $self->me;
	#$me->log->debug("PSGI app handler start");

	# PSGI mode. PSGI app will loop inside this closure, so reset any user session shared data inside it.
	my $psgi = sub {

		my $env = shift;

		my $me = $self->me;
		
		#$me->start_logger;
		#$me->log->debug("PSGI request start");

		$me->env($env);
		
		#*ENV = $env;
		 #%ENV = %$env;
		#----------------------------------------------
		$me->new_request($env);
		my $request = $me->request;

		$me->response($me->object("Nile::HTTP::Response"));
		my $response = $me->response;

		$me->start;
		#----------------------------------------------
		my $path = $me->env->{PATH_INFO} || $me->env->{REQUEST_URI};
		
		$path = $me->file->catfile($me->var->get("path"), $path);

		if (-f $path) {
			# file response: /favicon.ico
			$response->file_response($path);
			$me->stop_logger;
			return $response->finalize;
		}
		#--------------------------------------------------
		# dispatch the action
		my $content = $me->dispatcher->dispatch;
		#--------------------------------------------------
		my $ctype = $response->header('Content-Type');
		if ($me->charset && $ctype && $me->content_type_text($ctype)) {
			$response->header('Content-Type' => "$ctype; charset=" . $me->charset) if $ctype !~ /charset/i;
		}

		$response->content($content);

		if (!$ctype) {
			$response->content_type('text/html;charset=' . $me->charset || "utf-8");
		}

		if (!defined $response->header('Content-Length')) {
			use bytes; # turn off character semantics
			$response->header('Content-Length' => length($content));
		}

		#$response->code(200) unless ($response->code);
		#$response->content_type('text/html') unless ($response->content_type);
		
		#$response->content_encoding('gzip');
		#$response->cookies->{username} = {value => 'mewsoft', path  => "/", domain => '.mewsoft.com', expires => time + 24 * 60 * 60,};
		#$response->header(Content_Base => 'http://www.mewsoft.com/');
		#$response->header(Accept => "text/html, text/plain, image/*");
		#$response->header(MIME_Version => '1.0', User_Agent   => 'Nile Web Client/0.26');
		#$response->content("Hello world content.");

		$response->content($content);
		
		#$me->log->debug("PSGI request end");
		$me->stop_logger;

		# return the PSGI response array ref
		return $response->finalize;
	};
	
	#$me->log->debug("PSGI app handler return");
	$me->stop_logger;
	return $psgi;
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
