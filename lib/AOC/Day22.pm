package AOC::Day22;
use strict;
use warnings;

sub solve_p1 {
    my ($input) = $_[1];
    
    # Parse boss stats from input
    my ($boss_hp, $boss_damage) = parse_boss_stats($input);
    
    # Find minimum mana to win using BFS
    return find_min_mana_to_win($boss_hp, $boss_damage);
}

sub solve_p2 {
    my ($input) = $_[1];
    
    # Parse boss stats from input
    my ($boss_hp, $boss_damage) = parse_boss_stats($input);
    
    # Find minimum mana to win using BFS with hard mode
    return find_min_mana_to_win_hard($boss_hp, $boss_damage);
}

sub parse_boss_stats {
    my ($input) = @_;
    my @lines = split /\n/, $input;
    my ($hp, $damage);
    
    for my $line (@lines) {
        if ($line =~ /Hit Points: (\d+)/) {
            $hp = $1;
        } elsif ($line =~ /Damage: (\d+)/) {
            $damage = $1;
        }
    }
    
    return ($hp, $damage);
}

sub find_min_mana_to_win {
    my ($boss_hp, $boss_damage) = @_;
    
    # State: [player_hp, player_mana, boss_hp, shield_timer, poison_timer, recharge_timer, mana_spent, is_player_turn]
    my @queue = ([50, 500, $boss_hp, 0, 0, 0, 0, 1]);
    my %seen = ();
    my $min_mana = 999999;
    
    while (@queue) {
        my $state = shift @queue;
        my ($player_hp, $player_mana, $current_boss_hp, $shield_timer, $poison_timer, $recharge_timer, $mana_spent, $is_player_turn) = @$state;
        
        # Skip if we've already spent more mana than our best solution
        next if $mana_spent >= $min_mana;
        
        # Apply effects at start of turn
        my $player_armor = 0;
        
        if ($shield_timer > 0) {
            $player_armor = 7;
            $shield_timer--;
        }
        
        if ($poison_timer > 0) {
            $current_boss_hp -= 3;
            $poison_timer--;
        }
        
        if ($recharge_timer > 0) {
            $player_mana += 101;
            $recharge_timer--;
        }
        
        # Check if boss is dead
        if ($current_boss_hp <= 0) {
            $min_mana = $mana_spent if $mana_spent < $min_mana;
            next;
        }
        
        if ($is_player_turn) {
            # Player's turn - try each spell
            my @spells = (
                ['Magic Missile', 53, sub { 
                    my ($php, $pm, $bhp, $st, $pt, $rt) = @_;
                    return ($php, $pm - 53, $bhp - 4, $st, $pt, $rt);
                }],
                ['Drain', 73, sub { 
                    my ($php, $pm, $bhp, $st, $pt, $rt) = @_;
                    return ($php + 2, $pm - 73, $bhp - 2, $st, $pt, $rt);
                }],
                ['Shield', 113, sub { 
                    my ($php, $pm, $bhp, $st, $pt, $rt) = @_;
                    return ($st > 0) ? () : ($php, $pm - 113, $bhp, 6, $pt, $rt);
                }],
                ['Poison', 173, sub { 
                    my ($php, $pm, $bhp, $st, $pt, $rt) = @_;
                    return ($pt > 0) ? () : ($php, $pm - 173, $bhp, $st, 6, $rt);
                }],
                ['Recharge', 229, sub { 
                    my ($php, $pm, $bhp, $st, $pt, $rt) = @_;
                    return ($rt > 0) ? () : ($php, $pm - 229, $bhp, $st, $pt, 5);
                }]
            );
            
            for my $spell (@spells) {
                my ($name, $cost, $effect) = @$spell;
                
                # Can we afford this spell?
                next if $player_mana < $cost;
                
                # Apply spell effect
                my @new_state = $effect->($player_hp, $player_mana, $current_boss_hp, $shield_timer, $poison_timer, $recharge_timer);
                next unless @new_state; # Skip if spell can't be cast (effect already active)
                
                my ($new_php, $new_pm, $new_bhp, $new_st, $new_pt, $new_rt) = @new_state;
                
                # Create state for boss turn
                my $new_state = [$new_php, $new_pm, $new_bhp, $new_st, $new_pt, $new_rt, $mana_spent + $cost, 0];
                
                # Create state key for memoization
                my $state_key = join(',', $new_php, $new_pm, $new_bhp, $new_st, $new_pt, $new_rt, 0);
                
                if (!exists $seen{$state_key} || $seen{$state_key} > $mana_spent + $cost) {
                    $seen{$state_key} = $mana_spent + $cost;
                    push @queue, $new_state;
                }
            }
        } else {
            # Boss's turn
            next if $player_hp <= 0; # Player already dead
            
            # Boss attacks
            my $damage = $boss_damage - $player_armor;
            $damage = 1 if $damage < 1; # Minimum 1 damage
            
            my $new_player_hp = $player_hp - $damage;
            
            # Only continue if player survives
            if ($new_player_hp > 0) {
                my $new_state = [$new_player_hp, $player_mana, $current_boss_hp, $shield_timer, $poison_timer, $recharge_timer, $mana_spent, 1];
                
                # Create state key for memoization
                my $state_key = join(',', $new_player_hp, $player_mana, $current_boss_hp, $shield_timer, $poison_timer, $recharge_timer, 1);
                
                if (!exists $seen{$state_key} || $seen{$state_key} > $mana_spent) {
                    $seen{$state_key} = $mana_spent;
                    push @queue, $new_state;
                }
            }
        }
    }
    
    return $min_mana == 999999 ? undef : $min_mana;
}

