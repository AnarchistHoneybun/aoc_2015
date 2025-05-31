package AOC::Day21;
use strict;
use warnings;

sub solve_p1 {
    my ($input) = $_[1];
    
    my ($boss_hp, $boss_damage, $boss_armor);
    for my $line (split /\n/, $input) {
        if ($line =~ /Hit Points: (\d+)/) {
            $boss_hp = $1;
        } elsif ($line =~ /Damage: (\d+)/) {
            $boss_damage = $1;
        } elsif ($line =~ /Armor: (\d+)/) {
            $boss_armor = $1;
        }
    }
    
    # Define shop items
    my @weapons = (
        {name => 'Dagger', cost => 8, damage => 4, armor => 0},
        {name => 'Shortsword', cost => 10, damage => 5, armor => 0},
        {name => 'Warhammer', cost => 25, damage => 6, armor => 0},
        {name => 'Longsword', cost => 40, damage => 7, armor => 0},
        {name => 'Greataxe', cost => 74, damage => 8, armor => 0},
    );
    
    my @armor = (
        {name => 'None', cost => 0, damage => 0, armor => 0},  # No armor option
        {name => 'Leather', cost => 13, damage => 0, armor => 1},
        {name => 'Chainmail', cost => 31, damage => 0, armor => 2},
        {name => 'Splintmail', cost => 53, damage => 0, armor => 3},
        {name => 'Bandedmail', cost => 75, damage => 0, armor => 4},
        {name => 'Platemail', cost => 102, damage => 0, armor => 5},
    );
    
    my @rings = (
        {name => 'Damage +1', cost => 25, damage => 1, armor => 0},
        {name => 'Damage +2', cost => 50, damage => 2, armor => 0},
        {name => 'Damage +3', cost => 100, damage => 3, armor => 0},
        {name => 'Defense +1', cost => 20, damage => 0, armor => 1},
        {name => 'Defense +2', cost => 40, damage => 0, armor => 2},
        {name => 'Defense +3', cost => 80, damage => 0, armor => 3},
    );
    
    my $min_cost = 999999;
    
    # Try all combinations: 1 weapon, 0-1 armor, 0-2 rings
    for my $weapon (@weapons) {
        for my $armor_piece (@armor) {
            # No rings
            my $cost = $weapon->{cost} + $armor_piece->{cost};
            my $damage = $weapon->{damage} + $armor_piece->{damage};
            my $player_armor = $weapon->{armor} + $armor_piece->{armor};
            
            if (player_wins(100, $damage, $player_armor, $boss_hp, $boss_damage, $boss_armor)) {
                $min_cost = $cost if $cost < $min_cost;
            }
            
            # One ring
            for my $i (0..$#rings) {
                my $ring1 = $rings[$i];
                $cost = $weapon->{cost} + $armor_piece->{cost} + $ring1->{cost};
                $damage = $weapon->{damage} + $armor_piece->{damage} + $ring1->{damage};
                $player_armor = $weapon->{armor} + $armor_piece->{armor} + $ring1->{armor};
                
                if (player_wins(100, $damage, $player_armor, $boss_hp, $boss_damage, $boss_armor)) {
                    $min_cost = $cost if $cost < $min_cost;
                }
                
                # Two rings
                for my $j ($i+1..$#rings) {
                    my $ring2 = $rings[$j];
                    $cost = $weapon->{cost} + $armor_piece->{cost} + $ring1->{cost} + $ring2->{cost};
                    $damage = $weapon->{damage} + $armor_piece->{damage} + $ring1->{damage} + $ring2->{damage};
                    $player_armor = $weapon->{armor} + $armor_piece->{armor} + $ring1->{armor} + $ring2->{armor};
                    
                    if (player_wins(100, $damage, $player_armor, $boss_hp, $boss_damage, $boss_armor)) {
                        $min_cost = $cost if $cost < $min_cost;
                    }
                }
            }
        }
    }
    
    return $min_cost;
}

