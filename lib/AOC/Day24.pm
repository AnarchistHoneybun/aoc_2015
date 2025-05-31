package AOC::Day24;
use strict;
use warnings;

sub solve_p1 {
    my ($input) = $_[1];
    
    my @weights = map { chomp; $_ } split /\n/, $input;
    @weights = grep { $_ =~ /^\d+$/ } @weights; 
    
    return solve(\@weights, 3);
}

sub solve_p2 {
    my ($input) = $_[1];
    
    my @weights = map { chomp; $_ } split /\n/, $input;
    @weights = grep { $_ =~ /^\d+$/ } @weights;
    
    return solve(\@weights, 4);
}

sub solve {
    my ($data, $groups) = @_;
    
    my $total_sum = 0;
    $total_sum += $_ for @$data;
    my $goal = $total_sum / $groups;
    
    # Sort in descending order
    my @sorted_data = sort { $b <=> $a } @$data;
    
    my @possible_solutions = ();
    
    # Recursive function to find all valid combinations
    my $aux;
    $aux = sub {
        my ($presents, $score, $used, $qe) = @_;
        
        if ($score == $goal) {
            push @possible_solutions, [$used, $qe];
        } elsif ($score < $goal && @$presents && $used < 6) {
            # Skip current present
            my @remaining = @$presents[1..$#$presents];
            $aux->(\@remaining, $score, $used, $qe);
            
            # Include current present
            $aux->(\@remaining, $score + $presents->[0], $used + 1, $qe * $presents->[0]);
        }
    };
    
    $aux->(\@sorted_data, 0, 0, 1);
    
    @possible_solutions = sort { $a->[0] <=> $b->[0] || $a->[1] <=> $b->[1] } @possible_solutions;
    
    return @possible_solutions ? $possible_solutions[0]->[1] : undef;
}

1;