package AOC::Day10;
use strict;
use warnings;

# Solves Part 1: Apply look-and-say process 40 times and return length
sub solve_p1 {
    my (undef, $input) = @_;
    
    # Clean up input (remove whitespace)
    $input =~ s/\s+//g;
    
    # Current sequence starts with the input
    my $sequence = $input;
    
    # Apply the look-and-say process 40 times
    for my $i (1..40) {
        $sequence = look_and_say($sequence);
    }
    
    # Return the length of the resulting sequence
    return length($sequence);
}

sub solve_p2 {
    my (undef, $input) = @_;
    
    # Clean up input (remove whitespace)
    $input =~ s/\s+//g;
    
    # Current sequence starts with the input
    my $sequence = $input;
    
    # Apply the look-and-say process 40 times
    for my $i (1..50) {
        $sequence = look_and_say($sequence);
    }
    
    # Return the length of the resulting sequence
    return length($sequence);
}

# Generates the next sequence in the look-and-say process
sub look_and_say {
    my ($sequence) = @_;
    
    my $result = '';
    my $current_char = substr($sequence, 0, 1);
    my $count = 1;
    
    # Process each character in the sequence
    for my $i (1..length($sequence) - 1) {
        my $char = substr($sequence, $i, 1);
        
        if ($char eq $current_char) {
            # If same character, increment count
            $count++;
        } else {
            # If different character, append count and digit to result
            $result .= $count . $current_char;
            $current_char = $char;
            $count = 1;
        }
    }
    
    # Don't forget to add the last group
    $result .= $count . $current_char;
    
    return $result;
}

1;