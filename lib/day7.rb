crab_data = File.readlines('data/inputday7.txt').first.chomp.split(",").map!{|e| e.to_i}.sort

number_of_crabs_at_each_point =  crab_data.group_by(&:itself).map { |k,v| [k, v.count] }.to_h

min_x = crab_data.min
min_y = crab_data.max

p (min_x..min_y)

def fuel_used(distance)
    counter = 0
    (distance).times {|count| counter += (count + 1)}
    return counter
end

def fuel_to_point(position, number_of_crabs_at_each_point)
    number_of_crabs_at_each_point.map { |crab_position, multiplier| fuel_used((crab_position - position).abs) *  multiplier }.sum
end

distance_to_points = (min_x..min_y).map {|position| fuel_to_point(position, number_of_crabs_at_each_point)}

p distance_to_points.min

