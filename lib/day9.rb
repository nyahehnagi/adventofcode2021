$LOAD_PATH << './lib'
require 'file_management.rb'
require 'benchmark'

include FileManagement

#create array of arrays
height_map =  getData("data/inputday9test.txt").map{|row| row.split("").map(&:to_i)}

# hash look up for checking data that conforms
low_points = Hash.new()

#look at each row and see if criteria of adjacents are higher is true
height_map.each_with_index do |row, row_index|
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

transposed_heights =  height_map.transpose

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

# PART 2






=begin
2199943210
3987894921
9856789892
8767896789
9899965678
=end