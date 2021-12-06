
$LOAD_PATH << './lib'
require 'file_management.rb'
require 'benchmark'

include FileManagement

vent_data =  getData("data/inputday5.txt")

#remove the "->"
coordinate_vent_data = vent_data.map {|line| line.split().reject{|line| line == "->"}}
#remove the commas
flat_coordinate_vent_data = coordinate_vent_data.map {|item| item[0].split(",").map(&:to_i) + item[1].split(",").map(&:to_i)}.flatten

parsed_vent_data = []
flat_coordinate_vent_data.each_slice(4) do |coord|
    first_coord =[coord[0],coord[1]]
    second_coord = [coord[2],coord[3]]
    pair_of_points = [first_coord,second_coord]
    parsed_vent_data << pair_of_points
end

list_of_vent_points = []
# create a list of horizontal,  vertical and diagonal points intersected

parsed_vent_data.each do |item|
    x1 = item[0][0]
    x2 = item[1][0]
    y1 = item[0][1]
    y2 = item[1][1]

    # check for x1 = x2
    if x1 == x2
        min_y = [y1, y2].min
        counter = (y1 - y2).abs + 1
        counter.times do |count|
            list_of_vent_points << [x1,  count + min_y]
        end
        
    # y1 = y2
    elsif y1 == y2
        min_x = [x1, x2].min
        counter = (x1 -x2).abs + 1
        counter.times do |count|
            list_of_vent_points << [min_x + count,y1]
        end
    #diagonal
    else
        min_x = [x1, x2].min
        max_x = [x1, x2].max
        min_y = [y1, y2].min
        max_y = [y1, y2].max
        counter = (x1 -x2).abs + 1

        if x1 < x2 && y1 < y2
            # add to x , add to y
            counter.times do |count| 
                list_of_vent_points << [min_x + count,min_y + count]
            end
        elsif x1 < x2 && y1 > y2
            # add to x, take away from y
            counter.times do |count| 
                list_of_vent_points << [min_x + count,max_y - count]
            end
        elsif y1 < y2
            # subtract from x, add to y    
            counter.times do |count| 
                list_of_vent_points << [max_x - count,min_y + count]
            end
        else
            # subtract from x and y    
            counter.times do |count| 
                list_of_vent_points << [max_x - count,max_y - count]
            end
        end
    end
end

# group by the coords in the array, count them and then count where we have 2 or more on the same coordinate
p list_of_vent_points.group_by(&:itself).map { |k,v| [k, v.count] }.to_h.select{|k,v| v > 1}.count
