package Cradle::Runner;

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


# Working directory
#   In order to run multiple jobs on the same project concurrently, we'll need
#   to have multiple copies of the source repository on the disk
has 'dir' => (
    is      => 'rw',
    isa     => 'Str',
);



1;