sub player_wins {
    my ($player_hp, $player_damage, $player_armor, $boss_hp, $boss_damage, $boss_armor) = @_;
    
    my $p_hp = $player_hp;
    my $b_hp = $boss_hp;
    
    while ($p_hp > 0 && $b_hp > 0) {
        # Player attacks first
        my $damage_to_boss = $player_damage - $boss_armor;
        $damage_to_boss = 1 if $damage_to_boss < 1;
        $b_hp -= $damage_to_boss;
        
        last if $b_hp <= 0;  # Boss is dead, player wins
        
        # Boss attacks
        my $damage_to_player = $boss_damage - $player_armor;
        $damage_to_player = 1 if $damage_to_player < 1;
        $p_hp -= $damage_to_player;
    }
    
    return $p_hp > 0;  # Player wins if still alive
}

sub solve_p2 {
    my ($input) = $_[1];
    
    # Parse boss stats from input
    my ($boss_hp, $boss_damage, $boss_armor);
    for my $line (split /\n/, $input) {
        if ($line =~ /Hit Points: (\d+)/) {
            $boss_hp = $1;
        } elsif ($line =~ /Damage: (\d+)/) {
            $boss_damage = $1;
        } elsif ($line =~ /Armor: (\d+)/) {
            $boss_armor = $1;
        }
    }
    
    # Define shop items (same as part 1)
    my @weapons = (
        {name => 'Dagger', cost => 8, damage => 4, armor => 0},
        {name => 'Shortsword', cost => 10, damage => 5, armor => 0},
        {name => 'Warhammer', cost => 25, damage => 6, armor => 0},
        {name => 'Longsword', cost => 40, damage => 7, armor => 0},
        {name => 'Greataxe', cost => 74, damage => 8, armor => 0},
    );
    
    my @armor = (
        {name => 'None', cost => 0, damage => 0, armor => 0},  # No armor option
        {name => 'Leather', cost => 13, damage => 0, armor => 1},
        {name => 'Chainmail', cost => 31, damage => 0, armor => 2},
        {name => 'Splintmail', cost => 53, damage => 0, armor => 3},
        {name => 'Bandedmail', cost => 75, damage => 0, armor => 4},
        {name => 'Platemail', cost => 102, damage => 0, armor => 5},
    );
    
    my @rings = (
        {name => 'Damage +1', cost => 25, damage => 1, armor => 0},
        {name => 'Damage +2', cost => 50, damage => 2, armor => 0},
        {name => 'Damage +3', cost => 100, damage => 3, armor => 0},
        {name => 'Defense +1', cost => 20, damage => 0, armor => 1},
        {name => 'Defense +2', cost => 40, damage => 0, armor => 2},
        {name => 'Defense +3', cost => 80, damage => 0, armor => 3},
    );
    
    my $max_cost = 0;
    
    # Try all combinations: 1 weapon, 0-1 armor, 0-2 rings
    for my $weapon (@weapons) {
        for my $armor_piece (@armor) {
            # No rings
            my $cost = $weapon->{cost} + $armor_piece->{cost};
            my $damage = $weapon->{damage} + $armor_piece->{damage};
            my $player_armor = $weapon->{armor} + $armor_piece->{armor};
            
            if (!player_wins(100, $damage, $player_armor, $boss_hp, $boss_damage, $boss_armor)) {
                $max_cost = $cost if $cost > $max_cost;
            }
            
            # One ring
            for my $i (0..$#rings) {
                my $ring1 = $rings[$i];
                $cost = $weapon->{cost} + $armor_piece->{cost} + $ring1->{cost};
                $damage = $weapon->{damage} + $armor_piece->{damage} + $ring1->{damage};
                $player_armor = $weapon->{armor} + $armor_piece->{armor} + $ring1->{armor};
                
                if (!player_wins(100, $damage, $player_armor, $boss_hp, $boss_damage, $boss_armor)) {
                    $max_cost = $cost if $cost > $max_cost;
                }
                
                # Two rings
                for my $j ($i+1..$#rings) {
                    my $ring2 = $rings[$j];
                    $cost = $weapon->{cost} + $armor_piece->{cost} + $ring1->{cost} + $ring2->{cost};
                    $damage = $weapon->{damage} + $armor_piece->{damage} + $ring1->{damage} + $ring2->{damage};
                    $player_armor = $weapon->{armor} + $armor_piece->{armor} + $ring1->{armor} + $ring2->{armor};
                    
                    if (!player_wins(100, $damage, $player_armor, $boss_hp, $boss_damage, $boss_armor)) {
                        $max_cost = $cost if $cost > $max_cost;
                    }
                }
            }
        }
    }
    
    return $max_cost;
}

1;