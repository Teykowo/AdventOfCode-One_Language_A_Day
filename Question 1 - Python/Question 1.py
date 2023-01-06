def idea1():
    # Init a variable to hold the sum of the calories.
    calorySum = 0
    # Init a list to hold all values of the elf's calory sums.
    biggestCaloryBags = []

    # Open the input file in read mode.
    with open('input.txt', 'r') as file:
        # Iterate over each line.
        for item in file.readlines():
            # if there is a blank line, (just the \n character).
            if item == '\n':
                # Then the iteration over the bag is over, hence append the sum to the list and set the calory variable back to 0.
                biggestCaloryBags.append(calorySum)
                calorySum = 0
            # Else then we are still in the same bag.
            else:
                # Hence we increase the calorysum of this bag by the value in the line, for this we change the str to an int by getting rid of the newline character.
                calorySum += int(item.replace('\n', ''))
    # Once all bags have been catalogued, we order them from least to most calories, and fetch the 3 last values that we add together to get the answer.
    return sum(sorted(biggestCaloryBags, reverse = True)[:3])

# Call the function and print the answer.
answer = idea1()
print(answer)
   
