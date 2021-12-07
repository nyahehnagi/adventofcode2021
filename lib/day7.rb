crab_data = File.readlines('data/inputday7.txt').first.chomp.split(",").map!{|e| e.to_i}.sort

number_of_crabs_at_each_point =  crab_data.group_by(&:itself).map { |k,v| [k, v.count] }.to_h

#min and max values for the horizontal positions
min_x = crab_data.min
min_y = crab_data.max


def fuel_used(distance)
    fuel_used = 0
    (distance).times {|count| fuel_used += (count + 1)}
    return fuel_used
end

# create look up for fuel used for the range of distances available
fuel_look_up = (min_x..min_y).map{|distance| [distance, fuel_used(distance)]}.to_h

def fuel_to_point(position, number_of_crabs_at_each_point, fuel_look_up)
    number_of_crabs_at_each_point.map { |crab_position, multiplier| fuel_look_up[(crab_position - position).abs] *  multiplier }.sum
end

fuel_to_all_points = (min_x..min_y).map {|position| fuel_to_point(position, number_of_crabs_at_each_point, fuel_look_up)}

p fuel_to_all_points.min

