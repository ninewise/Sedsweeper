#!/bin/bash

# calculate matrix size row col
#  where
#   matrix  an array, representing a 2D matrix.
#   size    the size of above (square) matrix.
#   row     the row of the element that should be calculated.
#   col     the column of the element.
calculate() {
    size=$1; row=$2; col=$3
    shift 3
    matrix=("$@")
    if [ "${matrix[$((row * size + col))]}" = "X" ]; then echo 9
    else
        count=0
        for x in "-1" "0" "1"; do for y in "-1" "0" "1"; do
                if [ "$x" -ne 0 ] || [ "$y" -ne 0 ]; then
                if (( row + y >= 0 && row + y < size )); then
                if (( col + x >= 0 && col + x < size )); then
                if [[ "${matrix[$(( (row+y)*size + col + x ))]}" =~ [X9] ]]; then
                    ((count++))
                fi
                fi
                fi
                fi
        done; done
        echo $count
    fi
}

minefield=
outfile=
size=0

# Process command line arguments.
if [ $1 == "-r" ]; then
    size=$2
    shift
    for (( i=0; i<size*size; i++ )); do
        minefield[$i]=0;
        if (( RANDOM % 5 == 0 )); then
            minefield[$i]=X
        fi
    done
else
    {
        minestring=

        while read line; do
            minestring="$minestring$(echo "$line" | sed 's/./& /g')"
            let "size = size + 1"
        done

        minefield=($minestring)
    } <$1
fi

if [ -z $2 ]
    then outfile="~temp.sed"
    else outfile=$2
fi


        

{
    
    for (( r=0; r<size; r++)); do for (( c=0; c<size; c++ )); do
        minefield[$((r*size + c))]=$(calculate "$size" "$r" "$c" ${minefield[@]})
    done; done

    # Form dependend parts.
    dots=
    count='s/'
    for (( i=0; i<size*size; i++ )); do
        dots="$dots."
        if [ "${minefield[$i]}" = "9" ]; then count="$count"'F'; fi
    done
    count="$count"'//'
    regex=
    for (( i=0; i<size-1; i++ )); do regex="$regex"'\.[\()]*'; done
    substitutions=
    empty_field=
    process_input=
    for (( r=0; r<size; r++ )); do
        empty_field="$empty_field\n"
        for (( c=0; c<size; c++ )); do
            substitutions="$substitutions""s/$r,$c/&=${minefield[$((r*size+c))]}/;"
            empty_field="$empty_field-"
            process_input="$process_input"'s/^\('"$(echo "${dots:0:$((r*size + c))}"'\).\('"${dots:$((r*size + c + 1))}"'\)' | sed 's/[\()]*'$regex'\.\(\\(\)*/&\\n/g' | sed 's/\\n\\)$/\\)/')"'\n'"$r,$c="'\(.\)/\1\3\2/;t process_input;'
        done
    done
    empty_field=${empty_field:2} # remove the leading \n
    cleaner='s/.*\n\('"$(echo $empty_field | tr "-" ".")"'\)/\1/'

    # Print completely.
    cat <<HERE
#!/bin/sed -f
:parse
s/\\(.*\\)F/\1=F/
t flagged
$substitutions
:flagged
H
/=9/ b game_over
s/.*/$empty_field/
G
s/\\n\\n/\\n/
:process_input
$process_input
/-/ !b finished
:new_input
p
a\\
Please input new coordinats
d
:game_over
a\\
You lost.
q
:finished
H
s/[^F]//g
$count
/^..*$/t cheater
:won
a\\
Shit this guy is good.
q
:cheater
g
s/\\n[^\\n]*$//
x
$cleaner
b new_input
HERE

} >$outfile

if [ -z $2 ]; then
    echo "Ready."
    sed -f $outfile
    rm $outfile
else
    chmod a+x $outfile
fi





