package Cradle::Task::Make;

# Run make on a project

use Moose;
use POE;

extends 'Cradle::Task';

sub run {
    my ( $self, $job ) = @_;
    print "Running make on " . $job->project->name . " for commit " . $job->commit->revision,
        "\n";

}

1;

