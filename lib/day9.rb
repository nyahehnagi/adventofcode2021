$LOAD_PATH << './lib'
require 'file_management.rb'
require 'benchmark'

include FileManagement

#create array of arrays
$height_map =  getData("data/inputday9.txt").map{|row| row.split("").map(&:to_i)}

# hash look up for checking data that conforms
low_points = Hash.new()

#look at each row and see if criteria of adjacents are higher is true
$height_map.each_with_index do |row, row_index|
    row.each_with_index do |height, col_index|
        # make sure we are not at the end of the array
        last_index = row.rindex(row.last)
        if col_index < last_index
            if height < row[col_index + 1]
                # is it lower than previous?
                if col_index -1 >=  0 && height < row[col_index - 1]
                    # we good.. add it
                    low_points[[row_index,col_index]] = height
                else
                    # first in the list and less than next so add it
                    if col_index == 0
                        low_points[[row_index,col_index]] = height
                    else
                        # remove the height.
                        low_points.delete([row_index,col_index])
                    end
                end
            else
                # add the next one - we may delete it later if it does not conform
                low_points[[row_index,col_index + 1]] = row[col_index + 1]  
                # delete the current lowest point if it's there as we know it's not less than the next value
                low_points.delete([row_index,col_index])
            end
        end
    end
end

transposed_heights =  $height_map.transpose

#transpose and check adjacency
transposed_heights.each_with_index do |row, row_index|
    row.each_with_index do |height, col_index|
        # make sure we are not at the end of the array
        last_index = row.rindex(row.last)
        if col_index < last_index
            # only look at heights determined when we looked at the rows as we know these points are currently valid
            if low_points.key?([col_index,row_index])

                if height < row[col_index + 1]
                    # Check the previous record in the column to make sure it continues to conform 
                    # and we're not at the start of the column array
                    if col_index -1 >= 0 && height < row[col_index - 1]
                        # we good.. keep it
                    else
                        if col_index != 0
                            low_points.delete([col_index,row_index])
                        end
                    end
                else
                    # delete the current value as it does not conform
                    low_points.delete([col_index,row_index])
                end
            end
        elsif col_index == last_index
            if height < row[col_index - 1]
                # we good.. keep it
            else
                low_points.delete([col_index,row_index])
            end
        end
    end
end


p low_points
p low_points.map{|k,v| v + 1}.sum

#MESSY RECURSION :) Needs some serious tidying up
# PART 2
heights_visited = Hash.new()
$max_y = $height_map.rindex($height_map.last)
$max_x = $height_map[0].rindex($height_map[0].last)

def basin_count(location, visited)

    y_value = location[0]
    x_value = location[1]
    
    store_location = false

    p "Location is : #{location}"
    p  "Locations visited so far before check #{visited}"
    #p x_value
    #p y_value
    # have we been here before, if so, exit
    if visited.key?(location) == true
        p "We've been here before. Exiting function"
        return visited
    end

    visited[[y_value,x_value]] = 1
    p  "Locations visited so far #{visited}"

    #Look Up
    if y_value - 1 >= 0
        next_y = y_value - 1
        if $height_map[next_y][x_value] < 9  
            p "Looking Up Check"
            store_location = true
            #go take a look at the next location
            basin_count([next_y,x_value],visited)
        end
    end
    #Look Right
    if x_value + 1 <= $max_x
        p "Looking Right Check"
        next_x = x_value + 1
        p "Value to the right is #{$height_map[y_value][next_x]}"
        p "Y : #{y_value} -  X : #{next_x}"
        if $height_map[y_value][next_x] < 9 && visited
            store_location = true
            #go take a look at the next location
            basin_count([y_value,next_x],visited)
        else
            p "Item to Right is 9"
        end
    end
    #Look left
    if x_value - 1 >= 0
        p "Looking Left Check"
        next_x = x_value - 1
        p "Value to the left is #{$height_map[y_value][next_x]}"
        if $height_map[y_value][next_x] < 9
            p "Going Left Y : #{y_value} -  X : #{next_x}"
            store_location = true
            #go take a look at the next location
            basin_count([y_value,next_x],visited)
        else
            p "Item to left is less than 0"
        end
    end
    #Look Down
    if y_value + 1 <= $max_y
        p "Looking Down Check"
        next_y = y_value + 1
        if $height_map[next_y][x_value] < 9
            #go take a look at the next location
            basin_count([next_y,x_value],visited)
        end
    end

    return visited
end

#p basin_count([4,6],heights_visited).count

p low_points.map{|point, value| basin_count(point,Hash.new()).count}.sort.last(3)

#.inject(1){|sum, item| sum *= item }

#[99, 111, 115]
=begin
2199943210
3987894921
9856789892
8767896789
9899965678
=end