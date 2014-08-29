#   Copyright Infomation
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Author : Dr. Ahmed Amin Elsheshtawy, Ph.D.
# Website: https://github.com/mewsoft/Nile, http://www.mewsoft.com
# Email  : mewsoft@cpan.org, support@mewsoft.com
# Copyrights (c) 2014-2015 Mewsoft Corp. All rights reserved.
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
package Nile::Plugin::Cache;

our $VERSION = '0.44';
our $AUTHORITY = 'cpan:MEWSOFT';

=pod

=encoding utf8

=head1 NAME

Nile::Plugin::Cache - Cache plugin for the Nile framework.

=head1 SYNOPSIS
    
    # save visitors count to the cache
    $app->cache->set("visitor_count", $app->cache->get("visitor_count") + 1, "1 year");

    # retrieve visitors count from the cache
    $view->set("visitor_count", $app->cache->get("visitor_count"));
        
=head1 DESCRIPTION
    
Nile::Plugin::Cache - Cache plugin for the Nile framework.

Plugin settings in th config file under C<plugin> section. The C<autoload> variable is must be set to true value for the plugin to be loaded
on application startup to setup hooks to work before actions dispatch:

    <plugin>

        <cache>
            <autoload>0</autoload>
            <driver>File</driver>
            <root_dir></root_dir>
            <namespace>cache</namespace>
        </cache>

    </plugin>

For DBI driver configuration example:

        <driver>DBI</driver>
        <namespace>cache</namespace>
        <table_prefix>cache_</table_prefix>
        <create_table>1</create_table>

The DBI create table example:

    CREATE TABLE <table_prefix><namespace> (
       `key` VARCHAR(...),
       `value` TEXT,
       PRIMARY KEY (`key`)
    )

The driver will try to create the table if you set C<create_table> in the config and table does not exist.

=cut

use Nile::Plugin; # also extends Nile::Plugin

use CHI;
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
=head2 cache()
    
    $app->cache();

Returns the L<CHI> cache object instance used. All L<CHI> methods can be accessed through this method.

=head2 get set compute remove expire is_valid add replace append clear purge get_keys exists_and_is_expired
    
    $app->cache->set($key, $data, "10 minutes");

    $value = $app->cache->get($key);

These methods are a proxy to the L<CHI> cache object methods. See L<CHI> for details about these methods.

=cut

has 'cache' => (
      is      => 'rw',
      lazy  => 1,
      #isa  => "CHI",
      default => undef,
      handles => [qw(get set compute remove expire is_valid add replace append clear purge get_keys exists_and_is_expired)],
  );
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
sub main { # our sub new {}

    my ($self, $arg) = @_;
    
    my $app = $self->app;
    my $setting = $self->setting();

    my $driver = $setting->{cache} || +{};

    $driver->{driver} ||= "File";
    $driver->{namespace} ||= "cache"; # default namespace is Default

    if (!$driver->{root_dir}) {
        $driver->{root_dir} = $app->file->catdir($app->var->get("cache_dir"), $driver->{namespace});
    }

    if ($driver->{driver} eq "DBI") {
        $driver->{dbh} = $app->dbh();
    }

    if (!$self->cache) {
        $self->cache(CHI->new(%{$driver}));
    }

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
