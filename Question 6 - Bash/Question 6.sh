#!/bin/bash

# Read a file line by line.
input="./input.txt"

# Init a variable to switch from the first part to the second.
part='1'
# The -r argument makes it so backslash escapes aren't interpreted, this allows to read every character.
# IFS= makes it so the leading and trailing whitespaces aren't trimmed, by assigning the field seperator (ifs) to an empty string. 
# We || [ -n "$line" ] bash considers a line without any newline as incomplete and thus does not process it, since the line is still read and stored in $line, we can use
# -n to output the incomplete line, though it also works with just "|| [ "$line" ]".'
while IFS= read -r line || [ -n "$line" ]
do
    # Get the line's character length.
    stringLength=${#line}
    # Use a for loop to iterate over the string to a max of i + 3 trailing characters, in order to only check 4 letters long strings.
    for (( i=0; i<$stringLength-3; i++ ))
    do
        # Use a switch case to determine the part we're processing for.
        case $part in 
        '1')
            # Take a 4 character long slice of the string from the current index.
            fourLetterCode=${line:i:4}
            # If all the letters are different.
            if [[ ( ${fourLetterCode:0:1} != ${fourLetterCode:1:1} && ${fourLetterCode:0:1} != ${fourLetterCode:2:1} && ${fourLetterCode:0:1} != ${fourLetterCode:3:1} && ${fourLetterCode:1:1} != ${fourLetterCode:2:1} && ${fourLetterCode:1:1} != ${fourLetterCode:3:1} && ${fourLetterCode:2:1} != ${fourLetterCode:3:1}) ]]
            then
                # Store the answer as the current index + 4, since we start at 0 instead of 1 and since the question is how many characters to generate to get the code.
                ((answer=$i+4))
                # Then return the answer.
                printf "matching code for packet: $fourLetterCode after loading $answer characters \n"
                # And since we're only interested in the first string that matches, switch the part variable.
                part='2'
                # While 14 different characters in a row can't happen before 4, it may be exactly at the same index, so go back once to take this into considerations.
                let "i--"
            fi;;
        '2')
            # Take a 14 character long slice of the string from the current index.
            fourteenLetterCode=${line:i:14}

            # Init a variable to hold the sum of present letters.
            letterSum=0
            # Iterate overall all 26 letters of the alphabet.
            for letter in {a..z}
            do
                # If the letter is in the subset.
                if [[ $fourteenLetterCode == *"$letter"* ]]
                then
                    # Then no matter how many times it appears, add 1 to the sum.
                    let "letterSum++"
                fi
            done
            # If the sum reaches the intended 14 (different characters).
            if [[ $letterSum -ge 14 ]]
            then
                # as in part 1 store the answer but this time with +14
                ((answer=$i+14))
                # Then return the answer.
                printf "matching code for message: $fourteenLetterCode after loading $answer characters \n"
                # All is done, break and stop.
                break
            fi;;
        esac
    done
done <"$input"