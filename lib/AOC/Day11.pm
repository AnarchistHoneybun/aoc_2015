package AOC::Day11;
use strict;
use warnings;

# Increment the password by one character
sub increment_password {
    my ($password) = @_;
    
    # Convert password to array of characters for easier manipulation
    my @chars = split //, $password;
    my $i = length($password) - 1;
    
    while ($i >= 0) {
        if ($chars[$i] eq 'z') {
            $chars[$i] = 'a';
            $i--;
        } else {
            $chars[$i] = chr(ord($chars[$i]) + 1);
            last;
        }
    }
    
    return join '', @chars;
}

# Check if password is valid according to all rules
sub is_valid_password {
    my ($password) = @_;
    
    # Rule 1: no i, o, l
    if ($password =~ /[iol]/) {
        return 0;
    }
    
    # Rule 2: at least one increasing straight of three letters
    my $has_straight = 0;
    for (my $i = 0; $i < length($password) - 2; $i++) {
        my $c1 = substr($password, $i, 1);
        my $c2 = substr($password, $i + 1, 1);
        my $c3 = substr($password, $i + 2, 1);
        
        if (ord($c1) + 1 == ord($c2) && ord($c2) + 1 == ord($c3)) {
            $has_straight = 1;
            last;
        }
    }
    
    if (!$has_straight) {
        return 0;
    }
    
    # Rule 3: at least two different, non-overlapping pairs of letters
    my %pairs;
    my $i = 0;
    while ($i < length($password) - 1) {
        if (substr($password, $i, 1) eq substr($password, $i + 1, 1)) {
            $pairs{substr($password, $i, 1)} = 1;
            $i += 2;
        } else {
            $i++;
        }
    }
    
    return scalar(keys %pairs) >= 2;
}

sub solve_p1 {
    my (undef, $input) = @_;
    
    # Remove any whitespace
    $input =~ s/\s+//g;
    
    # Find the next valid password
    my $password = $input;
    while (1) {
        $password = increment_password($password);
        if (is_valid_password($password)) {
            return $password;
        }
    }
}

sub solve_p2 {
    my (undef, $input) = @_;
    
    # Remove any whitespace
    $input =~ s/\s+//g;
    
    # Find the first valid password
    my $password = $input;
    while (1) {
        $password = increment_password($password);
        if (is_valid_password($password)) {
            last;
        }
    }
    
    # Find the second valid password
    while (1) {
        $password = increment_password($password);
        if (is_valid_password($password)) {
            return $password;
        }
    }
}

1;