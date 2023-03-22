import re
import manim
import copy

# Create a class that inherits from the manim scene class.
class Question5ManimRenderp2(manim.Scene):
    pass

def answer(self):
    # Open the input file in read mode.
    f = open('input.txt', 'r')

    # Get the first line as an exemple, we'll only need to use it once for the rest of these variables so we access it outside of the main readlines loop.
    first_line = f.readline().strip('\n')
    # Get the length of a single line with which we'll check how many piles there are as well as when to stop looking for crates in a line.
    line_length = len(first_line)
    # Each crate takes 3 characters and are separated by 1 space, we add one to the total length to have a round 4 characters per crate 
    # (since the first crate doesn't have a space before it), we then count the number of piles (max crate per line) by using modulo 4.
    pile_count = (line_length+1) // 4

    # Use the pile count to init a list of lists, each list represent a pile that we'll modify when moving crates.
    piles_list = [[] for _ in range(pile_count)]
    # Make a deep copy of the list for manim squares.
    manim_piles_list = copy.deepcopy(piles_list)

    # Regex pattern to find any capital letters in a text.
    regex_pattern = r'[A-Z]'
    # Regex pattern to find any number in a text.
    regex_pattern2 = r'\d{1,2}'

    # Part count variable to switch between functions while reading the text file, as tell and seek aren't working.
    part_count = 'crates'

    # Go back to the start of the file.
    f.seek(0)
    # Iterate over each line.
    for row in f.readlines():
        match part_count:
            # This case plays before the move commands, when building the crate piles.
            case 'crates':
                # The input is in two parts, first the crates configuration, then the list of move commands. These parts are separated by a line jump. So change 
                # function once we reach the line jump.
                if row == '\n':
                    part_count = 'commands'
                    # ------------------------------- Manim instantiation -------------------------------
                    # Iterate over the crate piles in reverse to build the manim animation.
                    for x_index, x in enumerate(manim_piles_list):
                        for y_index, y in enumerate(x[::-1]):
                            # Create the crate and move it to it's place in space.
                            self.play(manim.Create(y), y.animate.shift((-5 + x_index/2) * manim.RIGHT).shift((-3.5 + y_index/2) * manim.UP), run_time = 0.2)
                    # -----------------------------------------------------------------------------------
                # ---------------------------- Crates Configuration Init ----------------------------
                # Init a row_index variable to advance through the row.
                row_index = 0
                # Iterate over the row, crate by crate untill the index goes further than the line's length.
                while row_index < line_length:
                    # Add 4 to the row index in order to create a subset that only contains the text space taken by one crate and it's following white space.
                    row_next_offset = row_index + 4
                    row_subset = row[row_index:row_next_offset]

                    # Use the regex pattern on the subset to return a list of matches (in this case, a list containing the crate's letter).
                    crate_letter = re.findall(regex_pattern, row_subset, re.M)

                    # If there is no crate in the subset, the list is empty, so append to the list only if need be.
                    if len(crate_letter) > 0:
                        piles_list[row_next_offset//4 - 1].append(crate_letter[0])

                        # Create a group to have text inside a square, making the crate.
                        crate = manim.VGroup()
                        # Create a red square.
                        square = manim.Square(fill_color = manim.RED, side_length = 0.5)
                        # Create a text centered relative to the square.
                        text = manim.Text(crate_letter[0], font_size=20).move_to(square.get_center())
                        # Add both objects to the "crate" groupe.
                        crate.add(square, text)
                        # Append the crate object to the manim object list.
                        manim_piles_list[row_next_offset//4 - 1].append(crate)

                    # The next starting point for the row subset is the current end point.
                    row_index = row_next_offset
                # -----------------------------------------------------------------------------------
            # This case plays when iterating the move commands.
            case 'commands':
                # Use a regex to find the three numbers used in the move command: move x, from y, to z.
                move_order = re.findall(regex_pattern2, row, re.M)
                # Store the numbers returned by the regex with more understandable variable names.
                move_x = int(move_order[0])
                from_y = int(move_order[1])-1
                to_z = int(move_order[2])-1

                # Get the piles to move the crates from and to (-1 since the numbers given start at 1 instead of 0)
                from_pile = piles_list[from_y]
                to_pile = piles_list[to_z]

                # Get the manim piles too in order to move the correct crates.
                from_pile_manim = manim_piles_list[from_y]
                to_pile_manim = manim_piles_list[to_z]

                # ---------------------------------- Part 1 Answer ----------------------------------
                # For each crate to move:
                # for _ in range(move_x):
                #     # Get the crate by poping it from it's pile at the last index.
                #     moved_crate = from_pile.pop(0)
                #     # And putting it on top of the target pile.
                #     to_pile.insert(0, moved_crate)

                #     # Get the number of piles to move the crate from in manim.
                #     x_offset = to_z - from_y
                #     # Also get the difference in height between the previous location and the new one.
                #     y_offset = (len(to_pile_manim) - len(from_pile_manim)) + 1
                #     # Pop the crate from the last index in the manim pile all the same as before.
                #     moved_manim_crate = from_pile_manim.pop(0)
                #     # Move the crate using manim's play function.
                #     self.play(moved_manim_crate.animate.shift((x_offset/2) * manim.RIGHT).shift((y_offset/2) * manim.UP), run_time = 0.1)
                #     # Add the crate to the "to" manim pile.
                #     to_pile_manim.insert(0, moved_manim_crate)
                # -----------------------------------------------------------------------------------
                # ---------------------------------- Part 2 Answer ----------------------------------
                # Select all the crates that we need to move from a pile. 
                selected_crates = from_pile[:move_x]
                # Modify the target pile to be equal to the selected crates followed by the crates already in the pile.
                piles_list[to_z] = selected_crates + to_pile
                # Delete the crates from the old pile.
                del from_pile[:move_x]

                # Compute the x and y displacement.
                x_offset = to_z - from_y
                y_offset = (len(to_pile_manim) - len(from_pile_manim)) + move_x
                # Select the crates in the manim pile
                selected_crates_manim = from_pile_manim[:move_x]
                # and do the same as before but in the manim lists.
                manim_piles_list[to_z] = selected_crates_manim + to_pile_manim
                del from_pile_manim[:move_x]
                # Create a group in which to put all the crates to move.
                selected_crates_group_manim = manim.VGroup()
                # Fill this group with the crates.
                for manim_crate in selected_crates_manim:
                    selected_crates_group_manim.add(manim_crate)
                # Move this group to it's intended place.
                self.play(selected_crates_group_manim.animate.shift((x_offset/2) * manim.RIGHT).shift((y_offset/2) * manim.UP), run_time = 0.1)
                # -----------------------------------------------------------------------------------
    f.close()
    print(piles_list)
# Manim uses the construct method of the custom scene-inheriting class to create the video.
Question5ManimRenderp2.construct = answer