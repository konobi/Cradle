package Cradle::Source;

# Describe the source of a project.
# Monitors source and controls when a new Job gets run

use Moose;
use VCI;
use DateTime;

has 'vci' => (
    is      => 'rw',
    isa     => 'VCI::Abstract::Project',
    lazy    => 1,
    default => sub {
        my ( $self ) = @_;
        my $repo = VCI->connect( 
            type    => ucfirst( $self->type ),
            repo    => $self->repo,
        );
        return $repo->get_project( name => $self->name );
    },
);

has 'type' => (
    is      => 'rw',
    isa     => 'Str',
);

has 'repo' => (
    is      => 'rw',
    isa     => 'Str',
);

has 'name' => (
    is      => 'rw',
    isa     => 'Str',
);

sub get_commits_since {
    my ( $self, $last_check ) = @_;
    my $history = $self->vci->get_history_by_time( start => $last_check );
    return @{$history->commits};
}


1;
