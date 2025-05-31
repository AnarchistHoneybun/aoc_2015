package AOC::Day16;
use strict;
use warnings;

sub solve_p1 {
    my (undef, $input) = @_;
    
    # The MFCSAM readings
    my %target = (
        children => 3,
        cats => 7,
        samoyeds => 2,
        pomeranians => 3,
        akitas => 0,
        vizslas => 0,
        goldfish => 5,
        trees => 3,
        cars => 2,
        perfumes => 1,
    );
    
    # Parse input
    my @aunts;
    foreach my $line (split /\n/, $input) {
        if ($line =~ /Sue (\d+): (.*)/) {
            my $sue_number = $1;
            my $properties = $2;
            
            my %sue;
            $sue{number} = $sue_number;
            
            # Parse properties
            while ($properties =~ /(\w+): (\d+)/g) {
                $sue{$1} = $2;
            }
            
            push @aunts, \%sue;
        }
    }
    
    # Find the matching Sue
    foreach my $sue (@aunts) {
        my $matches = 1;
        
        foreach my $prop (keys %{$sue}) {
            next if $prop eq 'number';
            
            if (exists $target{$prop} && $sue->{$prop} != $target{$prop}) {
                $matches = 0;
                last;
            }
        }
        
        if ($matches) {
            return $sue->{number};
        }
    }
    
    return undef;
}

sub solve_p2 {
    my (undef, $input) = @_;
    
    # The MFCSAM readings
    my %target = (
        children => 3,
        cats => 7,
        samoyeds => 2,
        pomeranians => 3,
        akitas => 0,
        vizslas => 0,
        goldfish => 5,
        trees => 3,
        cars => 2,
        perfumes => 1,
    );
    
    my %greater_than = (cats => 1, trees => 1);
    my %fewer_than = (pomeranians => 1, goldfish => 1);
    
    my @aunts;
    foreach my $line (split /\n/, $input) {
        if ($line =~ /Sue (\d+): (.*)/) {
            my $sue_number = $1;
            my $properties = $2;
            
            my %sue;
            $sue{number} = $sue_number;
            
            # Parse properties
            while ($properties =~ /(\w+): (\d+)/g) {
                $sue{$1} = $2;
            }
            
            push @aunts, \%sue;
        }
    }
    
    foreach my $sue (@aunts) {
        my $matches = 1;
        
        foreach my $prop (keys %{$sue}) {
            next if $prop eq 'number';
            
            if (exists $target{$prop}) {
                if (exists $greater_than{$prop}) {
                    if ($sue->{$prop} <= $target{$prop}) {
                        $matches = 0;
                        last;
                    }
                } elsif (exists $fewer_than{$prop}) {
                    if ($sue->{$prop} >= $target{$prop}) {
                        $matches = 0;
                        last;
                    }
                } else {
                    if ($sue->{$prop} != $target{$prop}) {
                        $matches = 0;
                        last;
                    }
                }
            }
        }
        
        if ($matches) {
            return $sue->{number};
        }
    }
    
    return undef;
}

1;
