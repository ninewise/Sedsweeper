
# Sedsweeper

## About

Sedsweeper is an implementation of the game Minesweeper, written in sed.
Because the location of the mines had to be hard-coded (due to the limitations
of sed), the sed source-files have to be generated.

## Usage

The sedsweeper file contains a runnable script with a small (3 on 3) minefield.
The code has a slightly readable layout, and is commented.

The generator.sh file contains the code to generate new games, written in bash.
It needs to be called as:
    generator.sh {infile|-r size} [outfile]
where -r will generate a random field of given size, infile will generate the
field specified in the file (sample included), and outfile will contain the
generated sed-script.  If the outfile is not specified, the sed-script will be
invoked immediatly, leaving no script.