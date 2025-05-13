package AOC::Day02;
use strict;
use warnings;

sub solve_p1 {
    my (undef, $input) = @_;
    my $total = 0;
    
    for my $line (split /\n/, $input) {
        my @dims = sort { $a <=> $b } split /x/, $line;
        
        # Surface area + smallest face area
        $total += 2 * ($dims[0]*$dims[1] + $dims[1]*$dims[2] + $dims[0]*$dims[2]) + $dims[0]*$dims[1];
    }
    
    return $total;
}

sub solve_p2 {
    my (undef, $input) = @_;
    my $total = 0;
    
    for my $line (split /\n/, $input) {
        my @dims = sort { $a <=> $b } split /x/, $line;
        
        # Smallest perimeter + volume
        $total += 2 * ($dims[0] + $dims[1]) + $dims[0] * $dims[1] * $dims[2];
    }
    
    return $total;
}

1;