package Cradle::Project;

# Store a configured project

use Moose;

has 'name' => (
    is      => 'rw',
    isa     => 'Str',
);

has 'source' => (
    is      => 'rw',
    isa     => 'Cradle::Source',
);

has 'stash' => (
    is      => 'rw',
    isa     => 'Cradle::Stash',
);

1;
