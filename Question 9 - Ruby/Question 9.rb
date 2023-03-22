# Create a parent class with all the overlap in methods and arguments between the Head and Knot objects.
class RopeSegment
    def initialize(name)
        # Initialize it with a name and two lists, representing its coordinates in an imaginary grid, as well as it's coordinate history. 
        # We also assign a temporary nil value to the head and tail to this object, 
        # they will both be assigned unless the current segment is itself a topmost head or a bottommost tail.
        @name = name
        @coordinates = [0, 0]
        @personal_history = []
        @personal_head = nil
        @personal_tail = nil
    end

    # Set the head and/or tail of the segment.
    def set_head(head)
        @personal_head = head
    end

    def set_tail(tail)
        @personal_tail = tail
    end

    def move
        # If there is a tail, move it accordingly.
        if @personal_tail
            @personal_tail.move
        end
    end

    # Ruby uses methods to return attributes, so we create a method with the same name as the attributes which sole purpose is to return it's value.
    def personal_history
        return @personal_history
    end

    def coordinates
        return @coordinates
    end

    def personal_head
        return @personal_head
    end

    def personal_tail
        return @personal_tail
    end
end

# Create and object for the head of the rope.
class Head < RopeSegment
    # Move the head given the instructions.
    def move(direction, distance)
        # For each step to the distance variable, move the head along the given value of direction (right, down, left, up).
        for step in 1..distance do
            case direction
                when 'R'
                    @coordinates[1] += 1
                when 'D'
                    @coordinates[0] += 1
                when 'L'
                    @coordinates[1] -= 1
                when 'U'
                    @coordinates[0] -= 1
                else
                    puts "Unknown direction entered, perhaps refrain from leaving the 2D plane."
            end
            # Move the tail if there's one.
            super()
        end
    end
end

# Define a class for a knot in the rope.
class Knot < RopeSegment
    # Move the knot given its head's movements.
    def move
        # Get the tile difference between the head and the tail.
        dif_x, dif_y = self.getDifference
        # If there is a sufficient difference in either x or y, then we need to move.
        if dif_x.abs >= 2
            # Specifically, if there is also a difference of one tile in the other axis, then we need to move in diagonal.
            if dif_y.abs >= 1
                @coordinates[0] += dif_y
            end
            @coordinates[1] += (dif_x / 2)
        elsif dif_y.abs >= 2
            if dif_x.abs >= 1
                @coordinates[1] += dif_x
            end
            @coordinates[0] += (dif_y / 2)
        # If the tail is still attached to the head then we do nothing.
        end

        # Finally, append the current position as a string to the history array.
        @personal_history << @coordinates.join(", ")

        super
    end

    # Get the difference between the head and the knot.
    private def getDifference
        dif_x = @personal_head.coordinates[1] - @coordinates[1]
        dif_y = @personal_head.coordinates[0] - @coordinates[0]
        return dif_x, dif_y
    end
end

# Tidy everything in a neat function. It takes the number of knots, head included, that we desire for our rope.
def answer(knot_count = 10)
    # Hold knot objects in a list.
    knot_list = []

    # Start by creating the lone head element and appending it to the object list.
    knot_list << Head.new('head')
    # Then for every other desired segments:
    for knot in 1..(knot_count-1)
        # Create a knot, with a unique number as name.
        current_knot = Knot.new(knot.to_s)
        # Add this knot object to the object list.
        knot_list << current_knot
    end

    # Once all knots have been generated, set their head and tail attributes.
    # start by setting the tail of the head, since it doesn't have itself a head.
    knot_list[0].set_tail(knot_list[1])
    for i in 1..(knot_count-2)
        # Then iterate over all the knots before the last to assign head and tail. 
        knot_list[i].set_tail(knot_list[i+1])
        knot_list[i].set_head(knot_list[i-1])
    end
    # Then assign just the head of the last knot (tail)
    knot_list[-1].set_head(knot_list[-2])

    # Iterate over the lines.
    File.foreach('input.txt'){ |line|

        # Split the two arguments of the line to get direction and distance.
        command = line.split(' ')
        direction = command[0]
        distance = command[1].to_i
        # Move the head by calling the rope instance's method.
        knot_list[0].move(direction, distance)
    }
    # Get the tail history from the rope instance, only keep unique coordinates, and tally the total. This is the answer.
    puts knot_list[-1].personal_history.uniq.count - knot_count
end

answer
