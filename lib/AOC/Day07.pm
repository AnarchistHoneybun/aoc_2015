package AOC::Day07;
use strict;
use warnings;

sub solve_p1 {
    my (undef, $input) = @_;
    
    my %wires;                 # Hash to store wire signal values
    my @instructions = split(/\n/, $input);
    my @remaining_instructions = @instructions;
    
    # Keep processing instructions until all are processed or no more can be processed
    while (@remaining_instructions) {
        my @still_remaining;
        my $processed_any = 0;
        
        for my $instruction (@remaining_instructions) {
            next unless length $instruction;
            
            # Try to process this instruction
            if (process_instruction($instruction, \%wires)) {
                $processed_any = 1;
            } else {
                # If we couldn't process it now, keep it for the next round
                push @still_remaining, $instruction;
            }
        }
        
        # If we didn't process any instructions in this round, we're stuck
        if (!$processed_any && @still_remaining == @remaining_instructions) {
            die "Unable to process remaining instructions: " . join(", ", @still_remaining);
        }
        
        @remaining_instructions = @still_remaining;
    }
    
    # Return the signal on wire 'a'
    return $wires{'a'};
}

sub solve_p2 {
    my (undef, $input) = @_;
    
    # First, get the signal on wire 'a'
    my $signal_a = solve_p1(undef, $input);
    
    # Parse instructions again, but override instruction for wire 'b'
    my @instructions;
    my $has_b_instruction = 0;
    
    foreach my $line (split /\n/, $input) {
        next unless length $line;
        
        if ($line =~ /^.* -> b$/) {
            # Replace wire 'b' instruction with direct value
            push @instructions, "$signal_a -> b";
            $has_b_instruction = 1;
        } else {
            push @instructions, $line;
        }
    }
    
    # If there wasn't a 'b' instruction, add one
    push @instructions, "$signal_a -> b" unless $has_b_instruction;
    
    # Process the modified circuit
    my %wires;
    my @remaining_instructions = @instructions;
    
    # Same logic as solve_p1 to process instructions
    while (@remaining_instructions) {
        my @still_remaining;
        my $processed_any = 0;
        
        for my $instruction (@remaining_instructions) {
            next unless length $instruction;
            
            if (process_instruction($instruction, \%wires)) {
                $processed_any = 1;
            } else {
                push @still_remaining, $instruction;
            }
        }
        
        if (!$processed_any && @still_remaining == @remaining_instructions) {
            die "Unable to process remaining instructions in part 2: " . join(", ", @still_remaining);
        }
        
        @remaining_instructions = @still_remaining;
    }
    
    # Return the new signal on wire 'a'
    return $wires{'a'};
}

# Process a single instruction, updating the wires hash
# Returns true if the instruction was processed, false if it couldn't be processed yet
sub process_instruction {
    my ($instruction, $wires) = @_;
    
    # Direct value assignment: 123 -> x
    if ($instruction =~ /^(\d+) -> ([a-z]+)$/) {
        my ($value, $wire) = ($1, $2);
        $wires->{$wire} = $value & 0xFFFF; # Ensure 16-bit signal
        return 1;
    }
    
    # Wire reference: x -> y
    elsif ($instruction =~ /^([a-z]+) -> ([a-z]+)$/) {
        my ($source_wire, $dest_wire) = ($1, $2);
        
        # Check if source wire has a value
        if (exists $wires->{$source_wire}) {
            $wires->{$dest_wire} = $wires->{$source_wire};
            return 1;
        }
        return 0; # Source wire not defined yet
    }
    
    # NOT operation: NOT e -> f
    elsif ($instruction =~ /^NOT ([a-z]+) -> ([a-z]+)$/) {
        my ($source_wire, $dest_wire) = ($1, $2);
        
        # Check if source wire has a value
        if (exists $wires->{$source_wire}) {
            $wires->{$dest_wire} = ~$wires->{$source_wire} & 0xFFFF; # 16-bit complement
            return 1;
        }
        return 0; # Source wire not defined yet
    }
    
    # AND operation: x AND y -> z
    elsif ($instruction =~ /^([a-z]+|\d+) AND ([a-z]+|\d+) -> ([a-z]+)$/) {
        my ($input1, $input2, $dest_wire) = ($1, $2, $3);
        
        my $value1;
        if ($input1 =~ /^\d+$/) {
            $value1 = $input1;
        } elsif (exists $wires->{$input1}) {
            $value1 = $wires->{$input1};
        } else {
            return 0; # First input not defined yet
        }
        
        my $value2;
        if ($input2 =~ /^\d+$/) {
            $value2 = $input2;
        } elsif (exists $wires->{$input2}) {
            $value2 = $wires->{$input2};
        } else {
            return 0; # Second input not defined yet
        }
        
        $wires->{$dest_wire} = ($value1 & $value2) & 0xFFFF;
        return 1;
    }
    
    # OR operation: x OR y -> z
    elsif ($instruction =~ /^([a-z]+|\d+) OR ([a-z]+|\d+) -> ([a-z]+)$/) {
        my ($input1, $input2, $dest_wire) = ($1, $2, $3);
        
        my $value1;
        if ($input1 =~ /^\d+$/) {
            $value1 = $input1;
        } elsif (exists $wires->{$input1}) {
            $value1 = $wires->{$input1};
        } else {
            return 0; # First input not defined yet
        }
        
        my $value2;
        if ($input2 =~ /^\d+$/) {
            $value2 = $input2;
        } elsif (exists $wires->{$input2}) {
            $value2 = $wires->{$input2};
        } else {
            return 0; # Second input not defined yet
        }
        
        $wires->{$dest_wire} = ($value1 | $value2) & 0xFFFF;
        return 1;
    }
    
    # LSHIFT operation: p LSHIFT 2 -> q
    elsif ($instruction =~ /^([a-z]+) LSHIFT (\d+) -> ([a-z]+)$/) {
        my ($source_wire, $shift, $dest_wire) = ($1, $2, $3);
        
        # Check if source wire has a value
        if (exists $wires->{$source_wire}) {
            $wires->{$dest_wire} = ($wires->{$source_wire} << $shift) & 0xFFFF;
            return 1;
        }
        return 0; # Source wire not defined yet
    }
    
    # RSHIFT operation: y RSHIFT 2 -> g
    elsif ($instruction =~ /^([a-z]+) RSHIFT (\d+) -> ([a-z]+)$/) {
        my ($source_wire, $shift, $dest_wire) = ($1, $2, $3);
        
        # Check if source wire has a value
        if (exists $wires->{$source_wire}) {
            $wires->{$dest_wire} = ($wires->{$source_wire} >> $shift) & 0xFFFF;
            return 1;
        }
        return 0; # Source wire not defined yet
    }
    
    # Unknown instruction format
    die "Unknown instruction format: $instruction";
}

1;