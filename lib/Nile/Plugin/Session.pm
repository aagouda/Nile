#	Copyright Infomation
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#	Author		:	Dr. Ahmed Amin Elsheshtawy, Ph.D.
#	Website	:	https://github.com/mewsoft/Nile, http://www.mewsoft.com
#	Email		:	mewsoft@cpan.org, support@mewsoft.com
#	Copyrights (c) 2014-2015 Mewsoft Corp. All rights reserved.
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
package Nile::Plugin::Session;

our $VERSION = '0.41';
our $AUTHORITY = 'cpan:MEWSOFT';

=pod

=encoding utf8

=head1 NAME

Nile::Plugin::Session - Session manager plugin for the Nile framework.

=head1 SYNOPSIS
	
	use DateTime;

	# plugin session must be set to autoload in config.xml
	
	# save current username to session
	if (!$me->session->{username}) {
		$me->session->{username} = $username;
	}

	# get current username from session
	$username = $me->session->{username};
	
	# save time of the user first visit to session
	if (!$me->session->{first_visit}) {
		$me->session->{first_visit} = time;
	}

	my $dt = DateTime->from_epoch(epoch => $me->session->{first_visit});
	$view->set("first_visit", $dt->strftime("%a, %d %b %Y %H:%M:%S"));
		
=head1 DESCRIPTION
	
Nile::Plugin::Session - Session manager plugin for the Nile framework.

Plugin settings in th config file under C<plugin> section. The C<autoload> variable is must be set to true value for the plugin to be loaded
on application startup to setup hooks to work before actions dispatch.

This plugin uses the cache module L<CHI> for saving sessions. All drivers supported by the L<CHI> module are supported by this plugin.

	<plugin>

		<session>
			<autoload>1</autoload>
			<key>nile_session_key</key>
			<expire>1 year</expire>
			<driver>File</driver>
			<cookie>
				<path>/</path>
				<secure></secure>
				<domain></domain>
				<httponly></httponly>
			</cookie>
		</session>

	</plugin>

=cut

use Nile::Plugin; # also extends Nile::Plugin

use CHI;
use Digest::SHA;
use Time::HiRes ();
use Time::Duration::Parse;
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
=head2 cache()
	
	$me->plugin->session->cache();

Returns the cache L<CHI> object instance used by the session.

=cut

has 'cache' => (
      is      => 'rw',
	  lazy	=> 1,
	  default => undef
  );

=head2 id()
	
	$id = $me->plugin->session->id();
	$me->plugin->session->id($id);

Returns or sets the current session id. Session id's are auto generated.

=cut

has 'id' => (
      is      => 'rw',
	  lazy	=> 1,
	  default => undef
  );

=head2 sha_bits()
	
	# bits: 1= 40 bytes, 256=64 bytes, 512=128 bytes, 512224, 512256 
	$bits = $me->plugin->session->sha_bits();
	$bits = 1;
	$me->plugin->session->sha_bits($bits);

Returns or sets the current session id generator L<Digest::SHA> sha_bits.

=cut

has 'sha_bits' => (
      is      => 'rw',
	  lazy	=> 1,
	  default => 1, # bits: 1= 40 bytes, 256=64 bytes, 512=128 bytes, 512224, 512256 
  );

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
sub main { # our sub new {}

	my ($self, $arg) = @_;
	
	my $me = $self->me;
	my $setting = $self->setting();

	#$me->dump($setting);
	
	my %options;

	$setting->{key} ||= "nile_session_key";
	$setting->{sha_bits} ||= 1;
	$setting->{expire} ||= "1 year";

	$setting->{cookie}->{path} ||= "/";
	$setting->{cookie}->{domain} ||= "";
	$setting->{cookie}->{secure} ||= "";
	$setting->{cookie}->{httponly} ||= "";
	
	# convert human readable time to seconds
	$setting->{expire} = parse_duration($setting->{expire});

	$self->sha_bits($setting->{sha_bits});

	$options{driver} = ($setting->{driver} || "File");

	if (!$options{root_dir}) {
		$options{root_dir} = $me->file->catdir($me->var->get("cache_dir"), "session");
	}
		
	if (!$self->cache) {
		$self->cache(CHI->new(%options));
	}

	# load session data after loading request
	$me->hook->after_request(sub {
		my ($me, @args) = @_;
		
		if (!$self->id) {
			$self->id($me->request->cookie($setting->{key}) || $me->request->param($setting->{key}) || undef);
		}
		
		if ($self->id) {
			$me->session($self->cache->get($self->id) || +{});
		}
		else {
			$me->session(+{});
		}

		#$me->dump($me->session);
	});
	
	# save session data, write session headers etc
	$me->hook->before_response(sub {
		my ($me, @args) = @_;
		
		#$cache->set( $name, $customer, "10 minutes" );
		# do not save empty sessions;
		return if (!$me->session);
		
		# create new session and save it
		if (!$self->id) {
			$self->id($self->new_id());
			$self->cache->set($self->id(), +{});

			$me->response->cookies->{$setting->{key}} = {
				value => $self->id(),
				expires => time + $setting->{expire},
				path  => $setting->{cookie}->{path},
				domain  => $setting->{cookie}->{domain},
				secure  => $setting->{cookie}->{secure},
				httponly  => $setting->{cookie}->{httponly},
			};
		}

		$self->cache->set($self->id, $me->session, $setting->{expire});
	});

}
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
sub new_id {
	my ($self) = @_;
	my ($sec, $ms) = Time::HiRes::gettimeofday;
	my $rand = sprintf("%.f", $$ * (+{}) * $ms * rand());
	# bits: 1= 40 bytes, 256=64 bytes, 512=128 bytes, 512224, 512256 
	return Digest::SHA->new($self->sha_bits())->add($rand)->hexdigest();
}
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
=head2 purge()
	
	$me->plugin->session->purge();

Remove all sessions that have expired from the cache. Warning: May be very inefficient, depending on the number of keys and the driver.

=cut

sub purge {
	my ($self) = @_;
	$self->cache->purge();
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
