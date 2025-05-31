package AOC::Day18;
use strict;
use warnings;

sub solve_p1 {
    my ($class, $input) = @_;
    
    my @grid = parse_grid($input);
    
    # Animate for 100 steps
    for my $step (1..100) {
        @grid = animate(\@grid);
    }
    
    # Count lights that are on
    my $count = count_lights_on(\@grid);
    
    return $count;
}

sub solve_p2 {
    my ($class, $input) = @_;
    
    my @grid = parse_grid($input);
    
    force_corners_on(\@grid);
    
    # Animate for 100 steps
    for my $step (1..100) {
        @grid = animate_with_stuck_corners(\@grid);
    }
    
    # Count lights that are on
    my $count = count_lights_on(\@grid);
    
    return $count;
}

# Parse the input string into a 2D grid array
sub parse_grid {
    my ($input) = @_;
    my @grid;
    
    my @lines = split /\n/, $input;
    for my $line (@lines) {
        next unless $line =~ /[.#]/; # Skip empty lines
        my @row = split //, $line;
        push @grid, \@row;
    }
    
    return @grid;
}

sub force_corners_on {
    my ($grid) = @_;
    
    my $height = scalar @$grid;
    my $width = scalar @{$grid->[0]};
    
    # Set all four corners to on
    $grid->[0][0] = '#';                    # Top-left
    $grid->[0][$width-1] = '#';             # Top-right
    $grid->[$height-1][0] = '#';            # Bottom-left
    $grid->[$height-1][$width-1] = '#';     # Bottom-right
}

# Animate one step of the grid
sub animate {
    my ($grid) = @_;
    my @new_grid;
    
    my $height = scalar @$grid;
    my $width = scalar @{$grid->[0]};
    
    for my $y (0..$height-1) {
        for my $x (0..$width-1) {
            my $state = $grid->[$y][$x];
            my $neighbors_on = count_neighbors_on($grid, $x, $y);
            
            # Apply the rules
            my $new_state;
            if ($state eq '#') { # Light is on
                $new_state = ($neighbors_on == 2 || $neighbors_on == 3) ? '#' : '.';
            } else { # Light is off
                $new_state = ($neighbors_on == 3) ? '#' : '.';
            }
            
            $new_grid[$y][$x] = $new_state;
        }
    }
    
    return @new_grid;
}

sub animate_with_stuck_corners {
    my ($grid) = @_;
    my @new_grid;
    
    my $height = scalar @$grid;
    my $width = scalar @{$grid->[0]};
    
    for my $y (0..$height-1) {
        for my $x (0..$width-1) {
            my $state = $grid->[$y][$x];
            my $neighbors_on = count_neighbors_on($grid, $x, $y);
            
            # Apply the rules
            my $new_state;
            if ($state eq '#') { # Light is on
                $new_state = ($neighbors_on == 2 || $neighbors_on == 3) ? '#' : '.';
            } else { # Light is off
                $new_state = ($neighbors_on == 3) ? '#' : '.';
            }
            
            $new_grid[$y][$x] = $new_state;
        }
    }
    
    # Force the four corners to be on
    force_corners_on(\@new_grid);
    
    return @new_grid;
}

sub count_neighbors_on {
    my ($grid, $x, $y) = @_;
    my $count = 0;
    
    my $height = scalar @$grid;
    my $width = scalar @{$grid->[0]};
    
    for my $dy (-1..1) {
        for my $dx (-1..1) {
            next if $dx == 0 && $dy == 0; # Skip the cell itself
            
            my $nx = $x + $dx;
            my $ny = $y + $dy;
            
            # Skip if outside the grid
            next if $nx < 0 || $nx >= $width || $ny < 0 || $ny >= $height;
            
            # Count if the neighbor is on
            $count++ if $grid->[$ny][$nx] eq '#';
        }
    }
    
    return $count;
}

sub count_lights_on {
    my ($grid) = @_;
    my $count = 0;
    
    foreach my $row (@$grid) {
        foreach my $cell (@$row) {
            $count++ if $cell eq '#';
        }
    }
    
    return $count;
}

1;