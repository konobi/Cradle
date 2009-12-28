package Cradle::Task;

# Run a single task in a job

use Moose;

has 'job' => ( 
    is          => 'ro',
    isa         => 'Cradle::Job',
    required    => 1,
    handles     => [qw{ project }],
);


1;
