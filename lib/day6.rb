

fish_data_part1 = File.readlines('data/inputday6.txt').first.chomp.split(",").map!{|e| e.to_i}
fish_data_part2 = File.readlines('data/inputday6.txt').first.chomp.split(",").map!{|e| e.to_i}


def fish_in_days(fish_data,breeding_days)
    breeding_days.times do |day| 
        number_of_new_baby_fish = 0 

        fish_data.each_with_index do |fish, index|
            if fish == 0 
                fish_data[index] = 6 
                number_of_new_baby_fish += 1
            else
                fish_data[index] -=  1
            end
        end

        if number_of_new_baby_fish > 0 
            new_babies = Array.new(number_of_new_baby_fish) { 8 }
            fish_data.concat new_babies
        end 
    end
    return fish_data.group_by(&:itself).map { |k,v| [k, v.count] }.to_h
end


# part 1 - 80 days
#fish_in_days(fish_data_part1, 80)
#p fish_data_part1.count


#calculate how many fish are created in 128 days for a fish at every gestation period (0..8) days
fish_hash =  fish_data_part2.group_by(&:itself).map { |k,v| [k, v.count] }.to_h
core_fish_data = []

(0..8).each {|el| core_fish_data << fish_in_days([el], 128)} 

#{3=>2, 4=>1, 1=>1, 2=>1}
first_pass = Hash.new()
fish_hash.each do |key,value|
    core_fish_data[key].each do |k,v|
        total_fish = v * value
        if first_pass.has_key?(k)
            first_pass[k] += total_fish
        else
            first_pass[k] = total_fish
        end
    end
end

puts first_pass

# Now work out using the fish from the first 128 days, how many fish are made after the next 128 days
second_pass = Hash.new()
first_pass.each do |key,value|
    core_fish_data[key].each do |k,v|
        total_fish = v * value
        if second_pass.has_key?(k)
            second_pass[k] += total_fish
        else
            second_pass[k] = total_fish
        end
    end
end

puts second_pass

p second_pass.values.sum
