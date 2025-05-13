package AOC::Day01;
use strict;
use warnings;

sub solve_p1 {
    my ($input) = $_[1];
    return $input =~ tr/(// - $input =~ tr/)//;
}

sub solve_p2 {
    my ($input) = $_[1];
    
    my ($floor, $pos) = (0, 0);
    for my $char (split //, $input) {
        $floor += ($char eq '(') ? 1 : -1;
        return ++$pos if $floor < 0;  # +1 because positions start at 1
        $pos++;
    }
    return undef;
}

1;