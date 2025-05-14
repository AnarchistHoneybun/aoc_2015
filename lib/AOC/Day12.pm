package AOC::Day12;
use strict;
use warnings;
use JSON;

sub solve_p1 {
    my ( undef, $input ) = @_;

    # Parse the JSON input
    my $json = JSON->new->allow_nonref;
    my $data;

    eval { $data = $json->decode($input); };

    if ($@) {
        die "Failed to parse JSON: $@";
    }

    # Calculate the sum of all numbers in the JSON structure
    my $sum = sum_numbers($data);

    return $sum;
}

sub sum_numbers {
    my ($element) = @_;

    # If it's a simple number, return it
    if ( defined $element && !ref($element) && $element =~ /^-?\d+(?:\.\d+)?$/ )
    {
        return $element;
    }

    # If it's an array, sum all elements
    if ( ref($element) eq 'ARRAY' ) {
        my $sum = 0;
        foreach my $item (@$element) {
            $sum += sum_numbers($item);
        }
        return $sum;
    }

    # If it's an object/hash, sum all values
    if ( ref($element) eq 'HASH' ) {
        my $sum = 0;
        foreach my $key ( keys %$element ) {
            $sum += sum_numbers( $element->{$key} );
        }
        return $sum;
    }

    # If it's a string or something else, return 0
    return 0;
}

sub solve_p2 {
    my ( undef, $input ) = @_;

    # Parse the JSON input
    my $json = JSON->new->allow_nonref;
    my $data;

    eval { $data = $json->decode($input); };

    if ($@) {
        die "Failed to parse JSON: $@";
    }

# Calculate the sum of all numbers in the JSON structure, ignoring "red" objects
    my $sum = sum_numbers_no_red($data);

    return $sum;
}

sub sum_numbers_no_red {
    my ($element) = @_;

    # If it's a simple number, return it
    if ( defined $element && !ref($element) && $element =~ /^-?\d+(?:\.\d+)?$/ )
    {
        return $element;
    }

    # If it's an array, sum all elements
    if ( ref($element) eq 'ARRAY' ) {
        my $sum = 0;
        foreach my $item (@$element) {
            $sum += sum_numbers_no_red($item);
        }
        return $sum;
    }

    # If it's an object/hash, check if it has a value "red"
    if ( ref($element) eq 'HASH' ) {

        # Check if any value is "red"
        foreach my $key ( keys %$element ) {
            if ( !ref( $element->{$key} ) && $element->{$key} eq "red" ) {

                # If found, ignore this object and all its children
                return 0;
            }
        }

        # If no "red" value found, process normally
        my $sum = 0;
        foreach my $key ( keys %$element ) {
            $sum += sum_numbers_no_red( $element->{$key} );
        }
        return $sum;
    }

    # If it's a string or something else, return 0
    return 0;
}

1;
