#! /usr/bin/perl

# Copyright (C) 2020 Jeff Okamoto
# See the LICENES file for details on how this program may be used
# and distitbuted.

use Data::Dumper;
use Storable 'dclone';

use strict;

our @current_standings = (-999, 4, 2, 1, 1);  # 1-based
our @secondary_sort = (-999, 1000, 1200, 1100, 1300); # 1-based
our @team_names = ('', 'T1', 'T2', 'T3', 'T4'); # 1-based
our $topN = 2;

my @schedule = (
    [ [1,2], [3,4] ],	# Next week
    [ [1,3], [2,4] ],	# week after
    [ [1,4], [2,3] ],	# week after that
);

# Build list of permutations of wins per team depending on schedule
my @permutations = ( [-999] );

for my $week (@schedule) {
    for my $game (@$week) {
        my @new_permutations = ();
        for my $case (@permutations) {
            my $new = dclone($case);
            $new->[$game->[0]] += 1;
            $new->[$game->[1]] += 0;
            push @new_permutations, $new;

            $new = dclone($case);
            $new->[$game->[0]] += 0;
            $new->[$game->[1]] += 1;
            push @new_permutations, $new;
        }
        @permutations = @new_permutations;
    }
}

# Iterate through each permutation

my @made_playoffs;

for my $permut (@permutations) {

    my $new_standings = dclone(\@current_standings);

    for (my $i = 1; $i < @$new_standings; $i++) {
        $new_standings->[$i] += $permut->[$i];
    }

    my $sorted_wins = sort_wins($new_standings);

    for my $i (0..$topN-1) {
        $made_playoffs[$sorted_wins->[$i]->{team_number}]++;
    }
}

print "Total permutations: ", scalar(@permutations), "\n";

for (my $i = 1; $i < @made_playoffs; $i++) {
    printf("%-20s%7d (%.1f\%)\n",
        $team_names[$i], $made_playoffs[$i],
        100 * $made_playoffs[$i] / scalar(@permutations));
}

sub sort_wins {
    my ($order) = @_;

    # Build Schwarzian transform
    my @transform;
    for (my $i = 0; $i < @$order; $i++) {
        push(@transform, { team_number => $i,  wins => $order->[$i] });
    }

    my @rv = sort { $b->{wins} <=> $a->{wins} ||
      $secondary_sort[$b->{team_number}] <=> $secondary_sort[$a->{team_number}]
    } @transform;
    # But return the sorted transformed data structure
    return \@rv;
}
