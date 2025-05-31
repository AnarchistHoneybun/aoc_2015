package AOC::Day14;
use strict;
use warnings;

sub solve_p1 {
    my (undef, $input) = @_;
    
    my @reindeer;
    foreach my $line (split /\n/, $input) {
        if ($line =~ /(\w+) can fly (\d+) km\/s for (\d+) seconds, but then must rest for (\d+) seconds\./) {
            push @reindeer, {
                name => $1,
                speed => $2,
                fly_time => $3,
                rest_time => $4,
            };
        }
    }
    
    my $max_distance = 0;
    foreach my $deer (@reindeer) {
        my $cycle_time = $deer->{fly_time} + $deer->{rest_time};
        my $complete_cycles = int(2503 / $cycle_time);
        my $remaining_seconds = 2503 % $cycle_time;
        
        my $distance = $complete_cycles * $deer->{speed} * $deer->{fly_time};
        
        if ($remaining_seconds > $deer->{fly_time}) {
            $distance += $deer->{speed} * $deer->{fly_time};
        } else {
            $distance += $deer->{speed} * $remaining_seconds;
        }
        
        $max_distance = $distance if $distance > $max_distance;
    }
    
    return $max_distance;
}

sub solve_p2 {
    my (undef, $input) = @_;
    
    my @reindeer;
    foreach my $line (split /\n/, $input) {
        if ($line =~ /(\w+) can fly (\d+) km\/s for (\d+) seconds, but then must rest for (\d+) seconds\./) {
            push @reindeer, {
                name => $1,
                speed => $2,
                fly_time => $3,
                rest_time => $4,
                distance => 0,
                points => 0,
            };
        }
    }
    
    # Simulate the race second by second
    for my $second (1..2503) {
        foreach my $deer (@reindeer) {
            my $cycle_time = $deer->{fly_time} + $deer->{rest_time};
            my $cycle_position = $second % $cycle_time;
            
            if ($cycle_position > 0 && $cycle_position <= $deer->{fly_time}) {
                $deer->{distance} += $deer->{speed};
            }
        }
        
        my $max_distance = 0;
        foreach my $deer (@reindeer) {
            $max_distance = $deer->{distance} if $deer->{distance} > $max_distance;
        }
        
        foreach my $deer (@reindeer) {
            if ($deer->{distance} == $max_distance) {
                $deer->{points}++;
            }
        }
    }
    
    my $max_points = 0;
    foreach my $deer (@reindeer) {
        $max_points = $deer->{points} if $deer->{points} > $max_points;
    }
    
    return $max_points;
}

1;