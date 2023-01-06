# Init a range of values where we'll look for the duplicate's value.
my $littleLettersRange = 'a'..'z';
my $littleBigLettersRange = 'A'..'Z';

my Int $littleAnswer;

# Iterate over lines in the txt file.
for 'input.txt'.IO.lines {
    # Store the value of half the size of the line (not passing a variable using for allows to call methods without specifying on what, there is a hidden $_ variable)
    my $rucksackHalf = .chars / 2;
    # Use comb to convert string to array and split it in $rucksackHalf sized batches using rotor.
    my $rucksacks = .comb.rotor($rucksackHalf);
    # Iterate over the first half.
    for $rucksacks[0] -> $letter {
        # If the second half contains the letter:
        if $rucksacks[1].Str.contains($letter) {
            # get the index of the letter in either the lowercase list,
            my $priorityValue = $littleLettersRange.first($letter, :k);
            # or the uppercase list.
            $priorityValue //= $littleBigLettersRange.first($letter, :k) + 26;
            # Append the priority score to the answer sum.
            $littleAnswer += $priorityValue + 1;

            # End the loop if we found the common letter.
            last if True;
        };
    };
};
# Print the answer.
say $littleAnswer;



my Int $littleAnswer2;

# Iterate over lines in the txt file 3 by 3.
for 'input.txt'.IO.lines -> $lineA, $lineB, $lineC {  
    # Iterate over the first line.
    for $lineA.comb -> $letter {
        # If both the other lines contains the letter:
        if $lineB.contains($letter) && $lineC.contains($letter) {
            # get the index of the letter in either the lowercase list,
            my $priorityValue = $littleLettersRange.first($letter, :k);
            # or the uppercase list.
            $priorityValue //= $littleBigLettersRange.first($letter, :k) + 26;
            # Append the priority score to the answer sum.
            $littleAnswer2 += $priorityValue + 1;

            # End the loop if we found the common letter.
            last if True;
        };
    };
};
# Print the answer.
say $littleAnswer2;