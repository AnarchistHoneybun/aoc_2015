package AOC::Day13;

use strict;
use warnings;

sub solve_p1 {
    my (undef, $input) = @_;
    
    # Parse input and build happiness matrix
    my %happiness;
    my %people;
    
    foreach my $line (split /\n/, $input) {
        if ($line =~ /^(\w+) would (gain|lose) (\d+) happiness units by sitting next to (\w+).$/) {
            my ($person1, $gainlose, $units, $person2) = ($1, $2, $3, $4);
            $units = -$units if $gainlose eq 'lose';
            $happiness{$person1}{$person2} = $units;
            $people{$person1} = 1;
            $people{$person2} = 1;
        }
    }
    
    # Get list of unique people
    my @people = keys %people;
    
    # Find optimal arrangement (try all permutations)
    my $max_happiness = find_max_happiness(\%happiness, \@people);
    
    return $max_happiness;
}

sub find_max_happiness {
    my ($happiness, $people) = @_;
    
    # Start with first person fixed (since table is circular, we can fix one position)
    my $first = shift @$people;
    my $max = calculate_max_arrangement($happiness, [$first], $people);
    unshift @$people, $first;  # Put back for future calls
    
    return $max;
}

sub calculate_max_arrangement {
    my ($happiness, $seated, $remaining) = @_;
    
    # Base case: all people are seated
    if (scalar @$remaining == 0) {
        return calculate_happiness($happiness, $seated);
    }
    
    # Try each remaining person in the next seat
    my $max = -999999;  # Start with a very low value
    
    for (my $i = 0; $i < scalar @$remaining; $i++) {
        my $person = $remaining->[$i];
        
        # Remove person from remaining list
        splice(@$remaining, $i, 1);
        
        # Add person to seated list
        push @$seated, $person;
        
        # Calculate max happiness with this arrangement
        my $current = calculate_max_arrangement($happiness, $seated, $remaining);
        
        # Update max if better
        $max = $current if $current > $max;
        
        # Restore state for next iteration
        pop @$seated;
        splice(@$remaining, $i, 0, $person);
    }
    
    return $max;
}

sub calculate_happiness {
    my ($happiness, $arrangement) = @_;
    
    my $total = 0;
    my $count = scalar @$arrangement;
    
    for (my $i = 0; $i < $count; $i++) {
        my $current = $arrangement->[$i];
        my $next = $arrangement->[($i + 1) % $count];
        my $prev = $arrangement->[($i - 1 + $count) % $count];
        
        # Add happiness for both neighbors
        $total += $happiness->{$current}{$next} if exists $happiness->{$current}{$next};
        $total += $happiness->{$current}{$prev} if exists $happiness->{$current}{$prev};
    }
    
    return $total;
}

sub solve_p2 {
    my (undef, $input) = @_;
    
    # Parse input and build happiness matrix
    my %happiness;
    my %people;
    
    foreach my $line (split /\n/, $input) {
        if ($line =~ /^(\w+) would (gain|lose) (\d+) happiness units by sitting next to (\w+).$/) {
            my ($person1, $gainlose, $units, $person2) = ($1, $2, $3, $4);
            $units = -$units if $gainlose eq 'lose';
            $happiness{$person1}{$person2} = $units;
            $people{$person1} = 1;
            $people{$person2} = 1;
        }
    }
    
    # Get list of unique people
    my @people = keys %people;
    
    # Add yourself with zero happiness impact
    foreach my $person (@people) {
        $happiness{'Myself'}{$person} = 0;
        $happiness{$person}{'Myself'} = 0;
    }
    push @people, 'Myself';
    
    # Find optimal arrangement (try all permutations)
    my $max_happiness = find_max_happiness(\%happiness, \@people);
    
    return $max_happiness;
}

1;