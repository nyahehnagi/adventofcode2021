
class Submarine

    attr_reader :depth, :horizontal_distance

    def initialize
        @depth = 0
        @horizontal_distance = 0
        @aim = 0
    end

    DIRECTION = {
        forward: "forward",
        down: "down",
        up: "up"
      }

    def move_instruction(instruction)
        instructions = instruction.split()
        move(instructions[0], instructions[1].to_i)
    end

    def move (direction, distance)
        case direction
        when DIRECTION[:forward]
            @horizontal_distance += distance
            @depth += (@aim * distance)
        when  DIRECTION[:down]
            @aim += distance
        when  DIRECTION[:up]
            @aim -= distance
        else
            #in error, do nothing for the time being
        end
    end
end

