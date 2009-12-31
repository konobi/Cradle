package Cradle::Master;

# Loads Projects from config
# Monitors Sources of Projects to create Jobs
# Runs Jobs by
#   * Sending to other Masters on remote systems
#   -- OR --
#   * Spawning Runner to run Job Tasks

use Moose;
with 'MooseX::SimpleConfig';
with 'MooseX::Getopt';
with 'MooseX::Runnable';

use POE qw( Component::IKC::Server );

use Cradle::Project;

has +configfile => (
    is          => 'ro',
    default     => sub {
        if ( $> eq '0' ) {
            return '/etc/cradle.yaml';
        }
        else {
            return '~/etc/cradle.yaml';
        }
    },
);

has 'port'  => (
    is      => 'rw',
    isa     => 'Int',
    default => '36689',
);

has 'ip'    => (
    is      => 'rw',
    isa     => 'Str',
    default => '0.0.0.0',
);

has 'projects' => (
    is      => 'rw',
    isa     => 'ArrayRef',
    traits  => [qw{ Array }],
);

has 'work_dir' => (
    is      => 'rw',
    isa     => 'Str',
    lazy    => 1,
    default => sub {
        require File::Temp; 
        return File::Temp::tempdir( 'cradleXXXX', TMPDIR => 1 );
    },
);

# Other Cradle::Master ip/port addresses
has 'peers' => (
    is      => 'rw',
    isa     => 'ArrayRef',
);

has 'check_interval' => (
    is      => 'rw',
    isa     => 'Int',
    default => 60,
);

sub run {
    my ( $self, @args ) = @_;
    
    POE::Session->create(
        object_states => [
            $self   => [ '_start', 'check_project' ],
        ],
    );

    POE::Kernel->run;
}

sub _start {
    my ( $self, $kernel ) = @_[OBJECT, KERNEL];
    for my $project ( @{$self->projects} ) {
        $project = Cradle::Project->new( %$project );
        $kernel->yield( 'check_project', $project );
    }
}

sub check_project {
    my ( $self, $kernel, $project ) = @_[OBJECT, KERNEL, ARG0];

    for my $commit ( $project->get_commits_since( $project->last_check ) ) {
        # Create a new session to handle the job
        print "Running job for " . $project->name . " commit " . $commit->revision,
            "\n"
            ;
    }

    $kernel->delay( 'check_project' => $self->check_interval, $project );
}

1;
