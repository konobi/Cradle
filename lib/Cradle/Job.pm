package Cradle::Job;

# Run the tasks for a project on a commit

has 'project' => (
    is      => 'rw',
    isa     => 'Cradle::Project',
    handles => [qw{ stash }],
);

has 'tasks' => (
    is      => 'rw',
    isa     => 'ArrayRef[Cradle::Task]',
    traits  => [qw( Array )],
    handles => {
        get_next_task       => 'shift',
        is_done             => 'is_empty',
    },
);

has 'commit' => (
    is      => 'rw',
    isa     => 'VCI::Abstract::Commit',
);

# Working directory
#   In order to run multiple jobs on the same project concurrently, we'll need
#   to have multiple copies of the source repository on the disk
has 'dir' => (
    is      => 'rw',
    isa     => 'Str',
);

sub run {
    my ( $self ) = @_;

    # Checkout the commit into the working directory

    until ( $self->is_done ) {
        $self->get_next_task->run;
    }

    # Hold onto the working directory for the next job for this project
    
}

1;
