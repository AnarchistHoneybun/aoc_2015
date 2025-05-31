package AOC::Day25;
use strict;
use warnings;

use constant FIRST => 20151125;
use constant BASE => 252533;
use constant MOD => 33554393;

sub solve_p1 {
    my ($input) = $_[1];
    
    my ($row, $col);
    if ($input =~ /row\s+(\d+).*column\s+(\d+)/) {
        ($row, $col) = ($1, $2);
    } else {
        $row = 2947;
        $col = 3029;
    }
    
    my $exp = find_exp($row, $col);
    return solve(BASE, $exp, MOD);
}

sub find_exp {
    my ($r, $c) = @_;
    
    my $n = $r + $c - 1;
    my $sum = $n * ($n - 1) / 2;
    return $sum + $c - 1;
}

sub solve {
    my ($base, $exp, $mod) = @_;
    
    my $res = 1;
    while ($exp) {
        if ($exp % 2) {
            $res = ($res * $base) % $mod;
        }
        $exp = int($exp / 2);
        $base = ($base * $base) % $mod;
    }
    return ($res * FIRST) % $mod;
}

sub solve_p2 {
    my ($input) = $_[1];
    return undef;
}

1;