
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

## Play

Because I couldn't be arsed to parse a lot of random user input, I won't ensure
the stability of the program with incorrect input. The correct input's been kept
really easy, so that should do.

Clicking on a tile goes like

    2,4<enter>

where the first number is the row, and the second number is the column. As
anyone should, I start counted from 0.

To flag a tile, just insert the coordinats in the same way, except the numbers
ought to be followed by an 'F'. So,

    0,5F<enter>

will put a flag on the sixth tile of the first row.
