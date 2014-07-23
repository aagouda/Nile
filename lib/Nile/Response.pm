#	Copyright Infomation
#=========================================================#
#	Module	:	Nile::Response
#	Author		:	Dr. Ahmed Amin Elsheshtawy, Ph.D.
#	Website	:	https://github.com/mewsoft/Nile, http://www.mewsoft.com
#	Email		:	mewsoft@cpan.org, support@mewsoft.com
#	Copyrights (c) 2014-2015 Mewsoft Corp. All rights reserved.
#=========================================================#
package Nile::Response;

our $VERSION = '0.26';

=pod

=encoding utf8

=head1 NAME

Nile::Response -  The HTTP response manager.

=head1 SYNOPSIS

	# get response instance
	$res = $app->response;

	$res->code(200);
	$res->content_type('text/html');
	$res->body("Hello World");

	 $response = $res->response;
	 # [$code, $headers, $body]

=head1 DESCRIPTION

Nile::Response - The HTTP response manager allows you to create PSGI response array ref.

=cut

use Nile::Base;
use Scalar::Util ();
use HTTP::Headers;
use URI::Escape ();
#=========================================================#
sub BUILD {
	my ($self, $args) = @_;
	my ($code, $headers, $content) = %$args;
	$self->status($code) if defined $code;
    $self->headers($headers) if defined $headers;
    $self->body($content) if defined $content;
}
#=========================================================#
=item headers

  $headers = $res->headers;
  $res->headers([ 'Content-Type' => 'text/html' ]);
  $res->headers({ 'Content-Type' => 'text/html' });
  $res->headers( HTTP::Headers->new );

Sets and gets HTTP headers of the response. Setter can take either an
array ref, a hash ref or L<HTTP::Headers> object containing a list of
headers.

=cut

sub headers {

	my $self = shift;

	if (@_) {
		my $headers = shift;
		if (ref $headers eq 'ARRAY') {
			Carp::carp("Odd number of headers") if @$headers % 2 != 0;
			$headers = HTTP::Headers->new(@$headers);
		}
		elsif (ref $headers eq 'HASH') {
			$headers = HTTP::Headers->new(%$headers);
		}
		return $self->{headers} = $headers;
	}
	else {
		return $self->{headers} ||= HTTP::Headers->new();
	}
}
#=========================================================#
=item header

  $res->header('X-Foo' => 'bar');
  my $val = $res->header('X-Foo');

Sets and gets HTTP header of the response.

=cut

sub header { shift->headers->header(@_) }
#=========================================================#
=item status

  $res->status(200);
  $status = $res->status;

Sets and gets HTTP status code. C<code> is an alias.

=cut

has status => (is => 'rw');
sub code    { shift->status(@_) }
#=========================================================#
=item body

  $res->body($body_str);
  $res->body([ "Hello", "World" ]);
  $res->body($io);

Gets and sets HTTP response body. Setter can take either a string, an
array ref, or an IO::Handle-like object. C<content> is an alias.

Note that this method doesn't automatically set I<Content-Length> for
the response. You have to set it manually if you want, with the
C<content_length> method.

=cut

has body => (is => 'rw');
sub content { shift->body(@_) }
#=========================================================#
=item cookies

	$res->cookies->{name} = 123;
	$res->cookies->{name} = {value => '123'};

Returns a hash reference containing cookies to be set in the
response. The keys of the hash are the cookies' names, and their
corresponding values are a plain string (for C<value> with everything
else defaults) or a hash reference that can contain keys such as
C<value>, C<domain>, C<expires>, C<path>, C<httponly>, C<secure>,
C<max-age>.

C<expires> can take a string or an integer (as an epoch time) and
B<does not> convert string formats such as C<+3M>.

	$res->cookies->{name} = {
		value => 'test',
		path  => "/",
		domain => '.example.com',
		expires => time + 24 * 60 * 60,
	};

=cut

has cookies => (is => 'rw', isa => 'HashRef', default => sub {+{}});
#=========================================================#
=item content_length

  $res->content_length(123);

A decimal number indicating the size in bytes of the message content.
Shortcut for the equivalent get/set method in C<< $res->headers >>.

=cut

sub content_length {shift->headers->content_length(@_)}
#=========================================================#
=item content_type

  $res->content_type('text/plain');

The Content-Type header field indicates the media type of the message content.
Shortcut for the equivalent get/set method in C<< $res->headers >>.

=cut

sub content_type {shift->headers->content_type(@_)}
#=========================================================#
=item content_encoding

  $res->content_encoding('gzip');

Shortcut for the equivalent get/set method in C<< $res->headers >>.

=cut

sub content_encoding {shift->headers->content_encoding(@_)}
#=========================================================#
=item location

Gets and sets C<Location> header.

Note that this method doesn't normalize the given URI string in the
setter.

=cut

sub location {shift->headers->header('Location' => @_)}
#=========================================================#
=item redirect

  $res->redirect($url);
  $res->redirect($url, 301);

Sets redirect URL with an optional status code, which defaults to 302.

Note that this method doesn't normalize the given URI string. Users of
this module have to be responsible about properly encoding URI paths
and parameters.

=cut

