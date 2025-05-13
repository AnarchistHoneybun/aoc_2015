package AOC::Day03;
use strict;
use warnings;

# Hash mapping direction symbols to coordinate changes
my %moves = (
    '^' => [0, 1],
    'v' => [0, -1], 
    '>' => [1, 0],
    '<' => [-1, 0]  
);

sub solve_p1 {
    my (undef, $input) = @_;
    my %visited = ("0,0" => 1);  # Initial house is visited
    my ($x, $y) = (0, 0);
    
    for my $move (split //, $input) {
        ($x, $y) = ($x + $moves{$move}[0], $y + $moves{$move}[1]);
        $visited{"$x,$y"} = 1;
    }
    
    return scalar keys %visited;
}

sub solve_p2 {
    my (undef, $input) = @_;
    my %visited = ("0,0" => 1);
    
    my @positions = ([0, 0], [0, 0]);  # [Santa, Robot]
    my $turn = 0;  # 0 for Santa, 1 for Robot
    
    for my $move (split //, $input) {
        $positions[$turn][0] += $moves{$move}[0];
        $positions[$turn][1] += $moves{$move}[1];
        
        $visited{join(',', @{$positions[$turn]})} = 1;
        
        # Toggle between Santa and Robot
        $turn = 1 - $turn;
    }
    
    return scalar keys %visited;
}

1;