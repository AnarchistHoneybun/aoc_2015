package AOC::Day04;
use strict;
use warnings;
use Digest::MD5 qw(md5_hex);

sub solve_p1 {
    my (undef, $input) = @_;
    chomp $input;
    my $number = 0;
    
    while (1) {
        $number++;
        my $hash = md5_hex("$input$number");
        if ($hash =~ /^00000/) {
            return $number;
        }
    }
}

sub solve_p2 {
    my (undef, $input) = @_;
    chomp $input;
    my $number = 0;
    
    while (1) {
        $number++;
        my $hash = md5_hex("$input$number");
        if ($hash =~ /^000000/) {
            return $number;
        }
    }
}

1;