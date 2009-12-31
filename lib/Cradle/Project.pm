package Cradle::Project;

# Store a configured project

use Moose;
use Cradle::Source;

has 'last_check' => (
    is      => 'rw',
    default => sub { DateTime->now },
);

has 'name' => (
    is          => 'rw',
    isa         => 'Str',
    required    => 1,
);

has 'source' => (
    is          => 'rw',
    isa         => 'Cradle::Source',
    required    => 1,
    handles     => [qw{ get_commits_since }],
);

has 'stash' => (
    is      => 'rw',
    isa     => 'Cradle::Stash',
);

override BUILDARGS => sub {
    my $args    = super();

    # Create a source from the configuration
    $args->{source}{name} ||= $args->{name};
    $args->{source} = Cradle::Source->new( $args->{source} );

    return $args;
};

1;
