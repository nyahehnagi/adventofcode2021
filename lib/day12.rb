$LOAD_PATH << './lib'
require 'file_management.rb'

include FileManagement

caves_map =  getData("data/inputday12.txt")

cave_system = Hash.new()

caves_map.each do |item|
    tmp =  item.split("-")
    if cave_system.has_key?(tmp[0])
        cave_system[tmp[0]] <<  tmp[1]
    else
        cave_system[tmp[0]] = [tmp[1]]
    end
end

p cave_system
# Good read regarding this
# https://joshgoestoflatiron.medium.com/december-28-finding-paths-on-a-grid-in-ruby-with-recursion-53e83bfa99e8


def in_path_so_far(path, cave)
    # when I am not tired, I will pull out the below programatically
    small_caves = ["qu","vi","ae","pk","vt","hu"]
    #small_caves = ["b","c","d"]
    if small_caves.include?(cave)
        if path.count("qu") == 2 || path.count("vi") == 2 || path.count("ae") == 2 || path.count("pk") == 2 || path.count("vt") == 2 || path.count("hu") == 2 
        #if path.count("b") == 2 || path.count("c") == 2 || path.count("d") == 2
            if path.count(cave) == 0
                return false
            else
                return true
            end
        else
            return false
        end
    else
        retval = path.any? {|c| c == cave && cave == cave.downcase} 
    end
end


def adjacent_caves(cave_system, cave)


    adjacent_cave_list = []
    #check keys
    if cave_system.has_key?(cave) 
        cave_system.values_at(cave).each do |cave|
            cave.each {|cave| adjacent_cave_list << cave}
        end
    end

    #check values
    cave_system.filter{|k, v| v.include?(cave)}.each_key do |cave|
        if !adjacent_cave_list.include?(cave)
            adjacent_cave_list << cave
        end
    end

    return adjacent_cave_list
end

def possible_paths(cave_system, current_cave, destination, path_so_far, path_list )
    
    if current_cave == destination
       path_so_far.push(current_cave)
       path_list << path_so_far
    else
       adjacent_caves(cave_system, current_cave).each do | adjacent_cave |
          if !in_path_so_far(path_so_far, current_cave)
             next_possible_path = path_so_far.clone.push(current_cave)
             possible_paths(cave_system, adjacent_cave, destination, next_possible_path, path_list )
          end
       end
    end
 end

 
path_so_far = []
path_list = []
start_cave = "start"
end_cave = "end"

possible_paths(cave_system, start_cave, end_cave, path_so_far, path_list)
path_list.each {|item| p item}
print path_list.count

