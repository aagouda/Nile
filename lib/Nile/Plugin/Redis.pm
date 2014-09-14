#   Copyright Infomation
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Author : Dr. Ahmed Amin Elsheshtawy, Ph.D.
# Website: https://github.com/mewsoft/Nile, http://www.mewsoft.com
# Email  : mewsoft@cpan.org, support@mewsoft.com
# Copyrights (c) 2014-2015 Mewsoft Corp. All rights reserved.
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
package Nile::Plugin::Redis;

our $VERSION = '0.49';
our $AUTHORITY = 'cpan:MEWSOFT';

=pod

=encoding utf8

=head1 NAME

Nile::Plugin::Redis - Redis database server plugin for the Nile framework.

=head1 SYNOPSIS
    
    # connect to Redis server
    my $redis = $app->plugin->redis;
    
    # store some data
    $redis->set("Name"=>"Ahmed Amin Elsheshtawy Gouda");

    # get some data
    my $name = $redis->get("Name");
    
    # check some data if exists
    if ($redis->exists("Name")) {say "Exists"}

    # delete some data
    $redis->del("Name");

=head1 DESCRIPTION
    
Nile::Plugin::Redis - Redis database server plugin for the Nile framework.

This module supports L<Redis> databases. All methods of the L<Redis> module are supported.

Plugin settings in th config file under C<plugin> section.

    <plugin>

        <redis>
            <server>localhost:6379</server>
            <sock></sock>
            <password></password>
            <name></name>
            <reconnect>60</reconnect>
            <every>1000000</every>
            <encoding></encoding>
        </redis>

    </plugin>

=cut

use Nile::Plugin;
use Redis;
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
has 'redis' => (
      is      => 'rw',
      lazy  => 1,
      isa  => "Redis",
      default => undef,
      #default => sub {Redis->new},
      #handles => qr/.*/,
      handles => [qw(
                    connect quit ping client_list client_getname client_setname 
                    wait_all_responses wait_one_response 
                    multi discard exec 
                    set get mget incr decr exists del type
                    keys randomkey rename dbsize 
                    rpush lpush llen lrange ltrim lindex lset lrem lpop rpop 
                    sadd scard sdiff sdiffstore sinter sinterstore sismember smembers smove
                    spop srandmemeber srem sunion sunionstore
                    hset hget hexists hdel hincrby hsetnx hmset hmget hgetall hkeys hvals hlen
                    sort
                    publish subscribe unsubscribe psubscribe punsubscribe is_subscriber wait_for_messages
                    save bgsave lastsave
                    eval evalsha script_load script_exists script_kill script_flush
                    info shutdown slowlog
                    select move flushdb flushall 
                   )],
  );

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
sub main {

    my ($self, $arg) = @_;
    
    my $app = $self->app;
    my $setting = $self->setting();

    $self->redis(Redis->new(%{$setting}));
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
