package AOC::Day08;
use strict;
use warnings;

sub solve_p1 {
    my (undef, $input) = @_;
    
    my $code_chars = 0;
    my $memory_chars = 0;
    
    foreach my $line (split /\n/, $input) {
        # Skip empty lines
        next if $line =~ /^\s*$/;
        
        # Count characters in code
        $code_chars += length($line);
        
        # Remove the surrounding quotes
        my $string = substr($line, 1, length($line) - 2);
        
        # Process escape sequences
        my $i = 0;
        my $mem_len = 0;
        
        while ($i < length($string)) {
            my $char = substr($string, $i, 1);
            
            if ($char eq '\\') {
                my $next_char = substr($string, $i + 1, 1);
                
                if ($next_char eq '\\' || $next_char eq '"') {
                    # \\ becomes \, \" becomes "
                    $mem_len++;
                    $i += 2;
                }
                elsif ($next_char eq 'x') {
                    # \xXX becomes a single character
                    $mem_len++;
                    $i += 4; # Skip \xXX
                }
                else {
                    # unreachable
                    $mem_len++;
                    $i++;
                }
            }
            else {
                # Regular character
                $mem_len++;
                $i++;
            }
        }
        
        $memory_chars += $mem_len;
    }
    
    return $code_chars - $memory_chars;
}

sub solve_p2 {
    my (undef, $input) = @_;
    
    my $original_code_chars = 0;
    my $encoded_chars = 0;
    
    foreach my $line (split /\n/, $input) {
        # Skip empty lines
        next if $line =~ /^\s*$/;
        
        # Count characters
        $original_code_chars += length($line);
        
        # Start with 2 for the surrounding quotes in the encoded string
        my $encoded_len = 2;
        
        # Process each character for encoding
        for (my $i = 0; $i < length($line); $i++) {
            my $char = substr($line, $i, 1);
            
            if ($char eq '"' || $char eq '\\') {
                # Double quote and backslash need to be escaped
                $encoded_len += 2; # The backslash and the character
            }
            else {
                # Regular character
                $encoded_len += 1;
            }
        }
        
        $encoded_chars += $encoded_len;
    }
    
    return $encoded_chars - $original_code_chars;
}

1;