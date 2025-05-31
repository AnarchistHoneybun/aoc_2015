package AOC::Day17;
use strict;
use warnings;

sub solve_p1 {
    my (undef, $input) = @_;
    
    my @containers = split /\n/, $input;
    
    my $target_volume = 150;
    
    my $count = count_combinations(\@containers, $target_volume);
    
    return $count;
}

sub count_combinations {
    my ($containers, $target, $index, $current_sum) = @_;
    
    $index = 0 unless defined $index;
    $current_sum = 0 unless defined $current_sum;
    
    return 1 if $current_sum == $target;
    return 0 if $current_sum > $target || $index >= scalar @$containers;
    
    my $include = count_combinations($containers, $target, $index + 1, $current_sum + $containers->[$index]);
    
    my $exclude = count_combinations($containers, $target, $index + 1, $current_sum);
    
    return $include + $exclude;
}

sub solve_p2 {
    my (undef, $input) = @_;
    
    my @containers = split /\n/, $input;
    
    my $target_volume = 150;
    
    my %combinations_by_count;
    find_combinations(\@containers, $target_volume, 0, 0, 0, \%combinations_by_count);
    
    my $min_containers = (sort {$a <=> $b} keys %combinations_by_count)[0];
    
    return $combinations_by_count{$min_containers};
}

sub find_combinations {
    my ($containers, $target, $index, $current_sum, $container_count, $combinations_by_count) = @_;
    
    if ($current_sum == $target) {
        $combinations_by_count->{$container_count}++;
        return;
    }
    
    return if $current_sum > $target || $index >= scalar @$containers;
    
    find_combinations(
        $containers, 
        $target, 
        $index + 1, 
        $current_sum + $containers->[$index], 
        $container_count + 1, 
        $combinations_by_count
    );
    
    find_combinations(
        $containers, 
        $target, 
        $index + 1, 
        $current_sum, 
        $container_count, 
        $combinations_by_count
    );
}    

1;
