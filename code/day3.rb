$LOAD_PATH << './lib'
require 'file_management.rb'
require 'class_submarine.rb'

include FileManagement

diagnostic_report =  getData("data/inputday3.txt")

split_bits = []
bit_hash = Hash.new()

#split each binary number into individual bits 
diagnostic_report.map do |lines|
        split_bits << lines.split('')
end

#transpose the bits
split_bits.each do |element|
    element.each_with_index do |bit, index|
        bit_hash.key?(index)  ? bit_hash[index] << bit : bit_hash[index] = bit
    end
end

#part 1
#find gamma rate
gamma_rate_binary = ""
bit_hash.each_value do |bits|
    bits.count('1') > bits.count('0') ? gamma_rate_binary.concat("1") : gamma_rate_binary.concat("0")
end

gamme_rate_decimal = gamma_rate_binary.to_i(2)

#find epsilon rate - flip the bits using XOR
bit_mask = "1" * gamma_rate_binary.length 
epsilon_rate_decimal =  gamme_rate_decimal ^ bit_mask.to_i(2)

#output part 1 answer
puts epsilon_rate_decimal * gamme_rate_decimal



#part 2

#create copy of bit_hash to work on
def deep_copy(o)
    Marshal.load(Marshal.dump(o))
end

bit_hash_oxygen = deep_copy(bit_hash)
bit_hash_co2  = deep_copy(bit_hash)

#remove characters at specified indices
def remove_chars(str, indices)      
    indices.sort.reverse_each { |i| str[i] = '' }
    str
end

bit_hash_oxygen.each_value do |bits|
    # if we have one value left in our hash.. we have our value
    break if bit_hash_oxygen[0].length == 1
    
    if bits.count('1') >= bits.count('0') 
        # keep the ones
        indexes_to_delete = []
        bits.each_char.with_index do |bit, index|
            if bit == "0"
                indexes_to_delete << index
            end 
        end

        #delete the values at specified index per key
        bit_hash_oxygen.each_value do |bits|
            bits = remove_chars(bits,indexes_to_delete)
        end

    else
        #keep the zeroes
        indexes_to_delete = []
        bits.each_char.with_index do |bit, index|
            if bit == "1"
                indexes_to_delete << index
            end 
        end
        #delete the values at specified index per key
        bit_hash_oxygen.each_value do |bits|
            bits = remove_chars(bits,indexes_to_delete)
        end
    end
    
end

bit_hash_co2.each_value do |bits|
    # if we have one value left in our hash.. we have our value
    break if bit_hash_co2[0].length == 1
    
    if bits.count('1') == bits.count('0') 
        # keep the zeros
        indexes_to_delete = []
        bits.each_char.with_index do |bit, index|
            if bit == "1"
                indexes_to_delete << index
            end 
        end

        #delete the values at specified index per key
        bit_hash_co2.each_value do |bits|
            bits = remove_chars(bits,indexes_to_delete)
        end

    elsif bits.count('1') < bits.count('0') 
        # keep the ones
        indexes_to_delete = []
        bits.each_char.with_index do |bit, index|
            if bit == "0"
                indexes_to_delete << index
            end 
        end
        #delete the values at specified index per key
        bit_hash_co2.each_value do |bits|
            bits = remove_chars(bits,indexes_to_delete)
        end

    else
        #keep the zeroes
        indexes_to_delete = []
        bits.each_char.with_index do |bit, index|
            if bit == "1"
                indexes_to_delete << index
            end 
        end
        #delete the values at specified index per key
        bit_hash_co2.each_value do |bits|
            bits = remove_chars(bits,indexes_to_delete)
        end
    end
end
   
puts bit_hash_oxygen
puts bit_hash_co2
#convert to string an decimalise
oxygen_string = ""
co2_string = ""
bit_hash_oxygen.each_value{|v| oxygen_string += v}
bit_hash_co2.each_value{|v| co2_string += v}

puts oxygen_string.to_i(2)
puts co2_string.to_i(2)

puts oxygen_string.to_i(2) * co2_string.to_i(2)