sub find_min_mana_to_win_hard {
    my ($boss_hp, $boss_damage) = @_;
    
    # State: [player_hp, player_mana, boss_hp, shield_timer, poison_timer, recharge_timer, mana_spent, is_player_turn]
    my @queue = ([50, 500, $boss_hp, 0, 0, 0, 0, 1]);
    my %seen = ();
    my $min_mana = 999999;
    
    while (@queue) {
        my $state = shift @queue;
        my ($player_hp, $player_mana, $current_boss_hp, $shield_timer, $poison_timer, $recharge_timer, $mana_spent, $is_player_turn) = @$state;
        
        # Skip if we've already spent more mana than our best solution
        next if $mana_spent >= $min_mana;
        
        if ($is_player_turn) {
            # HARD MODE: Lose 1 HP at start of player turn
            $player_hp--;
            
            # Check if player dies from hard mode damage
            if ($player_hp <= 0) {
                next; # Player loses
            }
        }
        
        # Apply effects at start of turn
        my $player_armor = 0;
        
        if ($shield_timer > 0) {
            $player_armor = 7;
            $shield_timer--;
        }
        
        if ($poison_timer > 0) {
            $current_boss_hp -= 3;
            $poison_timer--;
        }
        
        if ($recharge_timer > 0) {
            $player_mana += 101;
            $recharge_timer--;
        }
        
        # Check if boss is dead
        if ($current_boss_hp <= 0) {
            $min_mana = $mana_spent if $mana_spent < $min_mana;
            next;
        }
        
        if ($is_player_turn) {
            # Player's turn - try each spell
            my @spells = (
                ['Magic Missile', 53, sub { 
                    my ($php, $pm, $bhp, $st, $pt, $rt) = @_;
                    return ($php, $pm - 53, $bhp - 4, $st, $pt, $rt);
                }],
                ['Drain', 73, sub { 
                    my ($php, $pm, $bhp, $st, $pt, $rt) = @_;
                    return ($php + 2, $pm - 73, $bhp - 2, $st, $pt, $rt);
                }],
                ['Shield', 113, sub { 
                    my ($php, $pm, $bhp, $st, $pt, $rt) = @_;
                    return ($st > 0) ? () : ($php, $pm - 113, $bhp, 6, $pt, $rt);
                }],
                ['Poison', 173, sub { 
                    my ($php, $pm, $bhp, $st, $pt, $rt) = @_;
                    return ($pt > 0) ? () : ($php, $pm - 173, $bhp, $st, 6, $rt);
                }],
                ['Recharge', 229, sub { 
                    my ($php, $pm, $bhp, $st, $pt, $rt) = @_;
                    return ($rt > 0) ? () : ($php, $pm - 229, $bhp, $st, $pt, 5);
                }]
            );
            
            for my $spell (@spells) {
                my ($name, $cost, $effect) = @$spell;
                
                # Can we afford this spell?
                next if $player_mana < $cost;
                
                # Apply spell effect
                my @new_state = $effect->($player_hp, $player_mana, $current_boss_hp, $shield_timer, $poison_timer, $recharge_timer);
                next unless @new_state; # Skip if spell can't be cast (effect already active)
                
                my ($new_php, $new_pm, $new_bhp, $new_st, $new_pt, $new_rt) = @new_state;
                
                # Create state for boss turn
                my $new_state = [$new_php, $new_pm, $new_bhp, $new_st, $new_pt, $new_rt, $mana_spent + $cost, 0];
                
                # Create state key for memoization
                my $state_key = join(',', $new_php, $new_pm, $new_bhp, $new_st, $new_pt, $new_rt, 0);
                
                if (!exists $seen{$state_key} || $seen{$state_key} > $mana_spent + $cost) {
                    $seen{$state_key} = $mana_spent + $cost;
                    push @queue, $new_state;
                }
            }
        } else {
            # Boss's turn
            next if $player_hp <= 0; # Player already dead
            
            # Boss attacks
            my $damage = $boss_damage - $player_armor;
            $damage = 1 if $damage < 1; # Minimum 1 damage
            
            my $new_player_hp = $player_hp - $damage;
            
            # Only continue if player survives
            if ($new_player_hp > 0) {
                my $new_state = [$new_player_hp, $player_mana, $current_boss_hp, $shield_timer, $poison_timer, $recharge_timer, $mana_spent, 1];
                
                # Create state key for memoization
                my $state_key = join(',', $new_player_hp, $player_mana, $current_boss_hp, $shield_timer, $poison_timer, $recharge_timer, 1);
                
                if (!exists $seen{$state_key} || $seen{$state_key} > $mana_spent) {
                    $seen{$state_key} = $mana_spent;
                    push @queue, $new_state;
                }
            }
        }
    }
    
    return $min_mana == 999999 ? undef : $min_mana;
}

1;