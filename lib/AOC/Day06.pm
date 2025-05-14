package AOC::Day06;
use strict;
use warnings;

sub solve_p1 {
    my (undef, $input) = @_;
    my @grid;
    
    # Initialize all lights to off (0)
    for my $i (0..999) {
        for my $j (0..999) {
            $grid[$i][$j] = 0;
        }
    }
    
    for my $line (split /\n/, $input) {
        chomp $line;
        next unless length $line;
        
        # Parse the instruction
        if ($line =~ /^(turn on|turn off|toggle) (\d+),(\d+) through (\d+),(\d+)/) {
            my ($action, $x1, $y1, $x2, $y2) = ($1, $2, $3, $4, $5);
            
            # Process each light in the rectangle
            for my $i ($x1..$x2) {
                for my $j ($y1..$y2) {
                    if ($action eq 'turn on') {
                        $grid[$i][$j] = 1;
                    } elsif ($action eq 'turn off') {
                        $grid[$i][$j] = 0;
                    } elsif ($action eq 'toggle') {
                        $grid[$i][$j] = $grid[$i][$j] ? 0 : 1;
                    }
                }
            }
        }
    }
    
    # Count the number of lit lights
    my $lit_count = 0;
    for my $i (0..999) {
        for my $j (0..999) {
            $lit_count++ if $grid[$i][$j];
        }
    }
    
    return $lit_count;
}

sub solve_p2 {
    my (undef, $input) = @_;
    my @grid;
    
    # Initialize all lights to brightness 0
    for my $i (0..999) {
        for my $j (0..999) {
            $grid[$i][$j] = 0;
        }
    }
    
    for my $line (split /\n/, $input) {
        chomp $line;
        next unless length $line;
        
        # Parse the instruction
        if ($line =~ /^(turn on|turn off|toggle) (\d+),(\d+) through (\d+),(\d+)/) {
            my ($action, $x1, $y1, $x2, $y2) = ($1, $2, $3, $4, $5);
            
            # Process each light in the rectangle
            for my $i ($x1..$x2) {
                for my $j ($y1..$y2) {
                    if ($action eq 'turn on') {
                        $grid[$i][$j]++;
                    } elsif ($action eq 'turn off') {
                        $grid[$i][$j]-- if $grid[$i][$j] > 0;
                    } elsif ($action eq 'toggle') {
                        $grid[$i][$j] += 2;
                    }
                }
            }
        }
    }
    
    # Calculate the total brightness
    my $total_brightness = 0;
    for my $i (0..999) {
        for my $j (0..999) {
            $total_brightness += $grid[$i][$j];
        }
    }
    
    return $total_brightness;
}

1;