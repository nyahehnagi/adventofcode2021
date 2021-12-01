$LOAD_PATH << './lib'
require 'file_management.rb'
include FileManagement

depth_data =  getData("data/inputday1.txt")

def count_increases(depth_data)
    previous_depth_value = 0
    depth_data.map!(&:to_i)
    count = 0

    depth_data.each_with_index do |element, index|
        if index != 0 
            if element > depth_data[index -1]
                count += 1
            end
        end
    end

    return count
end

def count_increase_three_measurement_window (depth_data)
    depth_data.map!(&:to_i)
    summed_three_measurements = []
    depth_data.each_cons(3) do |element|
        summed_three_measurements << element.sum
    end
    
    return count_increases(summed_three_measurements)
end

puts count_increases(depth_data)
puts count_increase_three_measurement_window(depth_data)