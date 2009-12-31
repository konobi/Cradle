package Cradle::Task::Prove;

use Moose;
use POE;

extends 'Cradle::Task';

sub run {
    my ( $self, $job ) = @_;
    print "Running prove on " . $job->project->name . " for commit " . $job->commit->revision,
        "\n";
}


1;