sub redirect {

    my $self = shift;

    if (@_) {
        my $url = shift;
        my $status = shift || 302;
        $self->location($url);
        $self->status($status);
    }

    return $self->location;
}
#=========================================================#
=item response

	$res->response;
	# [$code, \@headers, $body]

Returns the status code, headers, and body of this response as a PSGI response array reference.

=cut

sub response {

	my $self = shift;
	
	$self->status || $self->status(200);

	my $headers = $self->headers;

	my @headers;

	$headers->scan(sub{
	my ($k, $v) = @_;
		$v =~ s/\015\012[\040|\011]+/chr(32)/ge; # replace LWS with a single SP
		$v =~ s/\015|\012//g; # remove CR and LF since the char is invalid here
		push @headers, $k, $v;
	});

	$self->build_cookies(\@headers);

	return [$self->status, \@headers, $self->build_body];
}
#=========================================================#
=item to_app

  $app = $res->to_app;

A helper shortcut for C<< sub { $res->response } >>.

=cut

sub to_app {sub {shift->response}}
#=========================================================#
sub build_body {

	my $self = shift;

	my $body = $self->body;

	$body = [] unless defined $body;

	if (!ref $body or Scalar::Util::blessed($body) && overload::Method($body, q("")) && !$body->can('getline')) {
		return [$body];
	} else {
		return $body;
	}
}

sub build_cookies {
    my($self, $headers) = @_;
	while (my($name, $val) = each %{$self->cookies}) {
        my $cookie = $self->build_cookie($name, $val);
        push @$headers, 'Set-Cookie' => $cookie;
    }
}

sub build_cookie {

    my($self, $name, $val) = @_;

    return '' unless defined $val;

    $val = {value => $val} unless ref $val eq 'HASH';

    my @cookie = (URI::Escape::uri_escape($name) . "=" . URI::Escape::uri_escape($val->{value}));

    push @cookie, "domain=" . $val->{domain}   if $val->{domain};
    push @cookie, "path=" . $val->{path}       if $val->{path};
    push @cookie, "expires=" . $self->cookie_date($val->{expires}) if $val->{expires};
    push @cookie, "max-age=" . $val->{"max-age"} if $val->{"max-age"};
    push @cookie, "secure"                     if $val->{secure};
    push @cookie, "HttpOnly"                   if $val->{httponly};

    return join "; ", @cookie;
}

my @MON  = qw(Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec);
my @WDAY = qw(Sun Mon Tue Wed Thu Fri Sat);

sub cookie_date {

    my($self, $expires) = @_;

    if ($expires =~ /^\d+$/) {
        my($sec, $min, $hour, $mday, $mon, $year, $wday) = gmtime($expires);
        $year += 1900;

        return sprintf("%s, %02d-%s-%04d %02d:%02d:%02d GMT",
                       $WDAY[$wday], $mday, $MON[$mon], $year, $hour, $min, $sec);

    }

    return $expires;
}
#=========================================================#

has 'http_codes' => (
						is => 'rw',
						isa => 'HashRef',
						default =>  sub { +{
						# informational
						# 100 => 'Continue', # only on HTTP 1.1
						# 101 => 'Switching Protocols', # only on HTTP 1.1

						# processed codes
						200 => 'OK',
						201 => 'Created',
						202 => 'Accepted',

						# 203 => 'Non-Authoritative Information', # only on HTTP 1.1
						204 => 'No Content',
						205 => 'Reset Content',
						206 => 'Partial Content',

						# redirections
						301 => 'Moved Permanently',
						302 => 'Found',

						# 303 => '303 See Other', # only on HTTP 1.1
						304 => 'Not Modified',

						# 305 => '305 Use Proxy', # only on HTTP 1.1
						306 => 'Switch Proxy',

						# 307 => '307 Temporary Redirect', # on HTTP 1.1

						# problems with request
						400 => 'Bad Request',
						401 => 'Unauthorized',
						402 => 'Payment Required',
						403 => 'Forbidden',
						404 => 'Not Found',
						405 => 'Method Not Allowed',
						406 => 'Not Acceptable',
						407 => 'Proxy Authentication Required',
						408 => 'Request Timeout',
						409 => 'Conflict',
						410 => 'Gone',
						411 => 'Length Required',
						412 => 'Precondition Failed',
						413 => 'Request Entity Too Large',
						414 => 'Request-URI Too Long',
						415 => 'Unsupported Media Type',
						416 => 'Requested Range Not Satisfiable',
						417 => 'Expectation Failed',

						# problems with server
						500 => 'Internal Server Error',
						501 => 'Not Implemented',
						502 => 'Bad Gateway',
						503 => 'Service Unavailable',
						504 => 'Gateway Timeout',
						505 => 'HTTP Version Not Supported',
	}});
#=========================================================#
sub object {
	my $self = shift;
	$self->me->object(__PACKAGE__, @_);
}
#=========================================================#

=pod

=head1 Bugs

This project is available on github at L<https://github.com/mewsoft/Nile>.

=head1 HOMEPAGE

Please visit the project's homepage at L<https://metacpan.org/release/Nile>.

=head1 SOURCE

Source repository is at L<https://github.com/mewsoft/Nile>.

=head1 ACKNOWLEDGMENT

This module is based on L<Plack::Response>

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
