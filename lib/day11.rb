$LOAD_PATH << './lib'
require 'file_management.rb'

include FileManagement

octopi =  getData("data/inputday11.txt")

def print_cave(octomap, size)
    for y in 0..size do
        str = ""
        for x in 0..size do
            str += " #{octomap[[x,y]].energy}"
        end
        puts str
    end
end

class Octopus
    attr_accessor :flashed, :energy

    def initialize(energy)
        @flashed = false
        @energy = energy
    end
end

class OctopusCavern

    attr_reader :octopus_map, :flash_count

    def initialize(octopi)
        @octopus_map = populate_octopi(octopi)
        @flash_count = 0
    end

    def populate_octopi(octopi)
        
        octopus_map = Hash.new()

        octopi.each_with_index do |line, y|
            line.split("").each_with_index do |energy, x|
                octopus = Octopus.new(energy.to_i)
                octopus_map[[x,y]] = octopus
            end
        end

        return octopus_map
    end

    def reset_flashes()
        @octopus_map.each_value {|octopus| octopus.flashed = false}        
    end

    def any_octopus_to_flash()
        any_flashes = false
        @octopus_map.each_value do |octopus| 
            if octopus.flashed == false && octopus.energy == 0
                any_flashes = true
                break
            end
        end
        return any_flashes
    end

    def octopus_cycle()
        # reset flash status
        reset_flashes

        # update every energy level by 1
        @octopus_map.each_key do |key| 
            update_energy_of_octopos(key, 1)
        end  

        while any_octopus_to_flash do
            neighbours = []
            @octopus_map.each do |position, octopus|
                # Only look at octopi who have not flashed and are at zero energy
                if octopus.flashed == false && octopus.energy == 0
                    positions = []
                    positions += position
                    # the octopus flashes
                    octopus.flashed = true
                    @flash_count += 1
                    # get the neighbouring octopus
                    neighbours += get_neighbours(position)
                end                
            end

            neighbours.group_by(&:itself).map { |k,v| [k, v.count] }.to_h.each do |position, amount|
                update_energy_of_octopos(position, amount)
            end
        end

        puts "END STATE "
        print_cave(@octopus_map, 9)
    end

    def all_octopus_flashed?()
        @octopus_map.values.inject(0) {|sum, value| sum + value.energy} == 0 ? true : false
    end

    def update_energy_of_octopos(key, amount)
        # Only update if not in status flashed
        if @octopus_map[key].flashed == false
            if @octopus_map[key].energy + amount > 9
                @octopus_map[key].energy = 0
            else     
                @octopus_map[key].energy += amount
            end
        end
    
    end
    # returns the neighbours adjacent and diagonally of a passed Octopus position
    def get_neighbours(position)
        neighbours = []
        x = position[0]
        y = position[1]
        max = 9
        # get left neighbour
        if x - 1 >= 0
            neighbours << [x-1, y]
        end
        #get right neighbour
        if x + 1 <= max
            neighbours << [x + 1, y]
        end
        # get above neighbour
        if (y - 1) >= 0
            neighbours << [x, y - 1]
        end

        #get down neighbour
        if y + 1 <= max
            neighbours << [x , y + 1]
        end

        #get top left diagonal
        if x - 1 >= 0 && y - 1 >= 0
            neighbours << [x - 1, y - 1]
        end

        #get top right diagonal
        if x + 1 <= max && y - 1 >= 0
            neighbours << [x + 1, y - 1]
        end
        #get bottom left diagonal
        if x - 1 >= 0 && y + 1 <= max
            neighbours << [x - 1, y + 1]
        end
        #get bottom right diagonal
        if x + 1 <= max && y + 1 <= max
            neighbours << [x + 1, y + 1]
        end

        return neighbours

    end
end

octopus_map = OctopusCavern.new(octopi)

#PART 1
100.times {octopus_map.octopus_cycle}
p octopus_map.flash_count

#PART 2
octopus_map_part_two = OctopusCavern.new(octopi)
counter = 0
while octopus_map_part_two.all_octopus_flashed? == false do
    octopus_map_part_two.octopus_cycle
    counter += 1
end
p "All flashed #{counter}"
