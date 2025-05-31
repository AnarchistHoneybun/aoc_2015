package AOC::Day23;
use strict;
use warnings;

sub solve_p1 {
    my ($input) = $_[1];
    
    # Parse instructions into an array
    my @instructions = split /\n/, $input;
    chomp @instructions;
    
    # Initialize registers
    my %registers = (
        'a' => 0,
        'b' => 0
    );
    
    # Instruction pointer
    my $ip = 0;
    
    # Execute instructions until we go out of bounds
    while ($ip >= 0 && $ip < @instructions) {
        my $instruction = $instructions[$ip];
        
        if ($instruction =~ /^hlf (\w)$/) {
            # Half register
            my $reg = $1;
            $registers{$reg} = int($registers{$reg} / 2);
            $ip++;
        }
        elsif ($instruction =~ /^tpl (\w)$/) {
            # Triple register
            my $reg = $1;
            $registers{$reg} *= 3;
            $ip++;
        }
        elsif ($instruction =~ /^inc (\w)$/) {
            # Increment register
            my $reg = $1;
            $registers{$reg}++;
            $ip++;
        }
        elsif ($instruction =~ /^jmp ([+-]\d+)$/) {
            # Unconditional jump
            my $offset = $1;
            $ip += $offset;
        }
        elsif ($instruction =~ /^jie (\w), ([+-]\d+)$/) {
            # Jump if even
            my ($reg, $offset) = ($1, $2);
            if ($registers{$reg} % 2 == 0) {
                $ip += $offset;
            } else {
                $ip++;
            }
        }
        elsif ($instruction =~ /^jio (\w), ([+-]\d+)$/) {
            # Jump if one
            my ($reg, $offset) = ($1, $2);
            if ($registers{$reg} == 1) {
                $ip += $offset;
            } else {
                $ip++;
            }
        }
        else {
            # Unknown instruction, should not happen
            die "Unknown instruction: $instruction";
        }
    }
    
    return $registers{'b'};
}

sub solve_p2 {
    my ($input) = $_[1];
    
    # Parse instructions into an array
    my @instructions = split /\n/, $input;
    chomp @instructions;
    
    # Initialize registers - register 'a' starts as 1 for part 2
    my %registers = (
        'a' => 1,
        'b' => 0
    );
    
    # Instruction pointer
    my $ip = 0;
    
    # Execute instructions until we go out of bounds
    while ($ip >= 0 && $ip < @instructions) {
        my $instruction = $instructions[$ip];
        
        if ($instruction =~ /^hlf (\w)$/) {
            # Half register
            my $reg = $1;
            $registers{$reg} = int($registers{$reg} / 2);
            $ip++;
        }
        elsif ($instruction =~ /^tpl (\w)$/) {
            # Triple register
            my $reg = $1;
            $registers{$reg} *= 3;
            $ip++;
        }
        elsif ($instruction =~ /^inc (\w)$/) {
            # Increment register
            my $reg = $1;
            $registers{$reg}++;
            $ip++;
        }
        elsif ($instruction =~ /^jmp ([+-]\d+)$/) {
            # Unconditional jump
            my $offset = $1;
            $ip += $offset;
        }
        elsif ($instruction =~ /^jie (\w), ([+-]\d+)$/) {
            # Jump if even
            my ($reg, $offset) = ($1, $2);
            if ($registers{$reg} % 2 == 0) {
                $ip += $offset;
            } else {
                $ip++;
            }
        }
        elsif ($instruction =~ /^jio (\w), ([+-]\d+)$/) {
            # Jump if one
            my ($reg, $offset) = ($1, $2);
            if ($registers{$reg} == 1) {
                $ip += $offset;
            } else {
                $ip++;
            }
        }
        else {
            # Unknown instruction, should not happen
            die "Unknown instruction: $instruction";
        }
    }
    
    return $registers{'b'};
}

1;