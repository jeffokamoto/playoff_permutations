# playoff_permutations

Calculate all playoff permutations for a fantasy league based on the
starting number of wins per team and the schedule of remaining weeks.
It then prints out the number of permutations where each team would
make the playoffs.

## Configuration

The `@current_standings` array contains a list of the current wins for
each team in the league: position `n` in the array corresponds to team
`n`.

The `@secondary_sort` array contains a list of values for each team that
is used to sort teams that have identical number of wins.
This could be the current point standings.

The `@team_names` array stores the names of each team (or the manager's
name), or however you wish to determine which team is which.

The `$topN` scalar specifies the number of teams that make the playoffs.

## Running

After setting the above configuration variables, just run the script.
The script will calculate the final number of wins for every permutation
of the games in the schedule, determine which teams make the playoffs,
and print out the number of permutations in which each team would do so.

## Caveats

This script does **not** calculate the odds or percent chance of each
team making the playoffs.
To take the simplest case, if there are two teams with identical records,
only one game remaining between those two teams, and only one team makes
the playoffs, then there are only two permutations (either team 1 wins
or team 2 wins), and thus each team would make the playoffs in 50% of
the permutations.
What this script cannot know (nor can it be determined beforehand) is
that the probability of each permutation occurring is almost certainly
different from 50%.

The `@secondary_sort` array is used to help "break ties".
As each permutation's results are applied, the teams are sorted by the
number of wins. In case there are ties, the values in the
`@secondary_sort` array for each team is used as a secondary sorting
parameter.
As specified earlier, the current point total of each team is often
used by leagues as the tiebreaker (after winning record), so it should
be used to load the array.
This is not completely accurate: after the first week, it is likely
that the relative point ordering will change.
However, it is better than letting the native sorting algorithm
make the choice.
