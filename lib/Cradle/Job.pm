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


sub run {
    my ( $self ) = @_;
    until ( $self->is_done ) {
        $self->get_next_task->run;
    }
}

1;
