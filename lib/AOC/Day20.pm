package AOC::Day20;
use strict;
use warnings;

sub solve_p1 {
    my ($input) = $_[1];
    chomp($input);
    my $target = $input + 0;  # Convert to number
    
    my $house = 1;
    
    while (1) {
        my $presents = get_presents($house);
        
        if ($presents >= $target) {
            return $house;
        }
        
        $house++;
    }
}

sub get_presents {
    my ($house_num) = @_;
    my $sum_of_divisors = 0;
    
    for my $elf (1 .. int(sqrt($house_num))) {
        if ($house_num % $elf == 0) {
            $sum_of_divisors += $elf;
            
            if ($elf != $house_num / $elf) {
                $sum_of_divisors += $house_num / $elf;
            }
        }
    }
    
    return $sum_of_divisors * 10;
}

sub solve_p2 {
    my ($input) = $_[1];
    chomp($input);
    my $target = $input + 0;
    
    my $house = 1;
    
    while (1) {
        my $presents = get_presents_p2($house);
        
        if ($presents >= $target) {
            return $house;
        }
        
        $house++;
    }
}

sub get_presents_p2 {
    my ($house_num) = @_;
    my $total_presents = 0;
    
    for my $elf (1 .. int(sqrt($house_num))) {
        if ($house_num % $elf == 0) {
            if ($house_num <= 50 * $elf) {
                $total_presents += $elf * 11;
            }
            
            my $other_elf = $house_num / $elf;
            if ($elf != $other_elf && $house_num <= 50 * $other_elf) {
                $total_presents += $other_elf * 11;
            }
        }
    }
    
    return $total_presents;
}

1;