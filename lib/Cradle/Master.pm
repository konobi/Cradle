package Cradle::Master;

# Loads Projects from config
# Monitors Sources of Projects to create Jobs
# Runs Jobs by
#   * Sending to other Masters on remote systems
#   -- OR --
#   * Spawning Runner to run Job Tasks

use Moose;
with 'MooseX::Runnable';
with 'MooseX::SimpleConfig';
with 'MooseX::Getopt';

use POE;
use POE::Component::IKC::Server;

has +configfile => (
    default     => '/etc/cradle.conf',
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
);

sub run {
    my ( $self, @args ) = @_;
    
    # Create an IKC Server

}

1;
