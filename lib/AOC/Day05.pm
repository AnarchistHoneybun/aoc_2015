package AOC::Day05;
use strict;
use warnings;

sub solve_p1 {
    my (undef, $input) = @_;
    my $nice_count = 0;
    
    for my $line (split /\n/, $input) {
        chomp $line;
        next unless length $line;
        
        # Check for at least 3 vowels
        my $vowel_count = () = $line =~ /[aeiou]/gi;
        next unless $vowel_count >= 3;
        
        # Check for at least one double letter
        next unless $line =~ /(.)\1/;
        
        # Check for forbidden substrings
        next if $line =~ /ab|cd|pq|xy/;
        
        $nice_count++;
    }
    
    return $nice_count;
}

sub solve_p2 {
    my (undef, $input) = @_;
    my $nice_count = 0;
    
    for my $line (split /\n/, $input) {
        chomp $line;
        next unless length $line;
        
        # Check for pair of any two letters that appears at least twice without overlapping
        next unless $line =~ /(..).*\1/;
        
        # Check for at least one letter which repeats with exactly one letter between them
        next unless $line =~ /(.).\1/;
        
        $nice_count++;
    }
    
    return $nice_count;
}

1;