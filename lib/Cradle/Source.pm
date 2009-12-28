package Cradle::Source;

# Describe the source of a project.
# Monitors source and controls when a new Job gets run

use VCI;

sub is_ready {
    my ( $self, $last_run_time ) = @_;

    # Return true if there is a new job to run
}


1;
