package Cradle::Project;

# Store a configured project

use Moose;
use POE;
use Cradle::Source;
use Cradle::Job;

has 'last_check' => (
    is      => 'rw',
    default => sub { DateTime->now->subtract( days => 3 ) },
);

has 'last_revision' => (
    is      => 'rw',
);

has 'master' => (
    is      => 'ro',
    isa     => 'Cradle::Master',
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

has 'tasks' => (
    is      => 'rw',
    isa     => 'ArrayRef',
);

override BUILDARGS => sub {
    my $args    = super();

    # Create a source from the configuration
    $args->{source}{name} ||= $args->{name};
    $args->{source} = Cradle::Source->new( $args->{source} );

    # Create task objects
    for my $task ( @{$args->{tasks}} ) {
        my $file = my $class = delete $task->{class};
        $file =~ s{::}{/}g;
        require "$file.pm"; # XXX: Has to be something better...
        $task   = $class->new( $task );
    }

    return $args;
};

sub BUILD {
    my ( $self ) = @_;

    POE::Session->create(
        object_states => [
            $self => [ '_start', 'check', 'run_job', 'spawn_job' ],
        ],
    );
}

sub _start {
    return check( @_ );
}
  
sub check {
    my ( $self, $kernel ) = @_[OBJECT, KERNEL];
    print "Checking " . $self->name . "\n";
    my @commits = $self->get_commits_since( $self->last_check );
    for my $commit ( @commits ) {
        # get_commits_since is inclusive
        next if ( $commit->revision eq $self->last_revision );
        # Create a new session to handle the job
        print "Spawning job " . $self->name . " commit " . $commit->revision,
            "\n"
            ;
        
        $kernel->yield( 'spawn_job', $commit );
        $self->last_check( $commit->time );
        $self->last_revision( $commit->revision );
    }

    $kernel->delay( 'check' => 5, $self );
}

sub run_job {
    my ( $self, $kernel, $job ) = @_[OBJECT, KERNEL, ARG0];
    $job->run;
    $kernel->yield( 'run_job', $job ) unless $job->is_done;
}

sub spawn_job {
    my ( $self, $kernel, $commit ) = @_[OBJECT, KERNEL, ARG0];

    my $job = Cradle::Job->new(
        tasks       => [ @{$self->tasks} ],
        project     => $self,
        commit      => $commit,
    );
    
    $kernel->yield( 'run_job', $job );
}

1;
