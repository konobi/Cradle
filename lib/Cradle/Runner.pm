package Cradle::Runner;

# XXX: Do we really need this? I'm gonna try doing without it
# Run a Job in a newly-spawned process
# Run all the Tasks in the Job
# Receive the Job object from IKC
# Return the Job object with changes from this job run

use Moose;

has 'job' => (
    is      => 'rw',
    isa     => 'Cradle::Job',
    handles => [qw{ project stash }],
);




1;
