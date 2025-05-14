package AOC::Day09;

use strict;
use warnings;

sub solve_p1 {
    my (undef, $input) = @_;
    
    my %distances;
    my %locations;
    
    foreach my $line (split /\n/, $input) {
        next unless $line =~ /(\S+) to (\S+) = (\d+)/;
        my ($from, $to, $distance) = ($1, $2, $3);
        
        $distances{"$from,$to"} = $distance;
        $distances{"$to,$from"} = $distance;
        
        $locations{$from} = 1;
        $locations{$to} = 1;
    }
    
    my @locations = keys %locations;
    
    return 0 if scalar @locations == 0;
    
    my $shortest_path = find_shortest_path(\%distances, \@locations);
    
    return $shortest_path;
}

sub find_shortest_path {
    my ($distances, $locations) = @_;
    
    return 0 if scalar @$locations <= 1;
    
    my $shortest = undef;
    
    # Try each location as the starting point
    for (my $i = 0; $i < scalar @$locations; $i++) {
        my $current = $locations->[$i];
        
        # Remove the current location from the list
        my @remaining = @$locations;
        splice(@remaining, $i, 1);
        
        # Find the shortest path through the remaining locations
        my $min_path_from_current = find_shortest_path_from($distances, $current, \@remaining);
        
        # Update the shortest path if we found a shorter one
        if (!defined $shortest || $min_path_from_current < $shortest) {
            $shortest = $min_path_from_current;
        }
    }
    
    return $shortest;
}

sub find_shortest_path_from {
    my ($distances, $start, $remaining) = @_;
    
    # If there are no remaining locations, we're done
    return 0 if scalar @$remaining == 0;
    
    my $shortest = undef;
    
    # Try each remaining location as the next step
    for (my $i = 0; $i < scalar @$remaining; $i++) {
        my $next = $remaining->[$i];
        
        # Get the distance between the current and next location
        my $distance = $distances->{"$start,$next"};
        
        # Remove the next location from the list
        my @new_remaining = @$remaining;
        splice(@new_remaining, $i, 1);
        
        # Find the shortest path through the remaining locations
        my $path_length = $distance + find_shortest_path_from($distances, $next, \@new_remaining);
        
        # Update the shortest path if we found a shorter one
        if (!defined $shortest || $path_length < $shortest) {
            $shortest = $path_length;
        }
    }
    
    return $shortest;
}

sub solve_p2 {
    my (undef, $input) = @_;
    
    # Now we want to find the longest path
    # Parse the input to get the distances between locations
    my %distances;
    my %locations;
    
    foreach my $line (split /\n/, $input) {
        next unless $line =~ /(\S+) to (\S+) = (\d+)/;
        my ($from, $to, $distance) = ($1, $2, $3);
        
        # Store distances both ways
        $distances{"$from,$to"} = $distance;
        $distances{"$to,$from"} = $distance;
        
        # Keep track of all unique locations
        $locations{$from} = 1;
        $locations{$to} = 1;
    }
    
    my @locations = keys %locations;
    
    # If there are no locations, return 0
    return 0 if scalar @locations == 0;
    
    # Find the longest path using a recursive approach
    my $longest_path = find_longest_path(\%distances, \@locations);
    
    return $longest_path;
}

sub find_longest_path {
    my ($distances, $locations) = @_;
    
    # If there's only one location, there's no distance to travel
    return 0 if scalar @$locations <= 1;
    
    my $longest = 0;
    
    # Try each location as the starting point
    for (my $i = 0; $i < scalar @$locations; $i++) {
        my $current = $locations->[$i];
        
        # Remove the current location from the list
        my @remaining = @$locations;
        splice(@remaining, $i, 1);
        
        # Find the longest path through the remaining locations
        my $max_path_from_current = find_longest_path_from($distances, $current, \@remaining);
        
        # Update the longest path if we found a longer one
        if ($max_path_from_current > $longest) {
            $longest = $max_path_from_current;
        }
    }
    
    return $longest;
}

sub find_longest_path_from {
    my ($distances, $start, $remaining) = @_;
    
    # If there are no remaining locations, we're done
    return 0 if scalar @$remaining == 0;
    
    my $longest = 0;
    
    # Try each remaining location as the next step
    for (my $i = 0; $i < scalar @$remaining; $i++) {
        my $next = $remaining->[$i];
        
        # Get the distance between the current and next location
        my $distance = $distances->{"$start,$next"};
        
        # Remove the next location from the list
        my @new_remaining = @$remaining;
        splice(@new_remaining, $i, 1);
        
        # Find the longest path through the remaining locations
        my $path_length = $distance + find_longest_path_from($distances, $next, \@new_remaining);
        
        # Update the longest path if we found a longer one
        if ($path_length > $longest) {
            $longest = $path_length;
        }
    }
    
    return $longest;
}

1;