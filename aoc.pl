#!/usr/bin/perl
use strict;
use warnings;
use lib 'lib';
use feature 'say';
use Getopt::Long;
use JSON::PP;
use File::Slurper qw(read_text write_text);

# Parse command-line arguments
my ($day, $help);
GetOptions(
    "d|day=i" => \$day,
    "h|help"  => \$help,
) or die "Error in command-line arguments. Use --help for usage.\n";

if ($help || !$day) {
    say "Usage: perl aoc.pl -d DAY\nExample: perl aoc.pl -d 1";
    exit;
}

# Load solutions.json or create it if missing
my $json_file = 'solutions.json';
my $solutions = {};
if (-e $json_file) {
    $solutions = decode_json(read_text($json_file));
}

# Check if the day's module exists
my $module = "AOC::Day" . sprintf("%02d", $day);
eval "require $module" or do {
    say "Day $day not solved yet!";
    exit;
};

# Load input file
my $input_file = "inputs/day" . sprintf("%02d", $day) . ".txt";
unless (-e $input_file) {
    die "Input file '$input_file' missing!";
}
my $input = read_text($input_file);

# Solve Part 1 and/or Part 2
my $day_result = {};
if ($module->can('solve_p1')) {
    $day_result->{part1} = $module->solve_p1($input);
    say "Day $day - Part 1: " . ($day_result->{part1} // 'N/A');
}
if ($module->can('solve_p2')) {
    $day_result->{part2} = $module->solve_p2($input);
    say "Day $day - Part 2: " . ($day_result->{part2} // 'N/A');
}

# Update solutions.json
$solutions->{"day" . sprintf("%02d", $day)} = $day_result;
write_text($json_file, encode_json($solutions));