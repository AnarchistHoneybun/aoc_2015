package AOC::Day19;
use strict;
use warnings;

sub solve_p1 {
    my ($input) = $_[1];
    
    my @lines = split /\n/, $input;
    my @replacements;
    my $medicine = '';
    
    # Parse input
    foreach my $line (@lines) {
        if ($line =~ /^(\w+) => (\w+)$/) {
            push @replacements, [$1, $2];
        } elsif ($line =~ /^\w+$/ && length($line) > 0) {
            $medicine = $line;
        }
    }
    
    if (!$medicine && @lines) {
        $medicine = $lines[-1];
    }
    
    my %unique_molecules;
    
    foreach my $rule (@replacements) {
        my ($from, $to) = @$rule;
        
        my $pos = -1;
        while (1) {
            $pos = index($medicine, $from, $pos + 1);
            last if $pos == -1;
            
            my $new_molecule = $medicine;
            substr($new_molecule, $pos, length($from), $to);
            
            $unique_molecules{$new_molecule} = 1;
        }
    }
    
    return scalar(keys %unique_molecules);
}

sub solve_p2 {
    my ($input) = $_[1];
    
    my @lines = split /\n/, $input;
    my @replacements;
    my $medicine = '';
    
    # Parse input
    foreach my $line (@lines) {
        if ($line =~ /^(\w+) => (\w+)$/) {
            push @replacements, [$1, $2];
        } elsif ($line =~ /^\w+$/ && length($line) > 0) {
            $medicine = $line;
        }
    }
    
    if (!$medicine && @lines) {
        $medicine = $lines[-1];
    }
    
    # Count atoms
    my $atom_count = () = $medicine =~ /[A-Z][a-z]?/g;
    
    # Count special atoms
    my $rn_ar_count = () = $medicine =~ /Rn|Ar/g;
    my $y_count = () = $medicine =~ /Y/g;
    
    # The formula: atoms - parentheses - 2*commas - 1
    return $atom_count - $rn_ar_count - 2 * $y_count - 1;
}

1;