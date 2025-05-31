package AOC::Day15;
use strict;
use warnings;

sub solve_p1 {
    my (undef, $input) = @_;
    
    my @properties;
    foreach my $line (split /\n/, $input) {
        my @numbers = $line =~ /(-?\d+)/g;
        next unless @numbers == 5;
        
        for my $i (0..4) {
            push @{$properties[$i]}, $numbers[$i];
        }
    }
    
    my $best_score = find_best_cookie(\@properties)->[0];
    return $best_score;
}

sub solve_p2 {
    my (undef, $input) = @_;
    
    my @properties;
    foreach my $line (split /\n/, $input) {
        my @numbers = $line =~ /(-?\d+)/g;
        next unless @numbers == 5;
        
        for my $i (0..4) {
            push @{$properties[$i]}, $numbers[$i];
        }
    }
    
    my $best_score_500_calories = find_best_cookie(\@properties)->[1];
    return $best_score_500_calories;
}

sub find_best_cookie {
    my ($properties) = @_;
    
    my $TOTAL = 100;
    my $pt1 = 0;
    my $pt2 = 0;
    
    for my $a (0..$TOTAL) {
        for my $b (0..($TOTAL-$a)) {
            for my $c (0..($TOTAL-$a-$b)) {
                my $d = $TOTAL - $a - $b - $c;
                my @amounts = ($a, $b, $c, $d);
                
                my $score = calc_scores(\@amounts, $properties);
                
                $pt1 = $score if $score > $pt1;
                
                if ($score > $pt2 && calc_score(\@amounts, $properties->[4]) == 500) {
                    $pt2 = $score;
                }
            }
        }
    }
    
    return [$pt1, $pt2];
}

sub calc_score {
    my ($amounts, $property) = @_;
    
    my $sum = 0;
    for my $i (0..$#$amounts) {
        $sum += $amounts->[$i] * $property->[$i];
    }
    
    return $sum;
}

sub calc_scores {
    my ($amounts, $properties) = @_;
    
    my $product = 1;
    for my $i (0..3) {
        my $property_value = calc_score($amounts, $properties->[$i]);
        $property_value = 0 if $property_value < 0; # Max with 0
        $product *= $property_value;
    }
    
    return $product;
}

1;