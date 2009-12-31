package Cradle::Source;

# Describe the source of a project.
# Monitors source and controls when a new Job gets run

use Moose;
use VCI;
use DateTime;

has 'vci' => (
    is      => 'rw',
    isa     => 'VCI::Abstract::Repository',
    lazy    => 1,
    default => sub {
        my ( $self ) = @_;
        return VCI->connect( 
            type    => ucfirst( $self->type ),
            repo    => $self->repo,
        );
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
    my $history = $self->project->get_history_by_time( start => $last_check );
    return @{$history->commits};
}

sub project {
    my ( $self ) = @_;
    # History gets cached. Running get_project each time clears cache
    return $self->vci->get_project( name => $self->name );
}

1;
