package Catalyst::TraitFor::Model::DBIC::Schema::QueryLog;

# ABSTRACT: L<DBIx::Class::QueryLog> support for L<Catalyst::Model::DBIC::Schema>

use namespace::autoclean;
use Moose::Role;
use Carp::Clan '^Catalyst::Model::DBIC::Schema';
use DBIx::Class::QueryLog;
use DBIx::Class::QueryLog::Analyzer;

=pod

=head1 SYNOPSIS
 
    __PACKAGE__->config({
        traits => ['QueryLog']
        connect_info => 
            ['dbi:mysql:master', 'user', 'pass'],
    });

=head1 DESCRIPTION

check L<Catalyst::Model::DBIC::Schema> for more details

=cut

has 'querylog' => (
    is => 'rw',
    isa => 'DBIx::Class::QueryLog',
);
has 'querylog_analyzer' => (
    is => 'rw',
    isa => 'DBIx::Class::QueryLog::Analyzer',
    lazy_build => 1
);
sub _build_querylog_analyzer {
    my $self = shift;
    
    return DBIx::Class::QueryLog::Analyzer->new({ querylog => $self->querylog });
}

before ACCEPT_CONTEXT => sub {
    my ($self, $c) = @_;

    my $schema = $self->schema;
    
    my $querylog = DBIx::Class::QueryLog->new();
    $self->querylog($querylog);
    $self->clear_querylog_analyzer;

    $schema->storage->debugobj( $querylog );
    $schema->storage->debug(1);
};

1;